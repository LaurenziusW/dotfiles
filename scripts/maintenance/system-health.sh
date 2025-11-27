#!/usr/bin/env bash
set -euo pipefail

# ═══════════════════════════════════════════════════════════
# SYSTEM HEALTH CHECK
# Validates symlinks, executables, and service status
# ═══════════════════════════════════════════════════════════

readonly DOTFILES_DIR="${DOTFILES_ROOT:-$HOME/dotfiles}"
readonly OS=$(uname -s | tr '[:upper:]' '[:lower:]')

# ───────────────────────────────────────────────────────────
# Validation Functions
# ───────────────────────────────────────────────────────────

check_exec() {
    command -v "$1" &>/dev/null && echo "✓ $1" || echo "✗ $1 (missing)"
}

check_link() {
    local path=$1
    local name=$(basename "$path")
    
    if [[ -L "$path" && $(readlink "$path") == "$DOTFILES_DIR"* ]]; then
        echo "✓ $name → dotfiles"
    elif [[ -e "$path" ]]; then
        echo "⚠ $name (physical file, not linked)"
    else
        echo "✗ $name (missing)"
    fi
}

check_service() {
    local service=$1
    case "$OS" in
        darwin)
            if brew services list | grep -q "^$service.*started"; then
                echo "✓ $service (running)"
            else
                echo "✗ $service (stopped)"
            fi
            ;;
        linux)
            if systemctl --user is-active --quiet "$service" 2>/dev/null; then
                echo "✓ $service (active)"
            else
                echo "⚠ $service (inactive/not found)"
            fi
            ;;
    esac
}

# ───────────────────────────────────────────────────────────
# Health Checks
# ───────────────────────────────────────────────────────────

echo "System Health Check"
echo "OS: $OS | Dotfiles: $DOTFILES_DIR"
echo ""

echo "▸ Core Executables"
check_exec nvim
check_exec tmux
check_exec zsh
check_exec stow
check_exec gather-current-space
check_exec bunch-manager

echo ""
echo "▸ Window Manager Stack"
if [[ "$OS" == "darwin" ]]; then
    check_exec yabai
    check_exec skhd
    check_service yabai
    check_service skhd
elif [[ "$OS" == "linux" ]]; then
    check_exec hyprctl
    check_exec Hyprland
fi

echo ""
echo "▸ Critical Symlinks"
check_link "$HOME/.zshrc"
check_link "$HOME/.wezterm.lua"
check_link "$HOME/.tmux.conf"
check_link "$HOME/.config/nvim"

if [[ "$OS" == "darwin" ]]; then
    check_link "$HOME/.config/yabai"
    check_link "$HOME/.config/skhd"
elif [[ "$OS" == "linux" ]]; then
    check_link "$HOME/.config/hypr"
fi

echo ""
echo "▸ Local Binaries in PATH"
check_exec gather-current-space
check_exec bunch-manager

echo ""
echo "Health check complete"
