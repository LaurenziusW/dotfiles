#!/usr/bin/env bash
# ==============================================================================
# UKE Arch Linux Package Checker & Installer v7.1
# ==============================================================================
# Comprehensive package verification and installation for Arch Linux.
# Checks all dependencies, optional packages, and sets up services.
#
# Usage:
#   ./arch-check.sh           # Check and optionally install missing packages
#   ./arch-check.sh --check   # Check only, don't install
#   ./arch-check.sh --install # Install without prompts
#   ./arch-check.sh --aur     # Also check/install AUR packages
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UKE_ROOT="${SCRIPT_DIR%/scripts}"

# Colors
RED=$'\e[31m' GREEN=$'\e[32m' YELLOW=$'\e[33m' BLUE=$'\e[34m'
CYAN=$'\e[36m' BOLD=$'\e[1m' DIM=$'\e[2m' RESET=$'\e[0m'

ok()   { printf "%s✓%s %s\n" "$GREEN" "$RESET" "$*"; }
fail() { printf "%s✗%s %s\n" "$RED" "$RESET" "$*"; }
info() { printf "%s→%s %s\n" "$BLUE" "$RESET" "$*"; }
warn() { printf "%s!%s %s\n" "$YELLOW" "$RESET" "$*"; }

# ==============================================================================
# Package Lists
# ==============================================================================

# Core UKE dependencies (REQUIRED)
CORE_PACKAGES=(
    "hyprland"        # Window manager
    "stow"            # Dotfile manager
    "jq"              # JSON processor
    "git"             # Version control
    "wezterm"         # Terminal emulator
)

# Window manager ecosystem (REQUIRED for full UKE experience)
WM_PACKAGES=(
    "wofi"            # Application launcher
    "waybar"          # Status bar
    "dunst"           # Notification daemon
    "hyprpaper"       # Wallpaper
    "hypridle"        # Idle manager
    "hyprlock"        # Screen locker
)

# Clipboard and screenshots (REQUIRED)
UTIL_PACKAGES=(
    "wl-clipboard"    # Wayland clipboard
    "cliphist"        # Clipboard history
    "grim"            # Screenshot
    "slurp"           # Region selection
    "zathura"         # PDF viewer (vim-like)
    "zathura-pdf-mupdf" # PDF plugin
)

# System tray and settings (RECOMMENDED)
SYSTEM_PACKAGES=(
    "pavucontrol"           # Audio settings
    "network-manager-applet" # Network tray icon
    "blueman"               # Bluetooth manager
    "lxappearance"          # GTK theme settings
    "polkit-kde-agent"      # Privileged operations
    "thunar"                # File manager
)

# Development tools (RECOMMENDED)
DEV_PACKAGES=(
    "neovim"          # Text editor
    "ripgrep"         # Fast grep
    "fd"              # Fast find
    "eza"             # Modern ls
    "bat"             # Better cat
    "htop"            # Process viewer
    "tmux"            # Terminal multiplexer
    "go-yq"           # YAML processor
    "reflector"       # Mirror optimization
    "pacman-contrib"  # paccache, checkupdates
    "fzf"             # Fuzzy finder
    "zsh-autosuggestions"    # Shell suggestions
    "zsh-syntax-highlighting" # Shell syntax colors
)

# Keyboard remapping (OPTIONAL but recommended)
KEYBOARD_PACKAGES=(
    "keyd"            # Key remapping daemon
)

# Fonts (RECOMMENDED)
FONT_PACKAGES=(
    "ttf-jetbrains-mono-nerd"  # Terminal font with icons
    "noto-fonts-emoji"         # Emoji support
)

# AUR packages (OPTIONAL, require AUR helper)
AUR_PACKAGES=(
    "brave-bin"       # Brave browser
    "spotify"         # Music
    "visual-studio-code-bin"  # VS Code
    "obsidian"        # Note-taking
)

# ==============================================================================
# Helper Functions
# ==============================================================================
check_package() {
    local pkg="$1"
    pacman -Qi "$pkg" &>/dev/null
}

check_aur_helper() {
    command -v yay &>/dev/null && echo "yay" && return 0
    command -v paru &>/dev/null && echo "paru" && return 0
    return 1
}

# ==============================================================================
# Check Package Group
# ==============================================================================
check_group() {
    local group_name="$1"
    shift
    local packages=("$@")
    local missing=()
    local installed=()
    
    echo ""
    printf "%s%s:%s\n" "$BOLD" "$group_name" "$RESET"
    
    for pkg in "${packages[@]}"; do
        if check_package "$pkg"; then
            installed+=("$pkg")
            printf "  %s✓%s %s\n" "$GREEN" "$RESET" "$pkg"
        else
            missing+=("$pkg")
            printf "  %s✗%s %s (missing)\n" "$RED" "$RESET" "$pkg"
        fi
    done
    
    echo "${#missing[@]}"
}

# ==============================================================================
# Install Packages
# ==============================================================================
install_packages() {
    local packages=("$@")
    
    if [[ ${#packages[@]} -eq 0 ]]; then
        return 0
    fi
    
    info "Installing: ${packages[*]}"
    sudo pacman -S --noconfirm --needed "${packages[@]}"
}

install_aur_packages() {
    local helper="$1"
    shift
    local packages=("$@")
    
    if [[ ${#packages[@]} -eq 0 ]]; then
        return 0
    fi
    
    info "Installing from AUR: ${packages[*]}"
    "$helper" -S --noconfirm --needed "${packages[@]}" 2>/dev/null || {
        warn "Some AUR packages failed to install"
    }
}

# ==============================================================================
# Setup Services
# ==============================================================================
setup_services() {
    info "Setting up services..."
    
    # keyd service
    if check_package "keyd"; then
        if ! systemctl is-enabled keyd &>/dev/null; then
            sudo systemctl enable keyd
            ok "keyd service enabled"
        fi
        if ! systemctl is-active keyd &>/dev/null; then
            sudo systemctl start keyd
            ok "keyd service started"
        else
            ok "keyd service running"
        fi
    fi
    
    # Bluetooth
    if check_package "bluez"; then
        if ! systemctl is-enabled bluetooth &>/dev/null; then
            sudo systemctl enable bluetooth
            ok "bluetooth service enabled"
        fi
    fi
    
    # NetworkManager
    if check_package "networkmanager"; then
        if ! systemctl is-enabled NetworkManager &>/dev/null; then
            sudo systemctl enable NetworkManager
            ok "NetworkManager service enabled"
        fi
    fi
}

# ==============================================================================
# Verify Sudo
# ==============================================================================
verify_sudo() {
    if ! sudo -n true 2>/dev/null; then
        if ! sudo true; then
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
    fi
}

# ==============================================================================
# Create Hardware Ghost File (if missing)
# ==============================================================================
create_hardware_ghost() {
    local hypr_hardware="$HOME/.config/hypr/generated_hardware.conf"
    
    if [[ ! -f "$hypr_hardware" ]]; then
        mkdir -p "$(dirname "$hypr_hardware")"
        cat > "$hypr_hardware" << 'EOF'
# ==============================================================================
# PLACEHOLDER - Run 'uke profile' then 'uke apply' to generate real config
# ==============================================================================
# This file exists to prevent Hyprland errors on first boot
# ==============================================================================

# Default gaps (will be overridden by hardware profile)
general {
    gaps_in = 2
    gaps_out = 4
    border_size = 2
}
EOF
        ok "Created placeholder hardware config"
    fi
}

# ==============================================================================
# Main
# ==============================================================================
main() {
    local mode="${1:---interactive}"
    local check_aur=false
    
    # Parse arguments
    for arg in "$@"; do
        case "$arg" in
            --aur) check_aur=true ;;
        esac
    done
    
    echo ""
    printf "%s╔══════════════════════════════════════╗%s\n" "$CYAN" "$RESET"
    printf "%s║%s  UKE Arch Linux Package Checker     %s║%s\n" "$CYAN" "$BOLD" "$CYAN" "$RESET"
    printf "%s╚══════════════════════════════════════╝%s\n" "$CYAN" "$RESET"
    echo ""
    
    # Collect all missing packages
    local all_missing=()
    local aur_missing=()
    
    # Check each group
    local missing_count
    
    missing_count=$(check_group "Core Dependencies (REQUIRED)" "${CORE_PACKAGES[@]}")
    [[ "$missing_count" -gt 0 ]] && for pkg in "${CORE_PACKAGES[@]}"; do
        check_package "$pkg" || all_missing+=("$pkg")
    done
    
    missing_count=$(check_group "Window Manager Ecosystem" "${WM_PACKAGES[@]}")
    [[ "$missing_count" -gt 0 ]] && for pkg in "${WM_PACKAGES[@]}"; do
        check_package "$pkg" || all_missing+=("$pkg")
    done
    
    missing_count=$(check_group "Clipboard & Screenshots" "${UTIL_PACKAGES[@]}")
    [[ "$missing_count" -gt 0 ]] && for pkg in "${UTIL_PACKAGES[@]}"; do
        check_package "$pkg" || all_missing+=("$pkg")
    done
    
    missing_count=$(check_group "System Utilities" "${SYSTEM_PACKAGES[@]}")
    [[ "$missing_count" -gt 0 ]] && for pkg in "${SYSTEM_PACKAGES[@]}"; do
        check_package "$pkg" || all_missing+=("$pkg")
    done
    
    missing_count=$(check_group "Development Tools" "${DEV_PACKAGES[@]}")
    [[ "$missing_count" -gt 0 ]] && for pkg in "${DEV_PACKAGES[@]}"; do
        check_package "$pkg" || all_missing+=("$pkg")
    done
    
    missing_count=$(check_group "Keyboard Remapping" "${KEYBOARD_PACKAGES[@]}")
    [[ "$missing_count" -gt 0 ]] && for pkg in "${KEYBOARD_PACKAGES[@]}"; do
        check_package "$pkg" || all_missing+=("$pkg")
    done
    
    missing_count=$(check_group "Fonts" "${FONT_PACKAGES[@]}")
    [[ "$missing_count" -gt 0 ]] && for pkg in "${FONT_PACKAGES[@]}"; do
        check_package "$pkg" || all_missing+=("$pkg")
    done
    
    # Check AUR packages if requested
    if [[ "$check_aur" == "true" ]]; then
        local aur_helper
        if aur_helper=$(check_aur_helper); then
            echo ""
            printf "%s%s:%s\n" "$BOLD" "AUR Packages (using $aur_helper)" "$RESET"
            for pkg in "${AUR_PACKAGES[@]}"; do
                if check_package "$pkg"; then
                    printf "  %s✓%s %s\n" "$GREEN" "$RESET" "$pkg"
                else
                    printf "  %s✗%s %s (missing)\n" "$RED" "$RESET" "$pkg"
                    aur_missing+=("$pkg")
                fi
            done
        else
            echo ""
            warn "No AUR helper found (yay/paru). Skipping AUR packages."
            info "Install yay: git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si"
        fi
    fi
    
    # Summary
    echo ""
    echo "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    
    if [[ ${#all_missing[@]} -eq 0 ]] && [[ ${#aur_missing[@]} -eq 0 ]]; then
        echo "${GREEN}✓ All packages installed!${RESET}"
        echo ""
        setup_services
        create_hardware_ghost
        echo ""
        echo "Next steps:"
        echo "  1. Run: cd $UKE_ROOT && ./scripts/install.sh"
        echo "  2. Configure hardware: uke profile"
        echo "  3. Apply profile: uke apply"
        echo "  4. Reload: uke reload"
        exit 0
    fi
    
    echo "${YELLOW}Missing ${#all_missing[@]} official + ${#aur_missing[@]} AUR packages${RESET}"
    
    if [[ "$mode" == "--check" ]]; then
        echo ""
        echo "Install with:"
        [[ ${#all_missing[@]} -gt 0 ]] && echo "  sudo pacman -S ${all_missing[*]}"
        [[ ${#aur_missing[@]} -gt 0 ]] && echo "  yay -S ${aur_missing[*]}"
        exit 1
    fi
    
    if [[ "$mode" == "--install" ]]; then
        verify_sudo
        info "Updating system..."
        sudo pacman -Syu --noconfirm
        install_packages "${all_missing[@]}"
        
        if [[ ${#aur_missing[@]} -gt 0 ]] && aur_helper=$(check_aur_helper); then
            install_aur_packages "$aur_helper" "${aur_missing[@]}"
        fi
        
        setup_services
        create_hardware_ghost
        ok "All packages installed!"
    else
        # Interactive mode
        echo ""
        read -p "Install missing packages? [Y/n] " -n 1 -r
        echo ""
        
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            verify_sudo
            info "Updating system..."
            sudo pacman -Syu --noconfirm
            install_packages "${all_missing[@]}"
            
            if [[ ${#aur_missing[@]} -gt 0 ]]; then
                if aur_helper=$(check_aur_helper); then
                    read -p "Install AUR packages? [Y/n] " -n 1 -r
                    echo ""
                    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                        install_aur_packages "$aur_helper" "${aur_missing[@]}"
                    fi
                fi
            fi
            
            setup_services
            create_hardware_ghost
            ok "Installation complete!"
        fi
    fi
    
    echo ""
    echo "Next steps:"
    echo "  1. Run: cd $UKE_ROOT && ./scripts/install.sh"
    echo "  2. Log out and back in (or reboot)"
    echo "  3. Configure hardware: uke profile"
}

main "$@"
