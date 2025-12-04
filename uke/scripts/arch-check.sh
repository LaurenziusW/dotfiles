#!/usr/bin/env bash
# ==============================================================================
# UKE Arch Linux Package Checker & Installer v7.3
# ==============================================================================
# Interactive package installation with conflict handling
#
# Usage:
#   ./arch-check.sh              # Interactive mode (recommended)
#   ./arch-check.sh --check      # Check only, don't install
#   ./arch-check.sh --install    # Install all without prompts
#   ./arch-check.sh --minimal    # Install only core packages
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UKE_ROOT="${SCRIPT_DIR%/scripts}"

# Colors
RED=$'\e[31m' GREEN=$'\e[32m' YELLOW=$'\e[33m' BLUE=$'\e[34m'
CYAN=$'\e[36m' BOLD=$'\e[1m' DIM=$'\e[2m' RESET=$'\e[0m'

# [FIX] All logging to stderr so captured output isn't corrupted
ok()   { printf "%s✓%s %s\n" "$GREEN" "$RESET" "$*" >&2; }
fail() { printf "%s✗%s %s\n" "$RED" "$RESET" "$*" >&2; }
info() { printf "%s→%s %s\n" "$BLUE" "$RESET" "$*" >&2; }
warn() { printf "%s!%s %s\n" "$YELLOW" "$RESET" "$*" >&2; }

# ==============================================================================
# Package Groups - Each can be selected individually
# ==============================================================================

# Group 1: Core (REQUIRED - UKE won't work without these)
declare -A GROUP_CORE=(
    [name]="Core Dependencies"
    [required]=true
    [packages]="hyprland stow jq git wezterm"
)

# Group 2: Window Manager Ecosystem
declare -A GROUP_WM=(
    [name]="Window Manager Ecosystem"
    [required]=false
    [packages]="wofi waybar dunst hyprpaper hypridle hyprlock"
)

# Group 3: Clipboard & Screenshots
declare -A GROUP_UTILS=(
    [name]="Clipboard & Screenshots"
    [required]=false
    [packages]="wl-clipboard cliphist grim slurp zathura zathura-pdf-mupdf"
)

# Group 4: System Utilities
declare -A GROUP_SYSTEM=(
    [name]="System Utilities"
    [required]=false
    [packages]="pavucontrol network-manager-applet blueman thunar polkit-kde-agent"
)

# Group 5: Development Tools
declare -A GROUP_DEV=(
    [name]="Development Tools"
    [required]=false
    [packages]="neovim ripgrep fd eza bat htop tmux fzf zsh-autosuggestions zsh-syntax-highlighting"
)

# Group 6: YAML Processor (special handling for conflict)
declare -A GROUP_YAML=(
    [name]="YAML Processor (go-yq)"
    [required]=false
    [packages]="go-yq"
    [conflicts]="yq"
)

# Group 7: System Tools
declare -A GROUP_SYSADMIN=(
    [name]="System Admin Tools"
    [required]=false
    [packages]="reflector pacman-contrib"
)

# Group 8: Keyboard
declare -A GROUP_KEYBOARD=(
    [name]="Keyboard Remapping"
    [required]=false
    [packages]="keyd"
)

# Group 9: Fonts
declare -A GROUP_FONTS=(
    [name]="Fonts"
    [required]=false
    [packages]="ttf-jetbrains-mono-nerd noto-fonts-emoji"
)

# All groups in order
GROUPS=(GROUP_CORE GROUP_WM GROUP_UTILS GROUP_SYSTEM GROUP_DEV GROUP_YAML GROUP_SYSADMIN GROUP_KEYBOARD GROUP_FONTS)

# ==============================================================================
# Helper Functions
# ==============================================================================
check_package() {
    pacman -Qi "$1" &>/dev/null
}

get_missing_from_group() {
    local -n group=$1
    local packages="${group[packages]}"
    local missing=""
    
    for pkg in $packages; do
        if ! check_package "$pkg"; then
            missing="$missing $pkg"
        fi
    done
    
    echo "$missing"
}

count_missing() {
    local missing="$1"
    if [[ -z "$missing" ]]; then
        echo 0
    else
        echo "$missing" | wc -w
    fi
}

# ==============================================================================
# Check for Package Conflicts
# ==============================================================================
check_conflicts() {
    local pkg="$1"
    
    case "$pkg" in
        go-yq)
            # Check if old yq (python) is installed
            if check_package "yq"; then
                return 1  # Conflict exists
            fi
            ;;
    esac
    
    return 0  # No conflict
}

resolve_conflict() {
    local pkg="$1"
    
    case "$pkg" in
        go-yq)
            if check_package "yq"; then
                echo "" >&2
                warn "Conflict detected: 'yq' (Python) conflicts with 'go-yq' (Go)"
                echo "" >&2
                echo "  go-yq is the recommended version (newer, faster, actively maintained)" >&2
                echo "" >&2
                read -p "  Remove 'yq' and install 'go-yq'? [Y/n] " -r response
                if [[ "$response" =~ ^[Nn] ]]; then
                    warn "Skipping go-yq installation"
                    return 1
                else
                    info "Removing conflicting 'yq' package..."
                    sudo pacman -Rns --noconfirm yq 2>/dev/null || true
                    ok "Removed 'yq'"
                    return 0
                fi
            fi
            ;;
    esac
    
    return 0
}

# ==============================================================================
# Display Package Group Status
# ==============================================================================
display_group_status() {
    local -n group=$1
    local group_num=$2
    local name="${group[name]}"
    local packages="${group[packages]}"
    local required="${group[required]:-false}"
    
    local missing=$(get_missing_from_group "$1")
    local missing_count=$(count_missing "$missing")
    local total=$(echo "$packages" | wc -w)
    local installed=$((total - missing_count))
    
    # Status indicator
    local status_color="$GREEN"
    local status_icon="✓"
    if [[ $missing_count -gt 0 ]]; then
        if [[ "$required" == "true" ]]; then
            status_color="$RED"
            status_icon="✗"
        else
            status_color="$YELLOW"
            status_icon="○"
        fi
    fi
    
    # Required badge
    local badge=""
    [[ "$required" == "true" ]] && badge="${RED}[REQUIRED]${RESET} "
    
    printf "  %s[%d]%s %s%-25s%s %s%s%s (%d/%d installed)\n" \
        "$DIM" "$group_num" "$RESET" \
        "$badge" "$name" "$RESET" \
        "$status_color" "$status_icon" "$RESET" \
        "$installed" "$total" >&2
    
    # Show missing packages
    if [[ $missing_count -gt 0 ]]; then
        printf "      ${DIM}Missing:${RESET}%s\n" "$missing" >&2
    fi
}

# ==============================================================================
# Interactive Group Selection
# ==============================================================================
select_groups_interactive() {
    local selected=()
    
    echo "" >&2
    printf "%s╔══════════════════════════════════════════════════════════════╗%s\n" "$CYAN" "$RESET" >&2
    printf "%s║%s          UKE Package Group Selection                         %s║%s\n" "$CYAN" "$BOLD" "$CYAN" "$RESET" >&2
    printf "%s╚══════════════════════════════════════════════════════════════╝%s\n" "$CYAN" "$RESET" >&2
    echo "" >&2
    echo "  Select which package groups to install:" >&2
    echo "" >&2
    
    local i=1
    for group_name in "${GROUPS[@]}"; do
        display_group_status "$group_name" "$i"
        ((i++))
    done
    
    echo "" >&2
    echo "  ${BOLD}Options:${RESET}" >&2
    echo "    ${CYAN}a${RESET} = Install ALL groups" >&2
    echo "    ${CYAN}r${RESET} = Install REQUIRED only (minimal)" >&2
    echo "    ${CYAN}1,2,5${RESET} = Install specific groups (comma-separated)" >&2
    echo "    ${CYAN}q${RESET} = Quit without installing" >&2
    echo "" >&2
    
    read -p "  Your choice: " -r choice
    
    case "$choice" in
        a|A|all)
            # All groups
            for group_name in "${GROUPS[@]}"; do
                selected+=("$group_name")
            done
            ;;
        r|R|required)
            # Required only
            for group_name in "${GROUPS[@]}"; do
                local -n grp=$group_name
                if [[ "${grp[required]:-false}" == "true" ]]; then
                    selected+=("$group_name")
                fi
            done
            ;;
        q|Q|quit)
            echo "Cancelled." >&2
            exit 0
            ;;
        *)
            # Parse comma-separated numbers
            IFS=',' read -ra nums <<< "$choice"
            for num in "${nums[@]}"; do
                num=$(echo "$num" | tr -d ' ')
                if [[ "$num" =~ ^[0-9]+$ ]] && [[ $num -ge 1 ]] && [[ $num -le ${#GROUPS[@]} ]]; then
                    selected+=("${GROUPS[$((num-1))]}")
                fi
            done
            ;;
    esac
    
    # Always include required groups
    for group_name in "${GROUPS[@]}"; do
        local -n grp=$group_name
        if [[ "${grp[required]:-false}" == "true" ]]; then
            if [[ ! " ${selected[*]} " =~ " ${group_name} " ]]; then
                selected+=("$group_name")
                info "Auto-adding required group: ${grp[name]}"
            fi
        fi
    done
    
    echo "${selected[@]}"
}

# ==============================================================================
# Install Selected Groups
# ==============================================================================
install_selected_groups() {
    local groups=("$@")
    local all_packages=""
    local skipped=""
    
    info "Preparing installation..."
    
    for group_name in "${groups[@]}"; do
        local -n group=$group_name
        local missing=$(get_missing_from_group "$group_name")
        
        if [[ -n "$missing" ]]; then
            for pkg in $missing; do
                # Check for conflicts
                if ! check_conflicts "$pkg"; then
                    if resolve_conflict "$pkg"; then
                        all_packages="$all_packages $pkg"
                    else
                        skipped="$skipped $pkg"
                    fi
                else
                    all_packages="$all_packages $pkg"
                fi
            done
        fi
    done
    
    # Remove leading/trailing whitespace
    all_packages=$(echo "$all_packages" | xargs)
    
    if [[ -z "$all_packages" ]]; then
        ok "All selected packages are already installed!"
        return 0
    fi
    
    echo "" >&2
    info "Packages to install: $all_packages"
    
    if [[ -n "$skipped" ]]; then
        warn "Skipped due to conflicts:$skipped"
    fi
    
    echo "" >&2
    read -p "  Proceed with installation? [Y/n] " -r response
    if [[ "$response" =~ ^[Nn] ]]; then
        warn "Installation cancelled"
        return 1
    fi
    
    # Update system first
    info "Updating system..."
    sudo pacman -Syu --noconfirm
    
    # Install packages
    info "Installing packages..."
    # shellcheck disable=SC2086
    sudo pacman -S --needed --noconfirm $all_packages || {
        fail "Some packages failed to install"
        echo "" >&2
        echo "Try installing manually:" >&2
        echo "  sudo pacman -S $all_packages" >&2
        return 1
    }
    
    ok "Packages installed successfully!"
}

# ==============================================================================
# Setup Services
# ==============================================================================
setup_services() {
    info "Setting up services..."
    
    # keyd (keyboard remapping)
    if check_package "keyd"; then
        if ! systemctl is-enabled keyd &>/dev/null; then
            info "Enabling keyd service..."
            sudo systemctl enable keyd
            sudo systemctl start keyd
            ok "keyd service enabled"
        else
            ok "keyd already enabled"
        fi
    fi
    
    # NetworkManager
    if check_package "networkmanager"; then
        if ! systemctl is-enabled NetworkManager &>/dev/null; then
            info "Enabling NetworkManager..."
            sudo systemctl enable NetworkManager
            sudo systemctl start NetworkManager
            ok "NetworkManager enabled"
        fi
    fi
    
    # Bluetooth
    if check_package "bluez"; then
        if ! systemctl is-enabled bluetooth &>/dev/null; then
            info "Enabling Bluetooth..."
            sudo systemctl enable bluetooth
            sudo systemctl start bluetooth
            ok "Bluetooth enabled"
        fi
    fi
}

# ==============================================================================
# Create Placeholder Ghost File
# ==============================================================================
create_hardware_ghost() {
    local hypr_hardware="$HOME/.config/hypr/generated_hardware.conf"
    
    if [[ ! -f "$hypr_hardware" ]]; then
        mkdir -p "$(dirname "$hypr_hardware")"
        cat > "$hypr_hardware" << 'EOF'
# ==============================================================================
# PLACEHOLDER - Run 'uke profile' then 'uke apply' to generate real config
# ==============================================================================
# Default monitor (with scaling for small screens)
monitor=,preferred,auto,1

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
# Verify Sudo Access
# ==============================================================================
verify_sudo() {
    if ! sudo -v; then
        fail "sudo access required"
        exit 1
    fi
}

# ==============================================================================
# Quick Status Check
# ==============================================================================
quick_status() {
    echo "" >&2
    printf "%s╔══════════════════════════════════════╗%s\n" "$CYAN" "$RESET" >&2
    printf "%s║%s  UKE Package Status                  %s║%s\n" "$CYAN" "$BOLD" "$CYAN" "$RESET" >&2
    printf "%s╚══════════════════════════════════════╝%s\n" "$CYAN" "$RESET" >&2
    echo "" >&2
    
    local i=1
    for group_name in "${GROUPS[@]}"; do
        display_group_status "$group_name" "$i"
        ((i++))
    done
    
    echo "" >&2
}

# ==============================================================================
# Main
# ==============================================================================
main() {
    local mode="${1:-}"
    
    case "$mode" in
        --check|-c)
            quick_status
            ;;
        --install|-i)
            verify_sudo
            quick_status
            echo "" >&2
            info "Installing ALL packages..."
            local all_groups=("${GROUPS[@]}")
            install_selected_groups "${all_groups[@]}"
            setup_services
            create_hardware_ghost
            ;;
        --minimal|-m)
            verify_sudo
            quick_status
            echo "" >&2
            info "Installing REQUIRED packages only..."
            local required_groups=()
            for group_name in "${GROUPS[@]}"; do
                local -n grp=$group_name
                if [[ "${grp[required]:-false}" == "true" ]]; then
                    required_groups+=("$group_name")
                fi
            done
            install_selected_groups "${required_groups[@]}"
            setup_services
            create_hardware_ghost
            ;;
        --help|-h)
            echo "Usage: $0 [option]" >&2
            echo "" >&2
            echo "Options:" >&2
            echo "  (none)      Interactive mode - choose packages" >&2
            echo "  --check     Check status only, don't install" >&2
            echo "  --install   Install all packages" >&2
            echo "  --minimal   Install required packages only" >&2
            echo "  --help      Show this help" >&2
            ;;
        *)
            # Interactive mode
            verify_sudo
            selected=$(select_groups_interactive)
            
            if [[ -n "$selected" ]]; then
                # Convert string back to array
                read -ra selected_array <<< "$selected"
                install_selected_groups "${selected_array[@]}"
                setup_services
                create_hardware_ghost
            fi
            ;;
    esac
    
    echo "" >&2
    echo "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}" >&2
    echo "" >&2
    echo "Next steps:" >&2
    echo "  1. Run UKE installer: cd $UKE_ROOT && ./scripts/install.sh" >&2
    echo "  2. Configure hardware: uke profile" >&2
    echo "  3. Apply config: uke apply" >&2
    echo "  4. Generate WM config: uke gen" >&2
    echo "" >&2
    echo "If you have login issues:" >&2
    echo "  Create ~/.no-hyprland to disable auto-start" >&2
    echo "" >&2
}

main "$@"
