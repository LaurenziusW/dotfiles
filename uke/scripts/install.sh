#!/usr/bin/env bash
# ==============================================================================
# UKE Installer v7.3 - DO NOT RUN WITH SUDO
# ==============================================================================
# Run as normal user: ./scripts/install.sh
# Only specific operations (services, hooks) will prompt for sudo
# ==============================================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UKE_ROOT="${SCRIPT_DIR%/scripts}"

RED=$'\e[31m' GREEN=$'\e[32m' YELLOW=$'\e[33m' BLUE=$'\e[34m'
CYAN=$'\e[36m' BOLD=$'\e[1m' DIM=$'\e[2m' RESET=$'\e[0m'

ok()   { echo "${GREEN}✓${RESET} $*" >&2; }
fail() { echo "${RED}✗${RESET} $*" >&2; }
info() { echo "${BLUE}→${RESET} $*" >&2; }
warn() { echo "${YELLOW}!${RESET} $*" >&2; }

# ==============================================================================
# Check if running as root (BAD)
# ==============================================================================
if [[ $EUID -eq 0 ]]; then
    fail "Do NOT run this script as root/sudo!"
    echo "Run as normal user: ./scripts/install.sh"
    exit 1
fi

# ==============================================================================
# Fix ownership if needed
# ==============================================================================
fix_ownership() {
    # Check if UKE files are owned by root (common after unzip as root)
    local owner
    owner=$(ls -ld "$UKE_ROOT/bin/uke" 2>/dev/null | awk '{print $3}')
    
    if [[ "$owner" == "root" ]]; then
        warn "UKE files are owned by root (probably extracted with sudo)"
        info "Fixing ownership (requires sudo)..."
        sudo chown -R "$USER:$USER" "$UKE_ROOT"
        ok "Ownership fixed"
    fi
}

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
    [[ -f /etc/arch-release ]] && DISTRO="arch"
    [[ -f /etc/debian_version ]] && DISTRO="debian"
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
            echo ""
            echo "Or run the full package check:"
            echo "  $UKE_ROOT/scripts/arch-check.sh"
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
    mkdir -p ~/.config/keyd
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
# Setup Pacman Hook (Arch Linux only)
# ==============================================================================
setup_pacman_hook() {
    if [[ "$DISTRO" != "arch" ]]; then
        return 0
    fi
    
    info "Setting up pacman hook for system snapshots..."
    
    # Create symlink for uke-snapshot in system path (required for pacman hooks)
    if [[ -f "$HOME/.local/bin/uke-snapshot" ]]; then
        info "Creating system symlink for uke-snapshot (requires sudo)..."
        sudo ln -sf "$HOME/.local/bin/uke-snapshot" /usr/local/bin/uke-snapshot 2>/dev/null && \
            ok "Created /usr/local/bin/uke-snapshot symlink" || \
            warn "Could not create system symlink (run manually: sudo ln -sf ~/.local/bin/uke-snapshot /usr/local/bin/uke-snapshot)"
    fi
    
    # Install the pacman hook
    local hook_src="$UKE_ROOT/scripts/pacman-hooks/uke-snapshot.hook"
    local hook_dest="/etc/pacman.d/hooks/uke-snapshot.hook"
    
    if [[ -f "$hook_src" ]]; then
        sudo mkdir -p /etc/pacman.d/hooks 2>/dev/null
        sudo cp "$hook_src" "$hook_dest" 2>/dev/null && \
            ok "Installed pacman hook" || \
            warn "Could not install pacman hook (run manually: sudo cp $hook_src $hook_dest)"
    fi
}

# ==============================================================================
# Link Generated Configs
# ==============================================================================
link_configs() {
    info "Linking generated configs..."
    
    if [[ "$OS" == "macos" ]]; then
        [[ -f "$UKE_ROOT/gen/skhd/skhdrc" ]] && {
            ln -sf "$UKE_ROOT/gen/skhd/skhdrc" "$HOME/.config/skhd/skhdrc"
            ok "Linked: skhdrc"
        }
        
        [[ -f "$UKE_ROOT/gen/yabai/yabairc" ]] && {
            ln -sf "$UKE_ROOT/gen/yabai/yabairc" "$HOME/.config/yabai/yabairc"
            ok "Linked: yabairc"
        }
    else
        [[ -f "$UKE_ROOT/gen/hyprland/hyprland.conf" ]] && {
            ln -sf "$UKE_ROOT/gen/hyprland/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
            ok "Linked: hyprland.conf"
        }
    fi
}

# ==============================================================================
# Stow Dotfiles
# ==============================================================================
stow_dotfiles() {
    info "Stowing dotfiles..."
    
    local stow_dir="$UKE_ROOT/stow"
    
    if [[ ! -d "$stow_dir" ]]; then
        warn "Stow directory not found: $stow_dir"
        warn "Skipping dotfile stowing - create stow packages first"
        return 0
    fi
    
    # Check if stow directory has any packages
    local has_packages=false
    for dir in "$stow_dir"/*/; do
        if [[ -d "$dir" ]]; then
            has_packages=true
            break
        fi
    done
    
    if [[ "$has_packages" == "false" ]]; then
        warn "No stow packages found in $stow_dir"
        return 0
    fi
    
    cd "$stow_dir"
    
    local packages=(wezterm tmux zsh nvim zathura)
    [[ "$OS" == "macos" ]] && packages+=(karabiner)
    [[ "$OS" == "linux" ]] && packages+=(keyd)
    
    for pkg in "${packages[@]}"; do
        if [[ -d "$pkg" ]]; then
            # Check if package has content
            if find "$pkg" -mindepth 1 -maxdepth 1 | grep -q .; then
                stow -t "$HOME" -R "$pkg" 2>/dev/null && ok "Stowed: $pkg" || warn "Skipped: $pkg (conflict?)"
            else
                warn "Package empty: $pkg"
            fi
        fi
    done
}

# ==============================================================================
# Setup Hardware Profile
# ==============================================================================
setup_profile() {
    local profile_dir="${XDG_STATE_HOME:-$HOME/.local/state}/uke"
    local profile_file="$profile_dir/machine.profile"
    
    info "Checking for hardware profile at: $profile_file"
    
    if [[ -f "$profile_file" ]]; then
        ok "Hardware profile found"
        info "Generating hardware configs..."
        
        # Run apply_profile.sh with proper error handling
        if bash "$UKE_ROOT/scripts/apply_profile.sh"; then
            ok "Hardware configs generated"
        else
            warn "apply_profile.sh had errors (this is usually fine for first install)"
        fi
    else
        warn "No hardware profile found"
        echo ""
        echo "  ${BOLD}Create one now with:${RESET}"
        echo "    uke profile"
        echo ""
        echo "  ${BOLD}Then apply it:${RESET}"
        echo "    uke apply"
        echo ""
        
        # Create placeholder for Hyprland so it doesn't crash
        if [[ "$OS" == "linux" ]]; then
            local hypr_dir="$HOME/.config/hypr"
            local hypr_hw="$hypr_dir/generated_hardware.conf"
            if [[ ! -f "$hypr_hw" ]]; then
                mkdir -p "$hypr_dir"
                cat > "$hypr_hw" << 'EOF'
# Placeholder - run 'uke profile' then 'uke apply' to configure
monitor=,preferred,auto,1
general {
    gaps_in = 2
    gaps_out = 4
    border_size = 2
}
EOF
                ok "Created placeholder hardware config"
            fi
        fi
    fi
}

# ==============================================================================
# Setup Hyprland Auto-start (Linux only)
# ==============================================================================
setup_autostart() {
    if [[ "$OS" != "linux" ]]; then
        return 0
    fi
    
    info "Setting up Hyprland auto-start..."
    
    # Create the auto-start entry in .zprofile if using zsh
    local zprofile="$HOME/.zprofile"
    local marker="# UKE Hyprland Auto-start"
    
    if ! grep -q "$marker" "$zprofile" 2>/dev/null; then
        cat >> "$zprofile" << 'AUTOSTART'

# UKE Hyprland Auto-start
# Start Hyprland on TTY1 login with fallback
if [[ -z "${DISPLAY:-}" ]] && [[ "${XDG_VTNR:-}" == "1" ]] && [[ -z "${WAYLAND_DISPLAY:-}" ]]; then
    if command -v uke-autostart &>/dev/null; then
        exec uke-autostart
    elif command -v Hyprland &>/dev/null; then
        exec Hyprland
    fi
fi
AUTOSTART
        ok "Added auto-start to $zprofile"
    else
        ok "Auto-start already configured in $zprofile"
    fi
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
    printf "%s║%s     UKE v7.3 Installer               %s║%s\n" "$CYAN" "$BOLD" "$CYAN" "$RESET"
    printf "%s╚══════════════════════════════════════╝%s\n" "$CYAN" "$RESET"
    echo ""
    echo "Platform: $OS"
    [[ -n "$DISTRO" ]] && echo "Distro:   $DISTRO"
    echo "UKE Root: $UKE_ROOT"
    echo ""
    
    # Always fix ownership first
    fix_ownership
    
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
        --autostart)
            setup_autostart
            ;;
        full|*)
            check_deps
            create_dirs
            generate_configs
            link_binaries
            link_configs
            stow_dotfiles
            setup_profile
            setup_autostart
            setup_pacman_hook
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
            echo "  uke doctor    # Diagnose issues"
            echo ""
            if [[ "$OS" == "linux" ]]; then
                echo "Auto-start:"
                echo "  Hyprland will auto-start on TTY1 login"
                echo "  To disable: remove UKE block from ~/.zprofile"
            fi
            ;;
    esac
}

main "$@"
