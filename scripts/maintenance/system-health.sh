#!/usr/bin/env bash
set -euo pipefail

readonly DOTFILES_DIR="${DOTFILES_ROOT:-$HOME/dotfiles}"
readonly OS=$(uname -s | tr '[:upper:]' '[:lower:]')

check_exec() {
    command -v "$1" &>/dev/null && echo "✓ $1" || echo "✗ $1"
}

check_link() {
    local path=$1
    local name=$(basename "$path")
    
    if [[ -L "$path" ]]; then
        local target=$(readlink "$path")
        if [[ "$target" == "$DOTFILES_DIR"* ]] || [[ "$target" == *"dotfiles/"* ]]; then
            echo "✓ $name"
        else
            echo "⚠ $name → $target"
        fi
    elif [[ -e "$path" ]]; then
        echo "✓ $name (physical)"
    else
        echo "✗ $name"
    fi
}

check_service() {
    local service=$1
    case "$OS" in
        darwin)
            pgrep -x "$service" &>/dev/null && echo "✓ $service" || echo "✗ $service"
            ;;
        linux)
            systemctl --user is-active --quiet "$service" 2>/dev/null && echo "✓ $service" || echo "✗ $service"
            ;;
    esac
}

echo "System Health"
echo "OS: $OS | Dotfiles: $DOTFILES_DIR"
echo ""

echo "Executables"
check_exec nvim
check_exec tmux
check_exec zsh
check_exec stow
check_exec gather-current-space
check_exec bunch-manager

echo ""
echo "Window Manager"
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
echo "Symlinks"
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