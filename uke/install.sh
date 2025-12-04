#!/usr/bin/env bash
# =============================================================================
# UKE v8 - Install Script
# Just stows the configs, nothing magical
# =============================================================================

set -euo pipefail

UKE_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "╔════════════════════════════════════════════════════════════════════════╗"
echo "║  UKE v8 - Unified Keyboard Environment                                 ║"
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

# Stow shared configs
echo "→ Stowing shared configs..."
cd "$UKE_DIR/shared"
stow -v -t "$HOME" . 2>&1 | grep -v "^LINK:" || true

# Stow platform-specific configs
echo "→ Stowing $PLATFORM_DIR configs..."
cd "$UKE_DIR/$PLATFORM_DIR"
stow -v -t "$HOME" . 2>&1 | grep -v "^LINK:" || true

# Make scripts executable
echo "→ Setting permissions..."
chmod +x "$HOME/.local/bin/uke-"* 2>/dev/null || true

echo ""
echo "✓ Done!"
echo ""
echo "Next steps:"
if [[ "$OS" == "macos" ]]; then
    echo "  1. Start services: yabai --start-service && skhd --start-service"
    echo "  2. For full features, partially disable SIP (see README)"
    echo "  3. Reload: Cmd+Alt+y (yabai) / Cmd+Alt+s (skhd)"
else
    echo "  1. Copy keyd config: sudo cp ~/.config/keyd/default.conf /etc/keyd/"
    echo "  2. Enable keyd: sudo systemctl enable --now keyd"
    echo "  3. Log out and back in to start Hyprland"
fi
