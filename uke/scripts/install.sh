#!/usr/bin/env bash
# ==============================================================================
# UKE Installer v7.0 - Complete Setup with Hardware Profile
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UKE_ROOT="${SCRIPT_DIR%/scripts}"

# Colors
RED=$'\e[31m' GREEN=$'\e[32m' YELLOW=$'\e[33m' BLUE=$'\e[34m'
CYAN=$'\e[36m' BOLD=$'\e[1m' DIM=$'\e[2m' RESET=$'\e[0m'

ok()   { echo "${GREEN}✓${RESET} $*"; }
fail() { echo "${RED}✗${RESET} $*"; }
info() { echo "${BLUE}→${RESET} $*"; }
warn() { echo "${YELLOW}!${RESET} $*"; }

# ==============================================================================
# OS Detection
# ==============================================================================
case "$(uname -s)" in
    Darwin) OS="macos" ;;
    Linux)  OS="linux" ;;
    *)      echo "Unsupported OS"; exit 1 ;;
esac

DISTRO=""
if [[ "$OS" == "linux" ]]; then
    if [[ -f /etc/arch-release ]]; then
        DISTRO="arch"
    elif [[ -f /etc/debian_version ]]; then
        DISTRO="debian"
    elif [[ -f /etc/fedora-release ]]; then
        DISTRO="fedora"
    fi
fi

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
        fail "Missing: ${missing[*]}"
        echo ""
        echo "Install with:"
        if [[ "$OS" == "macos" ]]; then
            echo "  brew install ${missing[*]}"
        elif [[ "$DISTRO" == "arch" ]]; then
            echo "  sudo pacman -S ${missing[*]}"
        else
            echo "  Please install: ${missing[*]}"
        fi
        exit 1
    fi
    
    ok "All dependencies installed"
}

# ==============================================================================
# Create Directories
# ==============================================================================
create_dirs() {
    info "Creating directories..."
    mkdir -p ~/.local/bin
    mkdir -p ~/.local/state/uke
    mkdir -p ~/.config/skhd
    mkdir -p ~/.config/yabai
    mkdir -p ~/.config/hypr
    mkdir -p ~/.config/alacritty
    mkdir -p ~/.config/wezterm
    mkdir -p "$UKE_ROOT/gen"/{skhd,yabai,hyprland}
    ok "Directories created"
}

# ==============================================================================
# Generate Configs
# ==============================================================================
generate_configs() {
    info "Generating configs..."
    bash "$UKE_ROOT/lib/gen.sh" all
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
    [[ "$OS" == "macos" ]] && packages+=(karabiner)
    
    for pkg in "${packages[@]}"; do
        if [[ -d "$pkg" ]]; then
            stow -t "$HOME" -R "$pkg" 2>/dev/null && ok "Stowed: $pkg" || warn "Skipped: $pkg"
        fi
    done
}

# ==============================================================================
# Setup Hardware Profile
# ==============================================================================
setup_profile() {
    info "Setting up hardware profile..."
    
    if [[ -f "$HOME/.local/state/uke/machine.profile" ]]; then
        ok "Hardware profile exists"
    else
        info "Creating initial hardware profile..."
        bash "$UKE_ROOT/scripts/manage_profile.sh" --auto
    fi
    
    # Generate hardware ghost files
    info "Generating hardware configs..."
    bash "$UKE_ROOT/scripts/apply_profile.sh"
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
        if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
            hyprctl reload 2>/dev/null && ok "hyprland reloaded" || warn "hyprland reload failed"
        else
            warn "Hyprland not running - config will load on next start"
        fi
    fi
}

# ==============================================================================
# Main
# ==============================================================================
main() {
    echo ""
    printf "%s╔══════════════════════════════════════╗%s\n" "$CYAN" "$RESET"
    printf "%s║%s     UKE v7.0 Installer               %s║%s\n" "$CYAN" "$BOLD" "$CYAN" "$RESET"
    printf "%s╚══════════════════════════════════════╝%s\n" "$CYAN" "$RESET"
    echo ""
    echo "Platform: $OS"
    [[ -n "$DISTRO" ]] && echo "Distro:   $DISTRO"
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
        --profile)
            setup_profile
            ;;
        full|*)
            check_deps
            create_dirs
            generate_configs
            link_binaries
            link_configs
            stow_dotfiles
            setup_profile
            start_services
            
            echo ""
            echo "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
            echo "${GREEN}✓ Installation complete!${RESET}"
            echo ""
            echo "Next steps:"
            echo "  1. Restart terminal (or: source ~/.zshrc)"
            echo "  2. Customize hardware: uke profile"
            echo "  3. Regenerate if needed: uke gen && uke reload"
            echo ""
            echo "Quick commands:"
            echo "  uke status    # Show current status"
            echo "  uke help      # Full command reference"
            ;;
    esac
}

main "$@"
