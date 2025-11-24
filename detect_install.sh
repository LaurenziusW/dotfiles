#!/bin/bash

# Configuration
BACKUP_DIR="$HOME/dotfiles_pre_install_backup_$(date +%Y%m%d_%H%M%S)"
DOTFILES_DIR="$HOME/dotfiles"

# Define the critical paths we want to manage
# Format: "Name:Path"
TARGETS=(
    "Zsh Configuration:$HOME/.zshrc"
    "WezTerm Config:$HOME/.wezterm.lua"
    "Tmux Config:$HOME/.tmux.conf"
    "Neovim Config:$HOME/.config/nvim"
    "Local Binaries:$HOME/.local/bin/gather-current-space"
    "Bunch Manager:$HOME/.local/bin/bunch-manager"
    "Workflow Bunches:$HOME/bunches"
)

# Add OS-specific targets
if [[ "$OSTYPE" == "darwin"* ]]; then
    TARGETS+=("Yabai Config:$HOME/.config/yabai")
    TARGETS+=("Skhd Config:$HOME/.config/skhd")
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    TARGETS+=("Hyprland Config:$HOME/.config/hypr")
fi

echo "🔍 Detecting existing configurations..."
echo "═══════════════════════════════════════════════════════════"
printf "%-20s | %-15s | %s\n" "COMPONENT" "STATUS" "LOCATION"
echo "───────────────────────────────────────────────────────────"

CONFLICT_FOUND=false

for item in "${TARGETS[@]}"; do
    NAME="${item%%:*}"
    PATH_TARGET="${item#*:}"
    
    if [ ! -e "$PATH_TARGET" ] && [ ! -L "$PATH_TARGET" ]; then
        STATUS="⚪ Clean"
        COLOR="\033[0;90m" # Gray
    elif [ -L "$PATH_TARGET" ]; then
        LINK_DEST=$(readlink "$PATH_TARGET")
        if [[ "$LINK_DEST" == *"$DOTFILES_DIR"* ]]; then
            STATUS="✅ Linked"
            COLOR="\033[0;32m" # Green
        else
            STATUS="⚠️  Foreign Link"
            COLOR="\033[0;33m" # Yellow
            CONFLICT_FOUND=true
        fi
    elif [ -d "$PATH_TARGET" ]; then
        STATUS="❌ Directory"
        COLOR="\033[0;31m" # Red
        CONFLICT_FOUND=true
    elif [ -f "$PATH_TARGET" ]; then
        STATUS="❌ File"
        COLOR="\033[0;31m" # Red
        CONFLICT_FOUND=true
    fi
    
    # Reset color
    NC="\033[0m"
    printf "${COLOR}%-20s${NC} | ${COLOR}%-15s${NC} | %s\n" "$NAME" "$STATUS" "$PATH_TARGET"
done
echo "═══════════════════════════════════════════════════════════"

if [ "$CONFLICT_FOUND" = false ]; then
    echo "✨ Your system is clean! You can run ./install.sh safely."
    exit 0
fi

echo ""
echo "⚠️  CONFLICTS DETECTED!"
echo "Existing files or folders are blocking the dotfiles installation."
echo "You can 'wipe' these files (they will be moved to a backup folder)."
echo ""
read -p "Do you want to WIPE existing configs and backup to $BACKUP_DIR? (y/N) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "📦 Creating backup directory: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    
    for item in "${TARGETS[@]}"; do
        PATH_TARGET="${item#*:}"
        
        # Check if it exists and is NOT correctly linked
        if [ -e "$PATH_TARGET" ] || [ -L "$PATH_TARGET" ]; then
            # Check if it's already correct, skip if so
            if [ -L "$PATH_TARGET" ] && [[ "$(readlink "$PATH_TARGET")" == *"$DOTFILES_DIR"* ]]; then
                continue
            fi
            
            # Prepare destination path in backup to preserve hierarchy
            REL_PATH="${PATH_TARGET#$HOME/}"
            BACKUP_DEST="$BACKUP_DIR/$REL_PATH"
            mkdir -p "$(dirname "$BACKUP_DEST")"
            
            echo "🔥 Wiping: $PATH_TARGET -> $BACKUP_DEST"
            mv "$PATH_TARGET" "$BACKUP_DEST"
        fi
    done
    
    echo ""
    echo "✅ Wipe complete. Your system is ready for ./install.sh"
else
    echo "❌ Operation cancelled. No files were changed."
fi
