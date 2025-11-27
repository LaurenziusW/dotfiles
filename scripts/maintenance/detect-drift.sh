#!/usr/bin/env bash
set -euo pipefail

# ═══════════════════════════════════════════════════════════
# DRIFT DETECTOR
# Identifies configuration drift before install
# ═══════════════════════════════════════════════════════════

# 1. Defined Colors
readonly RESET="\033[0m"
readonly GRAY="\033[90m"
readonly GREEN="\033[32m"
readonly YELLOW="\033[33m"
readonly RED="\033[31m"

readonly DOTFILES_DIR="${DOTFILES_ROOT:-$HOME/dotfiles}"
readonly BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d_%H%M%S)"

# ───────────────────────────────────────────────────────────
# Target Definitions
# ───────────────────────────────────────────────────────────

declare -A TARGETS=(
    ["zsh"]="$HOME/.zshrc"
    ["wezterm"]="$HOME/.wezterm.lua"
    ["tmux"]="$HOME/.tmux.conf"
    ["nvim"]="$HOME/.config/nvim"
    ["local-bin"]="$HOME/.local/bin/gather-current-space"
)

# OS-specific targets
case "$(uname -s)" in
    Darwin)
        TARGETS[yabai]="$HOME/.config/yabai"
        TARGETS[skhd]="$HOME/.config/skhd"
        ;;
    Linux)
        TARGETS[hyprland]="$HOME/.config/hypr"
        TARGETS[keyd]="$HOME/.config/keyd"
        ;;
esac

# ───────────────────────────────────────────────────────────
# Drift Detection
# ───────────────────────────────────────────────────────────

# Helper to resolve symlinks to absolute paths (handles relative links)
resolve_path() {
    if command -v realpath >/dev/null 2>&1; then
        realpath "$1"
    else
        # Python fallback for macOS if coreutils/realpath is missing
        python3 -c "import os, sys; print(os.path.realpath(sys.argv[1]))" "$1"
    fi
}

detect_state() {
    local path=$1
    
    if [[ ! -e "$path" && ! -L "$path" ]]; then
        echo "CLEAN"
        return
    fi

    if [[ -L "$path" ]]; then
        # Resolve the link to an absolute path before comparing
        local target
        target=$(resolve_path "$path")
        
        if [[ "$target" == "$DOTFILES_DIR"* ]]; then
            echo "LINKED"
        else
            echo "FOREIGN"
        fi
    elif [[ -d "$path" ]]; then
        echo "DIRECTORY"
    elif [[ -f "$path" ]]; then
        echo "FILE"
    fi
}

# Header
printf "%-20s | %-12s | %s\n" "PACKAGE" "STATUS" "PATH"
echo "───────────────────────────────────────────────────────────"

has_conflict=0

for name in "${!TARGETS[@]}"; do
    path="${TARGETS[$name]}"
    state=$(detect_state "$path")
    
    case "$state" in
        CLEAN)   icon="○"; color="$GRAY" ;;
        LINKED)  icon="✓"; color="$GREEN" ;;
        FOREIGN) icon="⚠"; color="$YELLOW"; has_conflict=1 ;;
        *)       icon="✗"; color="$RED";    has_conflict=1 ;;
    esac
    
    printf "${color}%-20s${RESET} | %-12s | %s\n" "$name" "$state" "$path"
done

echo ""

# ───────────────────────────────────────────────────────────
# Conflict Resolution
# ───────────────────────────────────────────────────────────

if [[ $has_conflict -eq 0 ]]; then
    echo "System is clean. Run './scripts/install.sh' to proceed."
    exit 0
fi

printf "${YELLOW}Conflicts detected. Backup and wipe?${RESET}\n"
read -rp "Continue? [y/N]: " confirm

[[ ! "$confirm" =~ ^[Yy]$ ]] && { echo "Aborted"; exit 1; }

mkdir -p "$BACKUP_DIR"

for name in "${!TARGETS[@]}"; do
    path="${TARGETS[$name]}"
    state=$(detect_state "$path")
    
    if [[ "$state" != "CLEAN" && "$state" != "LINKED" ]]; then
        rel_path="${path#$HOME/}"
        dest="$BACKUP_DIR/$rel_path"
        
        # Ensure backup subdirectory exists
        mkdir -p "$(dirname "$dest")"
        
        mv "$path" "$dest"
        printf "→ Backed up: %s\n" "$path"
    fi
done

echo ""
echo "✓ Conflicts resolved. Backup: $BACKUP_DIR"
echo "Run './scripts/install.sh' to deploy dotfiles."