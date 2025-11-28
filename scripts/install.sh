#!/usr/bin/env bash
set -euo pipefail

# ═══════════════════════════════════════════════════════════
# DOTFILES INSTALLER
# Deploy configurations using GNU Stow
# ═══════════════════════════════════════════════════════════

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly DOTFILES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
readonly BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "linux"
    fi
}

OS_TYPE=$(detect_os)

# ───────────────────────────────────────────────────────────
# Package Lists
# ───────────────────────────────────────────────────────────

# Common packages (both platforms)
COMMON_PACKAGES=(
    "local-bin"
    "workflow"
    "nvim"
    "wezterm"
    "zsh"
    "tmux"
)

# Platform-specific packages
if [[ "$OS_TYPE" == "macos" ]]; then
    PLATFORM_PACKAGES=("yabai" "skhd" "karabiner")
else
    PLATFORM_PACKAGES=("hyprland" "keyd")
fi

# Combine all packages
ALL_PACKAGES=("${COMMON_PACKAGES[@]}" "${PLATFORM_PACKAGES[@]}")

# ───────────────────────────────────────────────────────────
# Installation
# ───────────────────────────────────────────────────────────

echo "🚀 Installing for $OS_TYPE..."
echo "📦 Packages: ${ALL_PACKAGES[*]}"
echo ""

cd "$DOTFILES_ROOT" || exit 1

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo "❌ ERROR: GNU Stow is not installed!"
    echo ""
    if [[ "$OS_TYPE" == "macos" ]]; then
        echo "Install with: brew install stow"
    else
        echo "Install with: sudo pacman -S stow  # or your package manager"
    fi
    exit 1
fi

# Create backup directory if we need it
BACKUP_CREATED=0

# Install each package
for package in "${ALL_PACKAGES[@]}"; do
    if [[ ! -d "$DOTFILES_ROOT/$package" ]]; then
        echo "⚠️  Skipping '$package' (directory not found in $DOTFILES_ROOT)"
        continue
    fi
    
    echo "📦 Stowing $package..."
    
    # Try to stow, capture any conflicts
    if stow -t "$HOME" -d "$DOTFILES_ROOT" "$package" 2>&1 | tee /tmp/stow_output.txt | grep -q "existing target"; then
        # Conflicts detected - create backup if not already created
        if [[ $BACKUP_CREATED -eq 0 ]]; then
            mkdir -p "$BACKUP_DIR"
            BACKUP_CREATED=1
            echo "   📦 Created backup directory: $BACKUP_DIR"
        fi
        
        # Move conflicting files to backup
        while IFS= read -r line; do
            if [[ "$line" =~ "existing target is" ]]; then
                conflict_file=$(echo "$line" | grep -o "$HOME/[^ ]*" | head -1)
                if [[ -n "$conflict_file" && -e "$conflict_file" ]]; then
                    rel_path="${conflict_file#$HOME/}"
                    backup_path="$BACKUP_DIR/$rel_path"
                    mkdir -p "$(dirname "$backup_path")"
                    mv "$conflict_file" "$backup_path"
                    echo "   💾 Backed up: $rel_path"
                fi
            fi
        done < /tmp/stow_output.txt
        
        # Try stowing again after backing up conflicts
        stow -t "$HOME" -d "$DOTFILES_ROOT" "$package" 2>/dev/null && echo "   ✅ $package installed"
    else
        echo "   ✅ $package installed"
    fi
done

echo ""
echo "✅ Installation Complete."

if [[ $BACKUP_CREATED -eq 1 ]]; then
    echo "   Backups (if any) are in: $BACKUP_DIR"
fi

echo ""
echo "🔄 Next steps:"
echo "   1. Restart your shell or run: source ~/.zshrc"

if [[ "$OS_TYPE" == "macos" ]]; then
    echo "   2. Start services: brew services start yabai skhd"
    echo "   3. Check status: yabai --check-sa"
else
    echo "   2. Reload Hyprland: hyprctl reload"
fi

rm -f /tmp/stow_output.txt