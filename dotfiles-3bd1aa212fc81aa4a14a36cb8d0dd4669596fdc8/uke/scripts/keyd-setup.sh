#!/usr/bin/env bash
# ==============================================================================
# UKE keyd Setup Script
# ==============================================================================
# keyd requires system-level configuration in /etc/keyd/
# This script handles the sudo operations needed for keyd setup.
#
# Usage:
#   ./keyd-setup.sh           # Install and enable keyd config
#   ./keyd-setup.sh --status  # Check keyd status
#   ./keyd-setup.sh --remove  # Remove UKE keyd config
#   ./keyd-setup.sh --reload  # Reload keyd service
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UKE_ROOT="${SCRIPT_DIR%/scripts}"
KEYD_SOURCE="$UKE_ROOT/stow/keyd/.config/keyd/default.conf"
KEYD_TARGET="/etc/keyd/default.conf"

# Colors
RED=$'\e[31m' GREEN=$'\e[32m' YELLOW=$'\e[33m' BLUE=$'\e[34m'
BOLD=$'\e[1m' RESET=$'\e[0m'

ok()   { echo "${GREEN}✓${RESET} $*"; }
fail() { echo "${RED}✗${RESET} $*"; }
info() { echo "${BLUE}→${RESET} $*"; }
warn() { echo "${YELLOW}!${RESET} $*"; }

# ==============================================================================
# Check Prerequisites
# ==============================================================================
check_prereqs() {
    if [[ "$(uname -s)" != "Linux" ]]; then
        fail "keyd is only available on Linux"
        exit 1
    fi
    
    if ! command -v keyd &>/dev/null; then
        fail "keyd not installed"
        echo ""
        echo "Install with:"
        if command -v pacman &>/dev/null; then
            echo "  sudo pacman -S keyd"
        elif command -v apt &>/dev/null; then
            echo "  # Build from source: https://github.com/rvaiya/keyd"
        fi
        exit 1
    fi
    
    if [[ ! -f "$KEYD_SOURCE" ]]; then
        fail "Source config not found: $KEYD_SOURCE"
        exit 1
    fi
}

# ==============================================================================
# Install keyd Config
# ==============================================================================
install_keyd() {
    check_prereqs
    
    info "Installing keyd configuration..."
    
    # Create /etc/keyd if it doesn't exist
    if [[ ! -d /etc/keyd ]]; then
        sudo mkdir -p /etc/keyd
        ok "Created /etc/keyd/"
    fi
    
    # Symlink the config
    sudo ln -sf "$KEYD_SOURCE" "$KEYD_TARGET"
    ok "Linked config to $KEYD_TARGET"
    
    # Enable and start/restart keyd service
    if systemctl is-active keyd &>/dev/null; then
        sudo systemctl restart keyd
        ok "keyd service restarted"
    else
        sudo systemctl enable --now keyd
        ok "keyd service enabled and started"
    fi
    
    echo ""
    echo "${GREEN}keyd setup complete!${RESET}"
    echo ""
    echo "Your Caps Lock key now works as:"
    echo "  • Tap: Escape"
    echo "  • Hold + hjkl: Arrow keys"
    echo "  • Hold + yuio: Home/PageUp/PageDown/End"
    echo "  • Hold + wasd: Selection (Shift+Arrow)"
    echo "  • Hold + qe:   Word selection (Ctrl+Shift+Arrow)"
    echo ""
}

# ==============================================================================
# Show Status
# ==============================================================================
show_status() {
    echo "${BOLD}keyd Status:${RESET}"
    echo ""
    
    # Check if keyd is installed
    if command -v keyd &>/dev/null; then
        ok "keyd installed: $(keyd --version 2>/dev/null || echo 'version unknown')"
    else
        fail "keyd not installed"
        return 1
    fi
    
    # Check service status
    if systemctl is-active keyd &>/dev/null; then
        ok "keyd service: active"
    else
        fail "keyd service: inactive"
    fi
    
    # Check config symlink
    if [[ -L "$KEYD_TARGET" ]]; then
        local target=$(readlink "$KEYD_TARGET")
        ok "Config symlink: $KEYD_TARGET → $target"
    elif [[ -f "$KEYD_TARGET" ]]; then
        warn "Config exists but not a symlink: $KEYD_TARGET"
    else
        fail "Config not found: $KEYD_TARGET"
    fi
    
    echo ""
    
    # Show current config summary
    if [[ -f "$KEYD_TARGET" ]]; then
        info "Current config summary:"
        grep -E "^\[|^[a-z]+ = " "$KEYD_TARGET" 2>/dev/null | head -20 || true
    fi
}

# ==============================================================================
# Remove keyd Config
# ==============================================================================
remove_keyd() {
    info "Removing UKE keyd configuration..."
    
    if [[ -L "$KEYD_TARGET" ]]; then
        sudo rm "$KEYD_TARGET"
        ok "Removed symlink: $KEYD_TARGET"
    elif [[ -f "$KEYD_TARGET" ]]; then
        warn "Config is not a symlink, not removing: $KEYD_TARGET"
    else
        warn "Config not found: $KEYD_TARGET"
    fi
    
    # Restart keyd to use default config (if any)
    if systemctl is-active keyd &>/dev/null; then
        sudo systemctl restart keyd
        ok "keyd service restarted"
    fi
    
    echo ""
    echo "keyd config removed. Your Caps Lock should return to normal after restart."
}

# ==============================================================================
# Reload keyd
# ==============================================================================
reload_keyd() {
    info "Reloading keyd service..."
    
    if ! systemctl is-active keyd &>/dev/null; then
        sudo systemctl start keyd
        ok "keyd service started"
    else
        sudo keyd reload
        ok "keyd reloaded"
    fi
}

# ==============================================================================
# Main
# ==============================================================================
case "${1:-install}" in
    install|--install)
        install_keyd
        ;;
    status|--status)
        show_status
        ;;
    remove|--remove|uninstall|--uninstall)
        remove_keyd
        ;;
    reload|--reload)
        reload_keyd
        ;;
    -h|--help|help)
        echo "UKE keyd Setup Script"
        echo ""
        echo "Usage:"
        echo "  $0 [command]"
        echo ""
        echo "Commands:"
        echo "  install   Install and enable keyd config (default)"
        echo "  status    Show keyd status"
        echo "  remove    Remove UKE keyd config"
        echo "  reload    Reload keyd service"
        echo "  help      Show this help"
        ;;
    *)
        fail "Unknown command: $1"
        echo "Run '$0 --help' for usage"
        exit 1
        ;;
esac
