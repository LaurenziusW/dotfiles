#!/usr/bin/env bash
set -euo pipefail

# ═══════════════════════════════════════════════════════════
# ARCH LINUX BOOTSTRAP
# Automated setup for Unified Keyboard Environment
# ═══════════════════════════════════════════════════════════

readonly DOTFILES="${DOTFILES_ROOT:-$HOME/dotfiles}"

[[ $EUID -eq 0 ]] && { echo "Don't run as root"; exit 1; }

# ───────────────────────────────────────────────────────────
# AUR Helper
# ───────────────────────────────────────────────────────────

if ! command -v yay &>/dev/null; then
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay && makepkg -si --noconfirm
    cd ~
fi

# ───────────────────────────────────────────────────────────
# System Packages
# ───────────────────────────────────────────────────────────

sudo pacman -S --needed --noconfirm \
    stow git base-devel \
    neovim tmux zsh \
    ripgrep fd fzf bat eza \
    wezterm \
    hyprland xdg-desktop-portal-hyprland \
    qt5-wayland qt6-wayland \
    waybar wofi dunst \
    swaylock swayidle wl-clipboard \
    grim slurp swappy \
    brightnessctl playerctl pavucontrol \
    polkit-kde-agent \
    ttf-jetbrains-mono-nerd \
    noto-fonts noto-fonts-emoji \
    network-manager-applet

# ───────────────────────────────────────────────────────────
# keyd (System-wide Key Remapping)
# ───────────────────────────────────────────────────────────

yay -S --needed --noconfirm keyd

sudo systemctl enable --now keyd

# ───────────────────────────────────────────────────────────
# Shell Configuration
# ───────────────────────────────────────────────────────────

if [[ $SHELL != */zsh ]]; then
    chsh -s /usr/bin/zsh
fi

# Zsh plugins
sudo pacman -S --needed --noconfirm \
    zsh-completions \
    zsh-syntax-highlighting \
    zsh-autosuggestions

# Optional: starship prompt
yay -S --needed --noconfirm starship

# ───────────────────────────────────────────────────────────
# Dotfiles Deployment
# ───────────────────────────────────────────────────────────

if [[ -d "$DOTFILES" ]]; then
    cd "$DOTFILES"
    ./scripts/install.sh
else
    echo "Clone dotfiles to $DOTFILES first"
    echo "git clone <repo> $DOTFILES"
    exit 1
fi

# ───────────────────────────────────────────────────────────
# Post-Install
# ───────────────────────────────────────────────────────────

echo ""
echo "Bootstrap complete"
echo ""
echo "Next steps:"
echo "  1. Reboot (for keyd and Hyprland)"
echo "  2. Select Hyprland in display manager"
echo "  3. Run: ~/dotfiles/scripts/maintenance/system-health.sh"
