#!/usr/bin/env bash
# ==============================================================================
# UKE Arch Linux Package Installer
# ==============================================================================
# Run this after fixing sudo permissions to install all required packages
# ==============================================================================
set -euo pipefail

RED=$'\e[31m' GREEN=$'\e[32m' YELLOW=$'\e[33m' BLUE=$'\e[34m'
BOLD=$'\e[1m' RESET=$'\e[0m'

ok()   { echo "${GREEN}✓${RESET} $*"; }
info() { echo "${BLUE}→${RESET} $*"; }
warn() { echo "${YELLOW}!${RESET} $*"; }

echo ""
echo "${BOLD}╔══════════════════════════════════════╗${RESET}"
echo "${BOLD}║  UKE Arch Linux Package Installer    ║${RESET}"
echo "${BOLD}╚══════════════════════════════════════╝${RESET}"
echo ""

# Check if we can sudo
if ! sudo -n true 2>/dev/null && ! sudo true; then
    echo "${RED}Error: Cannot run sudo. Fix permissions first:${RESET}"
    echo ""
    echo "  1. Switch to TTY: Ctrl + Alt + F3"
    echo "  2. Login as root"
    echo "  3. Run: usermod -aG wheel \$USER"
    echo "  4. Run: EDITOR=nano visudo"
    echo "     → Uncomment: %wheel ALL=(ALL:ALL) ALL"
    echo "  5. Reboot"
    exit 1
fi

info "Updating system..."
sudo pacman -Syu --noconfirm

info "Installing core packages..."

# Essential: Terminal, Launcher, File Manager
sudo pacman -S --noconfirm --needed \
    wezterm \
    wofi \
    thunar

# System tray & Settings
sudo pacman -S --noconfirm --needed \
    waybar \
    dunst \
    pavucontrol \
    network-manager-applet \
    lxappearance

# Clipboard & Screenshots
sudo pacman -S --noconfirm --needed \
    cliphist \
    wl-clipboard \
    grim \
    slurp

# UKE dependencies
sudo pacman -S --noconfirm --needed \
    stow \
    jq \
    git

# Polkit (for privileged operations)
sudo pacman -S --noconfirm --needed \
    polkit-kde-agent

# Optional but recommended
sudo pacman -S --noconfirm --needed \
    neovim \
    ripgrep \
    fd \
    eza \
    bat \
    htop

# keyd (Caps Lock remapping)
if ! pacman -Qi keyd &>/dev/null; then
    info "Installing keyd..."
    sudo pacman -S --noconfirm keyd
fi

# Enable keyd service
info "Enabling keyd service..."
sudo systemctl enable --now keyd || warn "keyd service may need manual setup"

echo ""
ok "All packages installed!"
echo ""
echo "Next steps:"
echo "  1. Run: cd ~/dotfiles/uke && ./bin/uke gen"
echo "  2. Run: hyprctl reload"
echo "  3. Test Spotlight: Alt + Super + Space"
echo "  4. Test Zoom: Alt + Super + ="
echo ""
echo "System tools:"
echo "  • Audio:      pavucontrol"
echo "  • Appearance: lxappearance (or Alt+Super+s)"
echo "  • Network:    nm-connection-editor"
echo "  • Files:      thunar (or Alt+Super+f)"
echo ""
