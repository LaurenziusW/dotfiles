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
