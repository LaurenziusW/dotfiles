#!/usr/bin/env bash
set -euo pipefail

# ═══════════════════════════════════════════════════════════
# DRIFT DETECTOR
# Identifies configuration drift before install
# ═══════════════════════════════════════════════════════════

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

detect_state() {
    local path=$1
    
    if [[ ! -e "$path" && ! -L "$path" ]]; then
        echo "CLEAN"
    elif [[ -L "$path" && $(readlink "$path") == "$DOTFILES_DIR"* ]]; then
        echo "LINKED"
    elif [[ -L "$path" ]]; then
        echo "FOREIGN"
    elif [[ -d "$path" ]]; then
        echo "DIRECTORY"
    elif [[ -f "$path" ]]; then
        echo "FILE"
    fi
}

printf "%-20s | %-12s | %s\n" "PACKAGE" "STATUS" "PATH"
echo "───────────────────────────────────────────────────────────"

has_conflict=0

for name in "${!TARGETS[@]}"; do
    path="${TARGETS[$name]}"
    state=$(detect_state "$path")
    
    case "$state" in
        CLEAN)   icon="○"; color="\033[90m" ;;
        LINKED)  icon="✓"; color="\033[32m" ;;
        FOREIGN) icon="⚠"; color="\033[33m"; has_conflict=1 ;;
        *)       icon="✗"; color="\033[31m"; has_conflict=1 ;;
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

echo "Conflicts detected. Backup and wipe?"
read -rp "Continue? [y/N]: " confirm

[[ ! "$confirm" =~ ^[Yy]$ ]] && { echo "Aborted"; exit 1; }

mkdir -p "$BACKUP_DIR"

for name in "${!TARGETS[@]}"; do
    path="${TARGETS[$name]}"
    state=$(detect_state "$path")
    
    if [[ "$state" != "CLEAN" && "$state" != "LINKED" ]]; then
        rel_path="${path#$HOME/}"
        dest="$BACKUP_DIR/$rel_path"
        mkdir -p "$(dirname "$dest")"
        mv "$path" "$dest"
        echo "→ Backed up: $path"
    fi
done

echo ""
echo "✓ Conflicts resolved. Backup: $BACKUP_DIR"
echo "Run './scripts/install.sh' to deploy dotfiles."