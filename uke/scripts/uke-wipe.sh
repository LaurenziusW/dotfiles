#!/usr/bin/env bash
# ==============================================================================
# UKE Wipe - Complete uninstallation
# ==============================================================================
set -euo pipefail

# Resolve UKE_ROOT dynamically
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UKE_ROOT="${SCRIPT_DIR%/scripts}"
UKE_STOW="$UKE_ROOT/stow"

RED=$'\e[31m' GREEN=$'\e[32m' YELLOW=$'\e[33m' RESET=$'\e[0m'

echo "${RED}╔══════════════════════════════════════╗${RESET}"
echo "${RED}║     UKE WIPE - Complete Removal      ║${RESET}"
echo "${RED}╚══════════════════════════════════════╝${RESET}"
echo ""
echo "This will remove:"
echo "  • Binary symlinks in ~/.local/bin/uke*"
echo "  • Config symlinks (skhd, yabai, hyprland)"
echo "  • Stowed dotfiles (wezterm, tmux, zsh, nvim)"
echo "  • UKE state and backups"
echo ""
echo "${YELLOW}Source at $UKE_ROOT will NOT be deleted.${RESET}"
echo ""
read -p "Type 'wipe' to confirm: " confirm
[[ "$confirm" != "wipe" ]] && { echo "Aborted."; exit 1; }

echo ""

# 1. Remove binary symlinks
echo "Removing binary symlinks..."
rm -f ~/.local/bin/uke ~/.local/bin/uke-*
echo "  ✓ Binaries removed"

# 2. Remove config symlinks
echo "Removing config symlinks..."
rm -f ~/.config/skhd/skhdrc
rm -f ~/.config/yabai/yabairc
rm -f ~/.config/hypr/hyprland.conf
echo "  ✓ Config symlinks removed"

# 3. Unstow dotfiles
echo "Unstowing dotfiles..."
if command -v stow &>/dev/null && [[ -d "$UKE_STOW" ]]; then
    cd "$UKE_STOW"
    for pkg in wezterm tmux zsh nvim karabiner keyd; do
        [[ -d "$pkg" ]] && stow -t "$HOME" -D "$pkg" 2>/dev/null && echo "  ✓ Unstowed: $pkg" || true
    done
else
    # Manual removal if stow not available
    rm -f ~/.wezterm.lua ~/.tmux.conf ~/.zshrc
    rm -rf ~/.config/nvim
    echo "  ✓ Dotfiles removed (manual)"
fi

# 4. Remove state and backups
echo "Removing state and backups..."
rm -rf ~/.local/state/uke
rm -rf ~/.uke-backups
echo "  ✓ State removed"

# 5. Stop services (optional)
echo "Stopping services..."
if command -v yabai &>/dev/null; then
    yabai --stop-service 2>/dev/null || true
    skhd --stop-service 2>/dev/null || true
    echo "  ✓ Services stopped"
fi

echo ""
echo "${GREEN}✓ UKE removed successfully.${RESET}"
echo ""
echo "To completely remove source:"
echo "  rm -rf $UKE_ROOT"
echo ""
echo "To reinstall later:"
echo "  cd $UKE_ROOT && ./scripts/install.sh"
