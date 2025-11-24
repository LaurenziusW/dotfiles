#!/bin/bash

REPO_DIR="$HOME/dotfiles"
cd "$REPO_DIR" || exit

echo "🛠️  Updating Management Tools..."

# 1. UPDATE: install.sh (The Enforcer)
# ---------------------------------------------------------
# Features:
# - Auto-detects macOS vs Linux
# - Stows the correct packages for each OS
# - SMART BACKUP: If it finds a local config that isn't a link, it backs it up instead of failing.
cat << 'EOF' > install.sh
#!/bin/bash
# Unified Dotfiles Installer (Cross-Platform)

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
cd "$DOTFILES_DIR"

# 1. Detect OS & Define Packages
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    # Mac Packages
    PACKAGES="local-bin workflow nvim wezterm zsh tmux yabai skhd"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    # Linux Packages
    PACKAGES="local-bin workflow nvim wezterm zsh tmux hyprland"
else
    echo "❌ Unsupported OS: $OSTYPE"
    exit 1
fi

echo "🚀 Installing for $OS..."
echo "📦 Packages: $PACKAGES"

# 2. Link Function with Drift Protection
link_package() {
    local package=$1
    
    if [ ! -d "$package" ]; then
        echo "⚠️  Skipping '$package' (Not found in repo)"
        return
    fi

    echo "🔗 Linking $package..."

    # Dry-run Stow to find conflicts
    # 'existing target is...' means a file exists where a link should be
    CONFLICTS=$(stow -n -v "$package" 2>&1 | grep "existing target is" | awk '{print $NF}')

    if [ ! -z "$CONFLICTS" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "   ⚠️  Local drift detected!"
        
        for file in $CONFLICTS; do
            # Move the conflicting file to backup
            # Handles paths relative to $HOME
            mv "$HOME/$file" "$BACKUP_DIR/$(basename $file).bak"
            echo "      🔥 Moved local '$file' to backup"
        done
    fi

    # Perform the actual link
    stow -R "$package"
}

# 3. Execute
for pkg in $PACKAGES; do
    link_package "$pkg"
done

echo ""
echo "✅ Installation Complete."
echo "   Backups (if any) are in: $BACKUP_DIR"
EOF
chmod +x install.sh

# 2. UPDATE: collect-for-ai.sh (Context Gatherer)
# ---------------------------------------------------------
# Features:
# - Dumps the repo structure + content for future AI sessions
# - Excludes .git, backups, and DS_Store to keep it clean
mkdir -p scripts/maintenance
cat << 'EOF' > scripts/maintenance/collect-for-ai.sh
#!/bin/bash

# Output filename
OUTPUT="dotfiles-context-$(date +%Y%m%d).tar.gz"
REPO_ROOT="$HOME/dotfiles"

echo "🤖 Collecting Repository Context..."
echo "   Target: $OUTPUT"

# Create the archive
# -C changes directory before archiving so paths are relative to repo root
tar --exclude='.git' \
    --exclude='.DS_Store' \
    --exclude='*.tar.gz' \
    --exclude='*.bak' \
    -czf "$OUTPUT" \
    -C "$REPO_ROOT" .

echo "✅ Done. Upload '$OUTPUT' to your AI assistant."
EOF
chmod +x scripts/maintenance/collect-for-ai.sh

# 3. UPDATE: fulldump.sh (System Verifier)
# ---------------------------------------------------------
# Features:
# - OS-Aware: Doesn't check for Yabai on Linux (and vice versa)
# - Verifies Symlinks: Checks if files point to the repo
# - Verifies Executables: Checks if local-bin scripts are in PATH
# - Dumps Content: Creates a single text file for review
cat << 'EOF' > fulldump.sh
#!/bin/bash

OUTPUT_FILE="$HOME/full-system-dump.txt"
DOTFILES_DIR="$HOME/dotfiles"

# Header
echo "═══════════════════════════════════════════════════════════" > "$OUTPUT_FILE"
echo "UNIFIED DOTFILES - SYSTEM STATE REPORT" >> "$OUTPUT_FILE"
echo "Generated: $(date)" >> "$OUTPUT_FILE"
echo "OS: $OSTYPE" >> "$OUTPUT_FILE"
echo "═══════════════════════════════════════════════════════════" >> "$OUTPUT_FILE"

echo "🔍 Generating System Report..."

# --- Helpers ---
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then echo "macos"; else echo "linux"; fi
}
OS=$(detect_os)

check_link() {
    local name=$1
    local path=$2
    if [ -L "$path" ] && [[ "$(readlink "$path")" == *"$DOTFILES_DIR"* ]]; then
        echo "✅ LINK OK: $name" >> "$OUTPUT_FILE"
    elif [ -e "$path" ]; then
        echo "⚠️  DRIFT: $name (Physical File)" >> "$OUTPUT_FILE"
    else
        echo "❌ MISSING: $name" >> "$OUTPUT_FILE"
    fi
}

check_exec() {
    if command -v "$1" &> /dev/null; then
        echo "✅ EXEC OK: $1" >> "$OUTPUT_FILE"
    else
        echo "❌ EXEC MISSING: $1" >> "$OUTPUT_FILE"
    fi
}

# --- 1. Verification ---
echo "1️⃣  Verifying Links & Tools..." >> "$OUTPUT_FILE"

# Common
check_link ".zshrc" "$HOME/.zshrc"
check_link ".wezterm.lua" "$HOME/.wezterm.lua"
check_link ".tmux.conf" "$HOME/.tmux.conf"
check_link "nvim" "$HOME/.config/nvim"
check_link "local-bin" "$HOME/.local/bin/gather-current-space"

# OS Specific
if [[ "$OS" == "macos" ]]; then
    check_link "yabai" "$HOME/.config/yabai"
    check_link "skhd" "$HOME/.config/skhd"
    check_exec "yabai"
    check_exec "skhd"
elif [[ "$OS" == "linux" ]]; then
    check_link "hyprland" "$HOME/.config/hypr"
    check_exec "hyprctl"
fi

# Tools
check_exec "gather-current-space"
check_exec "bunch-manager"
check_exec "nvim"

# --- 2. Content Dump ---
echo "" >> "$OUTPUT_FILE"
echo "2️⃣  Configuration Content..." >> "$OUTPUT_FILE"

dump_file() {
    if [ -f "$1" ]; then
        echo "" >> "$OUTPUT_FILE"
        echo "------------------------------------------------" >> "$OUTPUT_FILE"
        echo "FILE: $1" >> "$OUTPUT_FILE"
        echo "------------------------------------------------" >> "$OUTPUT_FILE"
        cat "$1" >> "$OUTPUT_FILE"
    fi
}

dump_file "$HOME/.zshrc"
dump_file "$HOME/.wezterm.lua"
dump_file "$HOME/.tmux.conf"
dump_file "$HOME/.local/bin/gather-current-space"
dump_file "$HOME/.local/bin/lib-os-detect"

if [[ "$OS" == "macos" ]]; then
    dump_file "$HOME/.config/yabai/yabairc"
    dump_file "$HOME/.config/skhd/skhdrc"
elif [[ "$OS" == "linux" ]]; then
    dump_file "$HOME/.config/hypr/hyprland.conf"
fi

echo "✅ Report saved to: $OUTPUT_FILE"
EOF
chmod +x fulldump.sh

# 4. Final Git Push
echo "⬆️  Pushing updated tools to GitHub..."
git add install.sh scripts/maintenance/collect-for-ai.sh fulldump.sh
git commit -m "chore: update management scripts (install, collect, dump)"
git push

echo "🎉 Management Suite Updated."
