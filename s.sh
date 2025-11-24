#!/bin/bash

REPO_DIR="$HOME/dotfiles"
cd "$REPO_DIR" || exit

echo "🔧 Applying Final Cross-Platform Fixes..."

# 1. FIX: gather-current-space (Hybrid Logic)
# ---------------------------------------------------------
# Replaces the macOS-only version with a smart version that detects the OS.
# Citations: Fixes issue where script crashed on Linux
cat << 'EOF' > local-bin/.local/bin/gather-current-space
#!/bin/bash

# Gather all windows to the current space (Cross-Platform)

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "unknown"
    fi
}

OS=$(detect_os)

if [[ "$OS" == "macos" ]]; then
    if ! command -v yabai &> /dev/null; then echo "Error: yabai missing"; exit 1; fi
    
    CURRENT_SPACE=$(yabai -m query --spaces --space | jq '.index')
    echo "🍏 macOS: Gathering windows to Space $CURRENT_SPACE..."
    
    # Yabai Logic
    yabai -m query --windows | jq -r ".[] | select(.space != $CURRENT_SPACE) | .id" | \
    xargs -I{} yabai -m window {} --space "$CURRENT_SPACE"

elif [[ "$OS" == "linux" ]]; then
    if ! command -v hyprctl &> /dev/null; then echo "Error: hyprctl missing"; exit 1; fi
    
    # Hyprland Logic
    # Get current workspace ID
    CURRENT_WS=$(hyprctl activeworkspace -j | jq '.id')
    echo "🐧 Linux: Gathering windows to Workspace $CURRENT_WS..."
    
    # Get list of all window addresses on other workspaces
    hyprctl clients -j | jq -r ".[] | select(.workspace.id != $CURRENT_WS) | .address" | \
    while read -r addr; do
        hyprctl dispatch movetoworkspacesilent "$CURRENT_WS,address:$addr"
    done
fi

echo "✅ Done."
EOF
chmod +x local-bin/.local/bin/gather-current-space

# 2. FIX: .zshrc (Arch Deprecation)
# ---------------------------------------------------------
# Replaces 'netstat' (deprecated on Arch) with 'ss'
# Citations: Fixes "command not found" for ports alias
if [[ "$OSTYPE" == "darwin"* ]]; then
    # On macOS, sed requires an empty string for inplace backup
    sed -i '' "s/alias ports='netstat -tulanp'/alias ports='ss -tulanp' # Linux (ss replaces netstat)/" zsh/.zshrc
else
    sed -i "s/alias ports='netstat -tulanp'/alias ports='ss -tulanp' # Linux (ss replaces netstat)/" zsh/.zshrc
fi

# 3. FIX: lib-os-detect (Launch Logic)
# ---------------------------------------------------------
# Improves app launching to avoid gtk-launch errors on Linux
cat << 'EOF' > local-bin/.local/bin/lib-os-detect
#!/bin/bash

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "unknown"
    fi
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
        # Try running command directly first (better for terminal tools)
        if command -v "$app" &> /dev/null; then
            "$app" &
        else
            # Fallback to gtk-launch for GUI apps if desktop file exists
            gtk-launch "$app" 2>/dev/null || echo "⚠️ Could not launch $app"
        fi
    fi
}
EOF
chmod +x local-bin/.local/bin/lib-os-detect

# 4. FIX: Verification Script (OS Aware)
# ---------------------------------------------------------
# Updates verify script to ignore macOS tools when running on Linux
cat << 'EOF' > verify-repo.sh
#!/bin/bash
echo "🔍 Verifying Repo Integrity..."

OS="unknown"
[[ "$OSTYPE" == "darwin"* ]] && OS="macos"
[[ "$OSTYPE" == "linux-gnu"* ]] && OS="linux"

check_exec() {
    if command -v "$1" &> /dev/null; then
        echo "✅ EXEC: $1"
    else
        echo "❌ MISSING: $1"
    fi
}

echo "--- Common ---"
check_exec "nvim"
check_exec "tmux"
check_exec "zsh"
check_exec "gather-current-space"

if [[ "$OS" == "macos" ]]; then
    echo "--- macOS Specific ---"
    check_exec "yabai"
    check_exec "skhd"
elif [[ "$OS" == "linux" ]]; then
    echo "--- Linux Specific ---"
    check_exec "hyprctl"
    # Don't check for yabai/skhd here to avoid false positives
fi
echo "✅ Verification Logic Updated."
EOF
chmod +x verify-repo.sh

# 5. GIT PUSH
# ---------------------------------------------------------
echo "⬆️  Pushing Golden State to GitHub..."
git add .
git commit -m "feat: finalize cross-platform compatibility (hybrid scripts)"
git push

echo "🎉 DONE. The repo is now truly OS-agnostic."
