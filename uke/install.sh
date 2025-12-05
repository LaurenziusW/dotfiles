#!/usr/bin/env bash
# =============================================================================
# UKE v8 - Install Script
# Sets up directories, handles local overrides, and stows configs.
# =============================================================================

set -euo pipefail

UKE_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "╔════════════════════════════════════════════════════════════════════════╗"
echo "║  UKE v8 - Unified Keyboard Environment Installer                       ║"
echo "╚════════════════════════════════════════════════════════════════════════╝"
echo ""

# Detect OS
case "$(uname -s)" in
    Darwin) OS="macos"; PLATFORM_DIR="mac" ;;
    Linux)  OS="linux"; PLATFORM_DIR="arch" ;;
    *)      echo "Unsupported OS"; exit 1 ;;
esac

echo "Detected: $OS"
echo "UKE directory: $UKE_DIR"
echo ""

# Check for stow
if ! command -v stow &>/dev/null; then
    echo "Error: GNU Stow is required but not installed."
    if [[ "$OS" == "macos" ]]; then
        echo "Install with: brew install stow"
    else
        echo "Install with: sudo pacman -S stow"
    fi
    exit 1
fi

# 1. Prepare Directory Structure & Local Overrides
echo "→ Preparing directories and local overrides..."

# Ensure config parents exist
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/state/uke"

# Touch local override files to prevent "source not found" errors
# Hyprland
if [[ "$OS" == "linux" ]]; then
    mkdir -p "$HOME/.config/hypr"
    if [[ ! -f "$HOME/.config/hypr/local.conf" ]]; then
        echo "# Hardware specific overrides" > "$HOME/.config/hypr/local.conf"
        echo "Created empty ~/.config/hypr/local.conf"
    fi
fi

# WezTerm
mkdir -p "$HOME/.config/wezterm"
if [[ ! -f "$HOME/.config/wezterm/local.lua" ]]; then
    echo "return {}" > "$HOME/.config/wezterm/local.lua"
    echo "Created empty ~/.config/wezterm/local.lua"
fi

# Zsh
if [[ ! -f "$HOME/.zshrc.local" ]]; then
    touch "$HOME/.zshrc.local"
    echo "Created empty ~/.zshrc.local"
fi

# 2. Stow Shared Configs
echo "→ Stowing shared configs..."
mkdir -p "$HOME/.config/nvim" # Ensure nvim folder exists for stowing
cd "$UKE_DIR/shared"
stow -v -t "$HOME" . 2>&1 | grep -v "^LINK:" || true

# 3. Stow Platform Configs
echo "→ Stowing $PLATFORM_DIR configs..."
cd "$UKE_DIR/$PLATFORM_DIR"
stow -v -t "$HOME" . 2>&1 | grep -v "^LINK:" || true

# 4. Post-Install Setup
echo "→ Setting permissions..."
chmod +x "$HOME/.local/bin/uke-"* 2>/dev/null || true

echo ""
echo "✓ Done!"
echo ""
echo "Next steps:"
if [[ "$OS" == "macos" ]]; then
    echo "  1. Start services: yabai --start-service && skhd --start-service"
    echo "  2. For full features, partially disable SIP (see docs)"
    echo "  3. Reload: Cmd+Alt+y (yabai) / Cmd+Alt+s (skhd)"
else
    echo "  1. Copy keyd config: sudo cp ~/.config/keyd/default.conf /etc/keyd/"
    echo "  2. Enable keyd: sudo systemctl enable --now keyd"
    echo "  3. Reload Hyprland: hyprctl reload"
fi