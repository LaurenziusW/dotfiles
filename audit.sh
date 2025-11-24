#!/bin/bash

# Configuration
REPO_DIR="$HOME/dotfiles"
echo "🔍 Starting Config Audit & Repo Upgrade..."

# ==============================================================================
# PART 1: AUDIT - Check Local vs. Repo
# ==============================================================================
echo ""
echo "📊 PART 1: Checking for Configuration Drift"
echo "   (Comparing Active System Files vs. Repo Versions)"
echo "   ---------------------------------------------"

# Helper function to check diff
check_diff() {
    local name="$1"
    local repo_file="$2"
    local system_file="$3"

    printf "%-15s " "[$name]"

    if [ ! -f "$repo_file" ]; then
        echo "⚠️  MISSING IN REPO ($repo_file)"
        return
    fi

    if [ ! -f "$system_file" ]; then
        echo "⚠️  MISSING ON SYSTEM ($system_file)"
        return
    fi

    # Check if it's a symlink pointing to the repo
    if [[ -L "$system_file" && "$(readlink "$system_file")" == *"$repo_file"* ]]; then
        echo "✅ SYNCED (Symlinked)"
    else
        # It's a physical file, check contents
        if cmp -s "$repo_file" "$system_file"; then
             echo "✅ IDENTICAL (But not symlinked)"
        else
             echo "❌ DRIFT DETECTED (Content differs)"
             echo "   Run: diff \"$repo_file\" \"$system_file\""
        fi
    fi
}

# Define the mappings (Repo Path -> System Path)
# We assume the repo structure we defined (Stow standard)
check_diff "zshrc"    "$REPO_DIR/zsh/.zshrc"                "$HOME/.zshrc"
check_diff "wezterm"  "$REPO_DIR/wezterm/.wezterm.lua"      "$HOME/.wezterm.lua"
check_diff "tmux"     "$REPO_DIR/tmux/.tmux.conf"           "$HOME/.tmux.conf"
check_diff "nvim"     "$REPO_DIR/nvim/.config/nvim/init.lua" "$HOME/.config/nvim/init.lua"
check_diff "skhd"     "$REPO_DIR/skhd/.config/skhd/skhdrc"  "$HOME/.config/skhd/skhdrc"
check_diff "yabai"    "$REPO_DIR/yabai/.config/yabai/yabairc" "$HOME/.config/yabai/yabairc"

echo ""
echo "ℹ️  If you see 'DRIFT DETECTED', your local file has changes not in the repo."
echo "   To overwrite local changes with Repo versions, run: ./install.sh (created below)"

# ==============================================================================
# PART 2: UPGRADE - Create New Files
# ==============================================================================
echo ""
echo "🏗️  PART 2: Generating New Infrastructure"
echo "   (Creating Installers, AI Scripts, and Documentation)"
echo "   ---------------------------------------------"

# 1. Create Directories
mkdir -p "$REPO_DIR"/{local-bin,workflow/bunches,scripts/maintenance}
mkdir -p "$REPO_DIR"/docs/{01-setup,02-reference,03-configs,04-management}

# 2. Generate install.sh
echo "⚡ Creating install.sh..."
cat << 'EOF' > "$REPO_DIR/install.sh"
#!/bin/bash
# Master Installer - Symlinks dotfiles using Stow
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DOTFILES_DIR"

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    FOLDERS="local-bin workflow nvim wezterm zsh tmux yabai skhd"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    FOLDERS="local-bin workflow nvim wezterm zsh tmux hyprland"
fi

echo "🚀 Linking for $OS..."
for folder in $FOLDERS; do
    if [ -d "$folder" ]; then
        echo "🔗 Stowing $folder..."
        stow -R "$folder"
    else
        echo "⚠️  Skipping $folder (not found)"
    fi
done
echo "✅ Done."
EOF
chmod +x "$REPO_DIR/install.sh"

# 3. Generate collect-for-ai.sh
echo "🧠 Creating scripts/maintenance/collect-for-ai.sh..."
cat << 'EOF' > "$REPO_DIR/scripts/maintenance/collect-for-ai.sh"
#!/bin/bash
# Dumps repo context for LLMs
OUTPUT="dotfiles-context.tar.gz"
echo "📦 Packing dotfiles context..."
tar --exclude='.git' --exclude='*.tar.gz' --exclude='.DS_Store' \
    -czf "$OUTPUT" -C "$HOME/dotfiles" .
echo "✅ Context ready: $OUTPUT"
EOF
chmod +x "$REPO_DIR/scripts/maintenance/collect-for-ai.sh"

# 4. Generate gather-current-space
echo "🪟 Creating local-bin/gather-current-space..."
cat << 'EOF' > "$REPO_DIR/local-bin/gather-current-space"
#!/bin/bash
# Gather all windows to current space (Requires yabai & jq)
if ! command -v yabai &> /dev/null; then echo "Error: yabai missing"; exit 1; fi
CURRENT=$(yabai -m query --spaces --space | jq '.index')
echo "Gathering windows to Space $CURRENT..."
yabai -m query --windows | jq -r ".[] | select(.space != $CURRENT) | .id" | xargs -I{} yabai -m window {} --space $CURRENT
EOF
chmod +x "$REPO_DIR/local-bin/gather-current-space"

# 5. Generate Documentation
echo "📚 Generating Documentation..."

# README.md
cat << 'EOF' > "$REPO_DIR/docs/README.md"
# Unified Keyboard Environment
**Single Source of Truth for macOS & Linux Workflows**

## 📂 Structure
- **install.sh**: Run this to symlink everything.
- **local-bin/**: Scripts added to your PATH (e.g., `gather-current-space`).
- **workflow/**: Your Bunches context definitions.
- **scripts/maintenance/**: Tools for maintaining this repo (AI handoff).
- **docs/**: Full system documentation.

## ⌨️ Quick Reference
| Keys | Action |
|---|---|
| **Caps+H/J/K/L** | Navigation (Arrows) |
| **Cmd+H/J/K/L** | Window Focus |
| **Cmd+Shift+1-9** | Move Window to Workspace |
| **Cmd+Ctrl+1-5** | Switch Context (Bunch) |
| **Cmd+`** | Gather Windows Here |
EOF

# Shortcuts Reference
cat << 'EOF' > "$REPO_DIR/docs/02-reference/KEYBOARD-SHORTCUTS.md"
# Keyboard Shortcuts (Stable)

## Navigation Layer (Caps Lock)
- **H/J/K/L**: Arrow Keys
- **F/G**: Word Movement
- **Space**: Enter / Escape (Tap)

## Window Layer (Cmd / Alt)
- **Cmd + H/J/K/L**: Focus Window
- **Cmd + Shift + H/J/K/L**: Move Window
- **Cmd + Enter**: Terminal
- **Cmd + T**: Float/Tile Toggle

## Workflow Layer (Cmd+Ctrl)
- **1**: Study Math
- **2**: Guitar
- **3**: Coding
- **4**: Email/Admin
- **`**: Gather Windows
EOF

echo "✅ All new files created in $REPO_DIR"
echo "👉 You can now run './install.sh' inside $REPO_DIR to enforce these configs."
