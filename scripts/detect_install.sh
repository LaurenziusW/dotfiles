#!/usr/bin/env bash
set -euo pipefail

# ═══════════════════════════════════════════════════════════
# PRE-INSTALL DETECTOR
# Detects configuration conflicts before installation
# ═══════════════════════════════════════════════════════════

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly DOTFILES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
readonly BACKUP_DIR="$HOME/dotfiles_pre_install_backup_$(date +%Y%m%d_%H%M%S)"

# Colors
readonly RESET="\033[0m"
readonly GRAY="\033[90m"
readonly GREEN="\033[32m"
readonly YELLOW="\033[33m"
readonly RED="\033[31m"

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "linux"
    fi
}

OS_TYPE=$(detect_os)

# ───────────────────────────────────────────────────────────
# Target Definitions
# Maps component names to their target locations
# ───────────────────────────────────────────────────────────

declare -A TARGETS=(
    ["Zsh Configuration"]="$HOME/.zshrc"
    ["WezTerm Config"]="$HOME/.wezterm.lua"
    ["Tmux Config"]="$HOME/.tmux.conf"
    ["Neovim Config"]="$HOME/.config/nvim"
    ["Local Binaries"]="$HOME/.local/bin/gather-current-space"
    ["Bunch Manager"]="$HOME/.local/bin/bunch-manager"
    ["Workflow Bunches"]="$HOME/bunches"
)

# Platform-specific targets
if [[ "$OS_TYPE" == "macos" ]]; then
    TARGETS["Yabai Config"]="$HOME/.config/yabai"
    TARGETS["Skhd Config"]="$HOME/.config/skhd"
    TARGETS["Karabiner"]="$HOME/.config/karabiner"
else
    TARGETS["Hyprland Config"]="$HOME/.config/hypr"
    TARGETS["Keyd Config"]="$HOME/.config/keyd"
fi

# ───────────────────────────────────────────────────────────
# Helper Functions
# ───────────────────────────────────────────────────────────

# Resolve symlinks to absolute paths
resolve_path() {
    if command -v realpath >/dev/null 2>&1; then
        realpath "$1" 2>/dev/null || echo "$1"
    else
        # Fallback for systems without realpath
        python3 -c "import os, sys; print(os.path.realpath(sys.argv[1]))" "$1" 2>/dev/null || echo "$1"
    fi
}

# Detect the state of a path
detect_state() {
    local path=$1
    
    # Doesn't exist - clean
    if [[ ! -e "$path" && ! -L "$path" ]]; then
        echo "CLEAN"
        return
    fi

    # Is a symlink
    if [[ -L "$path" ]]; then
        local target=$(resolve_path "$path")
        
        # Check if it points to our dotfiles
        if [[ "$target" == "$DOTFILES_ROOT"* ]]; then
            echo "LINKED"
        else
            echo "FOREIGN"
        fi
        return
    fi
    
    # Is a directory or file (not linked)
    if [[ -d "$path" ]]; then
        echo "DIRECTORY"
    elif [[ -f "$path" ]]; then
        echo "FILE"
    fi
}

# ───────────────────────────────────────────────────────────
# Detection
# ───────────────────────────────────────────────────────────

echo "🔍 Detecting existing configurations..."
echo "═══════════════════════════════════════════════════════════"
printf "%-20s | %-15s | %s\n" "COMPONENT" "STATUS" "LOCATION"
echo "───────────────────────────────────────────────────────────"

has_conflict=0

for name in "${!TARGETS[@]}"; do
    path="${TARGETS[$name]}"
    state=$(detect_state "$path")
    
    case "$state" in
        CLEAN)
            icon="⚪"
            status="Clean"
            ;;
        LINKED)
            icon="✅"
            status="✓ Stowed"
            ;;
        FOREIGN)
            icon="⚠️ "
            status="Foreign Link"
            has_conflict=1
            ;;
        DIRECTORY)
            icon="⚠️ "
            status="Directory"
            has_conflict=1
            ;;
        FILE)
            icon="⚠️ "
            status="File"
            has_conflict=1
            ;;
    esac
    
    printf "%-20s | $icon %-13s | %s\n" "$name" "$status" "$path"
done

echo "═══════════════════════════════════════════════════════════"

# ───────────────────────────────────────────────────────────
# Conflict Resolution
# ───────────────────────────────────────────────────────────

if [[ $has_conflict -eq 0 ]]; then
    echo "✅ No conflicts detected!"
    echo "You can safely run: ./scripts/install.sh"
    exit 0
fi

echo ""
echo "⚠️  CONFLICTS DETECTED!"
echo "Existing files or folders are blocking the dotfiles installation."
echo "You can 'wipe' these files (they will be moved to a backup folder)."
echo ""

read -rp "Do you want to WIPE existing configs and backup to $BACKUP_DIR? (y/N) " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted. Run './scripts/install.sh' to install without wiping."
    echo "Note: install.sh will also handle conflicts by backing them up."
    exit 1
fi

# Create backup directory
echo "📦 Creating backup directory: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Wipe conflicts
for name in "${!TARGETS[@]}"; do
    path="${TARGETS[$name]}"
    state=$(detect_state "$path")
    
    # Skip if clean or already linked to our dotfiles
    if [[ "$state" == "CLEAN" || "$state" == "LINKED" ]]; then
        continue
    fi
    
    # Create relative path for backup
    rel_path="${path#$HOME/}"
    backup_path="$BACKUP_DIR/$rel_path"
    
    # Ensure backup parent directory exists
    mkdir -p "$(dirname "$backup_path")"
    
    # Move to backup
    mv "$path" "$backup_path"
    echo "🔥 Wiping: $path -> $backup_path"
done

echo ""
echo "✅ Wipe complete. Your system is ready for ./install.sh"