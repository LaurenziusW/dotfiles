#!/bin/bash
# Unified Dotfiles Installer (Cross-Platform)

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
cd "$DOTFILES_DIR"

# 1. Detect OS & Define Packages
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    # Mac Packages
    PACKAGES="local-bin workflow nvim wezterm zsh tmux yabai skhd"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    # Linux Packages
    PACKAGES="local-bin workflow nvim wezterm zsh tmux hyprland"
else
    echo "❌ Unsupported OS: $OSTYPE"
    exit 1
fi

echo "🚀 Installing for $OS..."
echo "📦 Packages: $PACKAGES"

# 2. Link Function with Drift Protection
link_package() {
    local package=$1
    
    if [ ! -d "$package" ]; then
        echo "⚠️  Skipping '$package' (Not found in repo)"
        return
    fi

    echo "🔗 Linking $package..."

    # Dry-run Stow to find conflicts
    # 'existing target is...' means a file exists where a link should be
    CONFLICTS=$(stow -n -v "$package" 2>&1 | grep "existing target is" | awk '{print $NF}')

    if [ ! -z "$CONFLICTS" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "   ⚠️  Local drift detected!"
        
        for file in $CONFLICTS; do
            # Move the conflicting file to backup
            # Handles paths relative to $HOME
            mv "$HOME/$file" "$BACKUP_DIR/$(basename $file).bak"
            echo "      🔥 Moved local '$file' to backup"
        done
    fi

    # Perform the actual link
    stow -R "$package"
}

# 3. Execute
for pkg in $PACKAGES; do
    link_package "$pkg"
done

echo ""
echo "✅ Installation Complete."
echo "   Backups (if any) are in: $BACKUP_DIR"
