#!/usr/bin/env bash
# fix_conflicts.sh

# Safety Setup
DOTFILES_DIR=$(pwd)
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%s)"

echo "📦 Creating safety backup at $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

# Function to Swap Real File -> Symlink
fix_package() {
    local target="$1"  # File or Folder on Mac (e.g. ~/.config/nvim)
    local pkg="$2"     # Package name in Dotfiles (e.g. nvim)

    # Only act if the target exists and is NOT a symlink
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "🔧 Fixing $pkg ($target)..."
        
        # 1. Back up the real file/folder
        # We use cp -R to handle both files and directories
        cp -R "$target" "$BACKUP_DIR/"
        
        # 2. Delete the local copy
        rm -rf "$target"
        
        # 3. Restow to create the link
        stow -R -t "$HOME" -d "$DOTFILES_DIR" "$pkg" 2>/dev/null
        
        if [ $? -eq 0 ]; then
             echo "   -> ✅ Fixed! Now a symlink."
        else
             echo "   -> ⚠️  Stow failed. Check manual output."
        fi
    else
        echo "   -> $pkg ($target) is already good or handled."
        # Run stow anyway to ensure sub-files are linked if parent exists
        stow -R -t "$HOME" -d "$DOTFILES_DIR" "$pkg" 2>/dev/null
    fi
}

# ====================================================
# EXECUTE FIXES BASED ON YOUR AUDIT
# ====================================================

# 1. Fix Neovim (Deep folder structure conflict)
# We delete the whole ~/.config/nvim folder so Stow can link the directory cleanly
fix_package "$HOME/.config/nvim" "nvim"

# 2. Fix Workflow (Bunches)
# We delete ~/bunches so Stow can link the directory cleanly
fix_package "$HOME/bunches" "workflow"

# 3. Fix Window Managers (Single file conflicts)
fix_package "$HOME/.config/yabai/yabairc" "yabai"
fix_package "$HOME/.config/skhd/skhdrc" "skhd"

# 4. Fix Local Binaries (Just in case)
stow -R -t "$HOME" -d "$DOTFILES_DIR" "local-bin" 2>/dev/null


echo "------------------------------------------------"
echo "✨ All fixes attempted."
echo "   Backups stored in: $BACKUP_DIR"
echo "   Run ./audit.sh to verify everything is green."
