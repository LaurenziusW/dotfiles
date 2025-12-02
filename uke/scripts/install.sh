#!/usr/bin/env bash
# ==============================================================================
# UKE Installer v6.1
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UKE_ROOT="${SCRIPT_DIR%/scripts}"

# Colors
RED=$'\e[31m' GREEN=$'\e[32m' YELLOW=$'\e[33m' BLUE=$'\e[34m'
BOLD=$'\e[1m' RESET=$'\e[0m'

ok()   { echo "${GREEN}✓${RESET} $*"; }
fail() { echo "${RED}✗${RESET} $*"; }
info() { echo "${BLUE}→${RESET} $*"; }
warn() { echo "${YELLOW}!${RESET} $*"; }

# OS Detection
case "$(uname -s)" in
    Darwin) OS="macos" ;;
    Linux)  OS="linux" ;;
    *)      echo "Unsupported OS"; exit 1 ;;
esac

# ==============================================================================
# Dependency Check
# ==============================================================================
check_deps() {
    info "Checking dependencies..."
    local missing=()
    
    for cmd in git stow jq; do
        command -v "$cmd" &>/dev/null || missing+=("$cmd")
    done
    
    if [[ "$OS" == "macos" ]]; then
        command -v yabai &>/dev/null || missing+=("yabai")
        command -v skhd &>/dev/null || missing+=("skhd")
    else
        command -v hyprctl &>/dev/null || missing+=("hyprland")
    fi
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        fail "Missing dependencies: ${missing[*]}"
        echo ""
        echo "Install with:"
        if [[ "$OS" == "macos" ]]; then
            echo "  brew install ${missing[*]}"
        else
            echo "  sudo pacman -S ${missing[*]}"
        fi
        exit 1
    fi
    
    ok "All dependencies installed"
}

# ==============================================================================
# Generate Configs
# ==============================================================================
generate_configs() {
    info "Generating configs..."
    bash "$UKE_ROOT/lib/gen.sh" all
}

# ==============================================================================
# Create Directories
# ==============================================================================
create_dirs() {
    info "Creating directories..."
    mkdir -p ~/.local/bin
    mkdir -p ~/.config/skhd
    mkdir -p ~/.config/yabai
    mkdir -p ~/.config/hypr
    ok "Directories created"
}

# ==============================================================================
# Link Binaries
# ==============================================================================
link_binaries() {
    info "Linking binaries to ~/.local/bin..."
    
    for bin in "$UKE_ROOT/bin"/*; do
        [[ -f "$bin" ]] || continue
        local name=$(basename "$bin")
        chmod +x "$bin"
        ln -sf "$bin" "$HOME/.local/bin/$name"
        ok "Linked: $name"
    done
}

# ==============================================================================
# Link Generated Configs
# ==============================================================================
link_configs() {
    info "Linking generated configs..."
    
    if [[ "$OS" == "macos" ]]; then
        ln -sf "$UKE_ROOT/gen/skhd/skhdrc" "$HOME/.config/skhd/skhdrc"
        ok "Linked: skhdrc"
        
        ln -sf "$UKE_ROOT/gen/yabai/yabairc" "$HOME/.config/yabai/yabairc"
        ok "Linked: yabairc"
    else
        ln -sf "$UKE_ROOT/gen/hyprland/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
        ok "Linked: hyprland.conf"
    fi
}

# ==============================================================================
# Stow Dotfiles
# ==============================================================================
stow_dotfiles() {
    info "Stowing dotfiles..."
    cd "$UKE_ROOT/stow"
    
    local packages=(wezterm tmux zsh nvim)
    
    # Note: keyd is managed separately (requires sudo/system-level config)
    if [[ "$OS" == "macos" ]]; then
        packages+=(karabiner)
    fi
    
    for pkg in "${packages[@]}"; do
        if [[ -d "$pkg" ]]; then
            stow -t "$HOME" -R "$pkg" 2>/dev/null && ok "Stowed: $pkg" || warn "Skipped: $pkg"
        fi
    done
}

# ==============================================================================
# Make Bunches Executable
# ==============================================================================
setup_bunches() {
    info "Setting up bunches..."
    chmod +x "$UKE_ROOT/bunches"/*.sh 2>/dev/null || true
    chmod +x "$UKE_ROOT/templates"/*.sh 2>/dev/null || true
    ok "Bunches ready"
}

# ==============================================================================
# Start Services
# ==============================================================================
start_services() {
    info "Starting services..."
    
    if [[ "$OS" == "macos" ]]; then
        yabai --restart-service 2>/dev/null && ok "yabai restarted" || warn "yabai restart failed"
        skhd --restart-service 2>/dev/null && ok "skhd restarted" || warn "skhd restart failed"
    else
        hyprctl reload 2>/dev/null && ok "hyprland reloaded" || warn "hyprland reload failed"
    fi
}

# ==============================================================================
# Main
# ==============================================================================
main() {
    echo ""
    echo "${BOLD}╔══════════════════════════════════════╗${RESET}"
    echo "${BOLD}║     UKE v6.1 Installer               ║${RESET}"
    echo "${BOLD}╚══════════════════════════════════════╝${RESET}"
    echo ""
    echo "Platform: $OS"
    echo "UKE Root: $UKE_ROOT"
    echo ""
    
    case "${1:-full}" in
        --check)
            check_deps
            ;;
        --stow)
            stow_dotfiles
            ;;
        --link)
            link_binaries
            link_configs
            ;;
        --gen)
            generate_configs
            ;;
        full|*)
            check_deps
            create_dirs
            generate_configs
            link_binaries
            link_configs
            stow_dotfiles
            setup_bunches
            start_services
            
            echo ""
            echo "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
            echo "${GREEN}✓ Installation complete!${RESET}"
            echo ""
            echo "Next steps:"
            echo "  1. Restart your terminal (or run: source ~/.zshrc)"
            echo "  2. Test with: uke status"
            echo "  3. See: docs/CHEATSHEET.md for keybindings"
            ;;
    esac
}

main "$@"
