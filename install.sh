#!/bin/bash
# Master Installer - Symlinks dotfiles using Stow
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DOTFILES_DIR"

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    FOLDERS="local-bin workflow nvim wezterm zsh tmux yabai skhd"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    FOLDERS="local-bin workflow nvim wezterm zsh tmux hyprland"
fi

echo "🚀 Linking for $OS..."
for folder in $FOLDERS; do
    if [ -d "$folder" ]; then
        echo "🔗 Stowing $folder..."
        stow -R "$folder"
    else
        echo "⚠️  Skipping $folder (not found)"
    fi
done
echo "✅ Done."
