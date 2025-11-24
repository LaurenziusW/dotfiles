#!/bin/bash

REPO_DIR="$HOME/dotfiles"
echo "🔄 Sourcing Truth from Remote..."

# 1. GET THE TRUTH (Git Pull)
# ---------------------------------------------------------
if [ -d "$REPO_DIR" ]; then
    cd "$REPO_DIR"
    echo "⬇️  Pulling latest stable configs..."
    # We pull to ensure we have the skhd/yabai files that were missing in your audit
    git pull
else
    echo "❌ Error: $REPO_DIR does not exist."
    exit 1
fi

# 2. CREATE INFRASTRUCTURE (The "New Files")
# ---------------------------------------------------------
echo "🏗️  Building Repo Infrastructure..."

# Create directories
mkdir -p "$REPO_DIR"/{local-bin,workflow/bunches,scripts/maintenance}
mkdir -p "$REPO_DIR"/docs/{01-setup,02-reference,03-configs,04-management}

# A. Generate 'install.sh' (The Enforcer)
# This script detects if a local file exists (drift) and backs it up before linking the stable version.
cat << 'EOF' > "$REPO_DIR/install.sh"
#!/bin/bash
# Master Installer - Enforces Remote Stable State
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
cd "$DOTFILES_DIR"

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    FOLDERS="local-bin workflow nvim wezterm zsh tmux yabai skhd"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    FOLDERS="local-bin workflow nvim wezterm zsh tmux hyprland"
fi

echo "🚀 Enforcing Stable Configs for $OS..."

# Function to safely link folders
link_folder() {
    local folder=$1
    echo "🔗 Processing $folder..."
    
    # Check for conflicts (Dry Run)
    CONFLICTS=$(stow -n -v "$folder" 2>&1 | grep "existing target is" | awk '{print $NF}')
    
    if [ ! -z "$CONFLICTS" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "   ⚠️  Conflict detected. Backing up local drift to $BACKUP_DIR"
        for file in $CONFLICTS; do
            # Move the conflicting file (relative to HOME)
            # This respects "Remote is Stable" by moving local drift aside
            mv "$HOME/$file" "$BACKUP_DIR/$(basename $file).bak"
            echo "      moved: $file -> $BACKUP_DIR"
        done
    fi
    
    # Link the stable version
    stow -R "$folder"
}

for folder in $FOLDERS; do
    if [ -d "$folder" ]; then
        link_folder "$folder"
    else
        echo "⚠️  Skipping $folder (not found in repo)"
    fi
done

echo "✅ System is now synced with Stable Repo."
EOF
chmod +x "$REPO_DIR/install.sh"

# B. Generate 'collect-for-ai.sh'
cat << 'EOF' > "$REPO_DIR/scripts/maintenance/collect-for-ai.sh"
#!/bin/bash
OUTPUT="dotfiles-context.tar.gz"
echo "📦 Packing repo context..."
tar --exclude='.git' --exclude='*.tar.gz' --exclude='.DS_Store' \
    -czf "$OUTPUT" -C "$HOME/dotfiles" .
echo "✅ Context ready: $OUTPUT"
EOF
chmod +x "$REPO_DIR/scripts/maintenance/collect-for-ai.sh"

# C. Generate 'gather-current-space' (The missing util referenced in skhdrc)
cat << 'EOF' > "$REPO_DIR/local-bin/gather-current-space"
#!/bin/bash
# Gather windows to current space (Stable Logic)
if ! command -v yabai &> /dev/null; then echo "Error: yabai missing"; exit 1; fi
CURRENT=$(yabai -m query --spaces --space | jq '.index')
echo "Gathering windows to Space $CURRENT..."
yabai -m query --windows | jq -r ".[] | select(.space != $CURRENT) | .id" | xargs -I{} yabai -m window {} --space $CURRENT
EOF
chmod +x "$REPO_DIR/local-bin/gather-current-space"

# 3. GENERATE DOCUMENTATION
# ---------------------------------------------------------
echo "📚 Generating Documentation..."

# README.md
cat << 'EOF' > "$REPO_DIR/docs/README.md"
# Unified Keyboard Environment
**Single Source of Truth (Stable Remote)**

## 🏗️ Architecture
All configurations in this repository are considered **Stable**. Local changes on machines are considered **Drift**.
Run `./install.sh` to enforce this repository's state onto the local system.

## 📂 Structure
- **install.sh**: The enforcer. Backs up local drift and links repo files.
- **local-bin/**: Scripts added to PATH (includes `gather-current-space`).
- **workflow/**: Context definitions (Bunches).
- **docs/**: Reference documentation.
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

echo "✅ SUCCESS."
echo "   1. Repo updated from Remote (Git Pull)."
echo "   2. Infrastructure scripts created (install.sh, etc)."
echo "   3. Documentation generated."
echo ""
echo "👉 NEXT STEP: Run '~/dotfiles/install.sh'"
echo "   (This will backup your local physical files and replace them with links to the Repo)"
