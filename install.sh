#!/bin/bash
# Master Installer - Enforces Remote Stable State
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
cd "$DOTFILES_DIR"

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    FOLDERS="local-bin workflow nvim wezterm zsh tmux yabai skhd"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    FOLDERS="local-bin workflow nvim wezterm zsh tmux hyprland"
fi

echo "🚀 Enforcing Stable Configs for $OS..."

# Function to safely link folders
link_folder() {
    local folder=$1
    echo "🔗 Processing $folder..."
    
    # Check for conflicts (Dry Run)
    CONFLICTS=$(stow -n -v "$folder" 2>&1 | grep "existing target is" | awk '{print $NF}')
    
    if [ ! -z "$CONFLICTS" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "   ⚠️  Conflict detected. Backing up local drift to $BACKUP_DIR"
        for file in $CONFLICTS; do
            # Move the conflicting file (relative to HOME)
            # This respects "Remote is Stable" by moving local drift aside
            mv "$HOME/$file" "$BACKUP_DIR/$(basename $file).bak"
            echo "      moved: $file -> $BACKUP_DIR"
        done
    fi
    
    # Link the stable version
    stow -R "$folder"
}

for folder in $FOLDERS; do
    if [ -d "$folder" ]; then
        link_folder "$folder"
    else
        echo "⚠️  Skipping $folder (not found in repo)"
    fi
done

echo "✅ System is now synced with Stable Repo."
