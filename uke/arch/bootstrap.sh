#!/usr/bin/env bash
# =============================================================================
# UKE v8 - Arch Linux Bootstrap
# Installs git, stow, hyprland, and sets up a minimal environment.
# =============================================================================
set -e

echo ">> [1/5] Updating System & Installing Essentials..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm \
    base-devel \
    git \
    stow \
    neovim \
    hyprland \
    keyd \
    waybar \
    wezterm \
    wofi \
    fzf \
    ttf-jetbrains-mono-nerd \
    firefox

echo ">> [2/5] Creating Directory Structure..."
# Create the stow targets in HOME so stow doesn't symlink the parent folders
mkdir -p ~/.config/{hypr,waybar,nvim,wezterm,yabai,skhd}
mkdir -p ~/.local/{bin,state/uke,share}

echo ">> [3/5] Creating Minimal Recovery Hyprland Config..."
# IMPORTANT: We use 'EOF' (quoted) to prevent $variable expansion during generation
cat > ~/.config/hypr/hyprland.conf <<'EOF'
# --- RECOVERY CONFIG ---
monitor=,preferred,auto,1

input {
    kb_layout = us
    follow_mouse = 1
}

general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(33ccffee)
    layout = dwindle
}

$mainMod = SUPER

# Essentials
bind = $mainMod, RETURN, exec, wezterm
bind = $mainMod, B, exec, firefox
bind = $mainMod, M, exit, 
bind = $mainMod, Q, killactive, 
bind = $mainMod, Space, exec, wofi --show drun

# Navigation
bind = $mainMod, h, movefocus, l
bind = $mainMod, l, movefocus, r
bind = $mainMod, k, movefocus, u
bind = $mainMod, j, movefocus, d

exec-once = waybar
EOF

echo ">> [4/5] Creating Dummy Local Overrides..."
# This prevents errors when you eventually stow your real configs
touch ~/.config/hypr/local.conf
touch ~/.zshrc.local
mkdir -p ~/.config/wezterm
echo "return {}\n" > ~/.config/wezterm/local.lua

echo ">> [5/5] Bootstrap Complete!"
echo "----------------------------------------------------------------"
echo "You can now type 'Hyprland' to start the graphical session."
echo ""
echo "Once inside:"
echo "  1. Open Terminal (Super + Enter)"
echo "  2. Clone your repo (if not done): git clone <url> ~/dotfiles/newuke"
echo "  3. Run: ~/dotfiles/newuke/installation_manager.sh install"
echo "----------------------------------------------------------------"
