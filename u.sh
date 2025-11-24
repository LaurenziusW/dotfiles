#!/bin/bash

# ==============================================================================
#  ONE AND DONE: UNIFIED DOTFILES UPDATE (Zsh Safe Version)
# ==============================================================================

REPO_DIR="$HOME/dotfiles"
cd "$REPO_DIR" || { echo "❌ Directory not found: $REPO_DIR"; exit 1; }

echo "🚀 Starting Full Repository Update..."

# 1. CREATE DIRECTORY STRUCTURE
mkdir -p local-bin/.local/bin
mkdir -p scripts/maintenance

# 2. WRITE: Hybrid 'gather-current-space' (Mac + Linux in one)
echo "🔧 Writing gather-current-space..."
cat << 'EOF' > local-bin/.local/bin/gather-current-space
#!/bin/bash
# Gather all windows to the current space (Hybrid: macOS + Linux)

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then echo "macos"; else echo "linux"; fi
}
OS=$(detect_os)

if [[ "$OS" == "macos" ]]; then
    # --- macOS (Yabai) ---
    if ! command -v yabai &> /dev/null; then echo "Error: yabai missing"; exit 1; fi
    CURRENT_SPACE=$(yabai -m query --spaces --space | jq '.index')
    echo "🍏 macOS: Gathering windows to Space $CURRENT_SPACE..."
    yabai -m query --windows | jq -r ".[] | select(.space != $CURRENT_SPACE) | .id" | \
    while read -r window_id; do yabai -m window "$window_id" --space "$CURRENT_SPACE"; done

elif [[ "$OS" == "linux" ]]; then
    # --- Linux (Hyprland) ---
    if ! command -v hyprctl &> /dev/null; then echo "Error: hyprctl missing"; exit 1; fi
    CURRENT_WS=$(hyprctl activeworkspace -j | jq '.id')
    echo "🐧 Linux: Gathering windows to Workspace $CURRENT_WS..."
    hyprctl clients -j | jq -r ".[] | select(.workspace.id != $CURRENT_WS) | .address" | \
    while read -r addr; do hyprctl dispatch movetoworkspacesilent "$CURRENT_WS,address:$addr"; done
fi
EOF

# 3. WRITE: 'lib-os-detect' (With Linux Fallback Fix)
echo "🔧 Writing lib-os-detect..."
cat << 'EOF' > local-bin/.local/bin/lib-os-detect
#!/bin/bash
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then echo "macos"; else echo "linux"; fi
}
setup_os_commands() {
    OS=$(detect_os)
    if [[ "$OS" == "macos" ]]; then
        export WM_FOCUS_SPACE="yabai -m space --focus"
    elif [[ "$OS" == "linux" ]]; then
        export WM_FOCUS_SPACE="hyprctl dispatch workspace"
    fi
}
launch_app() {
    local app="$1"
    local OS=$(detect_os)
    if [[ "$OS" == "macos" ]]; then
        open -a "$app"
    elif [[ "$OS" == "linux" ]]; then
        if command -v "$app" &> /dev/null; then "$app" &
        else gtk-launch "$app" 2>/dev/null || echo "⚠️ Could not launch $app"; fi
    fi
}
EOF

# 4. WRITE: 'install.sh' (The Enforcer with Drift Protection)
echo "🔧 Writing install.sh..."
cat << 'EOF' > install.sh
#!/bin/bash
# Master Installer - Enforces Remote Stable State
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
cd "$DOTFILES_DIR"

if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"; PACKAGES="local-bin workflow nvim wezterm zsh tmux yabai skhd"
else
    OS="linux"; PACKAGES="local-bin workflow nvim wezterm zsh tmux hyprland"
fi

echo "🚀 Installing for $OS..."

link_package() {
    local package=$1
    [ ! -d "$package" ] && return
    
    # Check for conflicts (files that are not links)
    CONFLICTS=$(stow -n -v "$package" 2>&1 | grep "existing target is" | awk '{print $NF}')
    if [ ! -z "$CONFLICTS" ]; then
        mkdir -p "$BACKUP_DIR"
        for file in $CONFLICTS; do
            mv "$HOME/$file" "$BACKUP_DIR/$(basename $file).bak"
            echo "   🔥 Moved drift '$file' to backup"
        done
    fi
    stow -R "$package"
}

for pkg in $PACKAGES; do link_package "$pkg"; done
echo "✅ Done."
EOF

# 5. WRITE: 'collect-for-ai.sh' (Context Dumper)
echo "🔧 Writing collect-for-ai.sh..."
cat << 'EOF' > scripts/maintenance/collect-for-ai.sh
#!/bin/bash
OUTPUT="dotfiles-context-$(date +%Y%m%d).tar.gz"
echo "📦 Packing repo context..."
tar --exclude='.git' --exclude='*.tar.gz' --exclude='.DS_Store' --exclude='*.bak' \
    -czf "$OUTPUT" -C "$HOME/dotfiles" .
echo "✅ Context ready: $OUTPUT"
EOF

# 6. WRITE: 'fulldump.sh' (System Verifier)
echo "🔧 Writing fulldump.sh..."
cat << 'EOF' > fulldump.sh
#!/bin/bash
OUTPUT_FILE="$HOME/full-system-dump.txt"
DOTFILES_DIR="$HOME/dotfiles"
echo "🔍 Generating System Report..."

check_link() {
    if [ -L "$2" ] && [[ "$(readlink "$2")" == *"$DOTFILES_DIR"* ]]; then echo "✅ LINK OK: $1" >> "$OUTPUT_FILE"
    else echo "❌ MISSING/DRIFT: $1" >> "$OUTPUT_FILE"; fi
}

echo "--- VERIFICATION ---" > "$OUTPUT_FILE"
check_link ".zshrc" "$HOME/.zshrc"
check_link "local-bin" "$HOME/.local/bin/gather-current-space"

echo "✅ Report saved to: $OUTPUT_FILE"
EOF

# 7. PERMISSIONS & GIT PUSH
echo "🔒 Setting Permissions..."
chmod +x install.sh fulldump.sh scripts/maintenance/collect-for-ai.sh \
         local-bin/.local/bin/gather-current-space local-bin/.local/bin/lib-os-detect

echo "⬆️  Pushing to GitHub..."
git add .
git commit -m "chore: update all management scripts and hybrid logic"
git push

echo "🎉 SUCCESS. Repo is fully updated and synced."
