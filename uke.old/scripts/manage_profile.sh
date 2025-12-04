#!/usr/bin/env bash
# ==============================================================================
# UKE Profile Manager v7.0 - Hardware Configuration TUI
# ==============================================================================
# Interactive terminal UI for managing machine-specific hardware settings.
# Creates ~/.local/state/uke/machine.profile with hardware configuration.
#
# Usage: manage_profile.sh
#        uke profile
# ==============================================================================
set -euo pipefail

# [FIX] Bash Version Auto-Detection & Reload
# macOS ships with Bash 3.2. This script requires Bash 4.0+ (associative arrays).
if [ -z "${BASH_VERSINFO}" ] || [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
    if [ -x /opt/homebrew/bin/bash ]; then
        exec /opt/homebrew/bin/bash "$0" "$@"
    elif [ -x /usr/local/bin/bash ]; then
        exec /usr/local/bin/bash "$0" "$@"
    else
        echo "Error: Bash 4.0+ required (found ${BASH_VERSION})."
        echo "Please install bash via homebrew: brew install bash"
        exit 1
    fi
fi

# ==============================================================================
# Path Resolution
# ==============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export UKE_ROOT="${SCRIPT_DIR%/scripts}"

# Source core if available, otherwise define minimally
if [[ -f "$UKE_ROOT/lib/core.sh" ]]; then
    source "$UKE_ROOT/lib/core.sh"
else
    # Minimal definitions
    UKE_STATE="${XDG_STATE_HOME:-$HOME/.local/state}/uke"
    UKE_PROFILE_FILE="$UKE_STATE/machine.profile"
    is_macos() { [[ "$(uname -s)" == "Darwin" ]]; }
fi

# ==============================================================================
# Configuration
# ==============================================================================
PROFILE_DIR="${UKE_STATE:-$HOME/.local/state/uke}"
PROFILE_FILE="${PROFILE_DIR}/machine.profile"
APPLY_SCRIPT="${SCRIPT_DIR}/apply_profile.sh"

# ==============================================================================
# Option Arrays (for cycling)
# ==============================================================================
declare -a OS_OPTIONS=("arch" "macos")
declare -a FORM_FACTOR_OPTIONS=("desktop" "laptop_14" "laptop_10")
declare -a MONITORS_OPTIONS=("1" "2" "3")
declare -a GPU_OPTIONS=("integrated" "nvidia" "amd")
declare -a KEYBOARD_OPTIONS=("pc" "mac")

# ==============================================================================
# Current Values (loaded from profile or defaults)
# ==============================================================================
declare PROFILE_OS=""
declare PROFILE_FORM_FACTOR=""
declare PROFILE_MONITORS=""
declare PROFILE_GPU=""
declare PROFILE_KEYBOARD=""

# ==============================================================================
# Colors (use existing from core.sh or define new)
# ==============================================================================
if [[ -z "${C_RED:-}" ]]; then
    if [[ -t 1 ]]; then
        C_RED=$'\e[31m'
        C_GREEN=$'\e[32m'
        C_YELLOW=$'\e[33m'
        C_BLUE=$'\e[34m'
        C_MAGENTA=$'\e[35m'
        C_CYAN=$'\e[36m'
        C_BOLD=$'\e[1m'
        C_DIM=$'\e[2m'
        C_RESET=$'\e[0m'
    else
        C_RED='' C_GREEN='' C_YELLOW='' C_BLUE='' C_MAGENTA='' C_CYAN=''
        C_BOLD='' C_DIM='' C_RESET=''
    fi
fi

# ==============================================================================
# Utility Functions
# ==============================================================================
ok()   { printf "%s✓%s %s\n" "${C_GREEN}" "${C_RESET}" "$*"; }
warn() { printf "%s!%s %s\n" "${C_YELLOW}" "${C_RESET}" "$*"; }
fail() { printf "%s✗%s %s\n" "${C_RED}" "${C_RESET}" "$*"; }
info() { printf "%s→%s %s\n" "${C_BLUE}" "${C_RESET}" "$*"; }

clear_screen() {
    printf '\033[2J\033[H'
}

# ==============================================================================
# Hardware Detection
# ==============================================================================
detect_os() {
    case "$(uname -s)" in
        Darwin) echo "macos" ;;
        Linux)  echo "arch" ;;
        *)      echo "arch" ;;
    esac
}

detect_form_factor() {
    if [[ "$(uname -s)" == "Darwin" ]]; then
        if system_profiler SPDisplaysDataType 2>/dev/null | grep -q "Built-in"; then
            echo "laptop_14"
        else
            echo "desktop"
        fi
    else
        # Linux: check for laptop battery
        if [[ -d /sys/class/power_supply/BAT0 ]] || [[ -d /sys/class/power_supply/BAT1 ]]; then
            echo "laptop_14"
        else
            echo "desktop"
        fi
    fi
}

detect_gpu() {
    if [[ "$(uname -s)" == "Darwin" ]]; then
        echo "integrated"
    elif command -v lspci &>/dev/null; then
        if lspci 2>/dev/null | grep -qi nvidia; then
            echo "nvidia"
        elif lspci 2>/dev/null | grep -qi "amd.*radeon\|radeon.*amd"; then
            echo "amd"
        else
            echo "integrated"
        fi
    else
        echo "integrated"
    fi
}

detect_monitors() {
    if [[ "$(uname -s)" == "Darwin" ]]; then
        local count
        count=$(system_profiler SPDisplaysDataType 2>/dev/null | grep -c "Resolution:" || echo "1")
        echo "$count"
    elif command -v hyprctl &>/dev/null && [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
        hyprctl monitors -j 2>/dev/null | jq 'length' 2>/dev/null || echo "1"
    elif command -v xrandr &>/dev/null; then
        xrandr --query 2>/dev/null | grep -c " connected" || echo "1"
    else
        echo "1"
    fi
}

# ==============================================================================
# Profile Management
# ==============================================================================
init_defaults() {
    PROFILE_OS="$(detect_os)"
    PROFILE_FORM_FACTOR="$(detect_form_factor)"
    PROFILE_MONITORS="$(detect_monitors)"
    PROFILE_GPU="$(detect_gpu)"
    
    # Keyboard defaults based on OS
    if [[ "${PROFILE_OS}" == "macos" ]]; then
        PROFILE_KEYBOARD="mac"
    else
        PROFILE_KEYBOARD="pc"
    fi
}

load_profile() {
    # Ensure directory exists
    mkdir -p "${PROFILE_DIR}"
    
    if [[ -f "${PROFILE_FILE}" ]]; then
        # Source existing profile
        # shellcheck source=/dev/null
        source "${PROFILE_FILE}"
        
        # Map to local variables
        PROFILE_OS="${UKE_OS:-$(detect_os)}"
        PROFILE_FORM_FACTOR="${UKE_FORM_FACTOR:-desktop}"
        PROFILE_MONITORS="${UKE_MONITORS:-1}"
        PROFILE_GPU="${UKE_GPU:-integrated}"
        PROFILE_KEYBOARD="${UKE_KEYBOARD:-pc}"
    else
        # First run - initialize with auto-detected defaults
        init_defaults
        save_profile
        ok "Initialized new profile with auto-detected settings"
        sleep 1
    fi
}

save_profile() {
    mkdir -p "${PROFILE_DIR}"
    
    # Use temp file for atomic write
    local temp_file
    temp_file=$(mktemp)
    
    cat > "${temp_file}" << EOF
# ==============================================================================
# UKE Machine Profile v7.0
# ==============================================================================
# Generated by: uke profile (manage_profile.sh)
# Last updated: $(date -Iseconds)
#
# This file defines hardware-specific settings for this machine.
# It is NOT version controlled - each machine has its own profile.
#
# To regenerate hardware configs: uke apply
# ==============================================================================

export UKE_OS="${PROFILE_OS}"
export UKE_FORM_FACTOR="${PROFILE_FORM_FACTOR}"
export UKE_MONITORS="${PROFILE_MONITORS}"
export UKE_GPU="${PROFILE_GPU}"
export UKE_KEYBOARD="${PROFILE_KEYBOARD}"
EOF
    
    mv "${temp_file}" "${PROFILE_FILE}"
    chmod 600 "${PROFILE_FILE}"
}

# ==============================================================================
# Option Cycling
# ==============================================================================
get_index() {
    local value="$1"
    shift
    local -a options=("$@")
    local i
    
    for i in "${!options[@]}"; do
        if [[ "${options[$i]}" == "${value}" ]]; then
            echo "$i"
            return 0
        fi
    done
    echo "0"
}

cycle_next() {
    local value="$1"
    shift
    local -a options=("$@")
    local idx
    
    idx=$(get_index "${value}" "${options[@]}")
    local next_idx=$(( (idx + 1) % ${#options[@]} ))
    echo "${options[$next_idx]}"
}

# ==============================================================================
# Display Functions
# ==============================================================================
print_header() {
    printf "%s╔══════════════════════════════════════════════════════════════╗%s\n" "${C_CYAN}" "${C_RESET}"
    printf "%s║%s       UKE Profile Manager v7.0 - Hardware Config            %s║%s\n" "${C_CYAN}" "${C_BOLD}" "${C_CYAN}" "${C_RESET}"
    printf "%s╚══════════════════════════════════════════════════════════════╝%s\n" "${C_CYAN}" "${C_RESET}"
    echo ""
}

print_value() {
    local label="$1"
    local value="$2"
    local key="$3"
    local -a options=("${@:4}")
    
    # Format options string
    local options_str=""
    local opt
    for opt in "${options[@]}"; do
        if [[ "${opt}" == "${value}" ]]; then
            options_str+="${C_GREEN}${C_BOLD}${opt}${C_RESET} "
        else
            options_str+="${C_DIM}${opt}${C_RESET} "
        fi
    done
    
    printf "  %s[%s]%s %-15s %s\n" "${C_YELLOW}" "${key}" "${C_RESET}" "${label}:" "${options_str}"
}

print_dashboard() {
    clear_screen
    print_header
    
    printf "%sCurrent Configuration:%s\n\n" "${C_BOLD}" "${C_RESET}"
    
    print_value "OS" "${PROFILE_OS}" "1" "${OS_OPTIONS[@]}"
    print_value "Form Factor" "${PROFILE_FORM_FACTOR}" "2" "${FORM_FACTOR_OPTIONS[@]}"
    print_value "Monitors" "${PROFILE_MONITORS}" "3" "${MONITORS_OPTIONS[@]}"
    print_value "GPU" "${PROFILE_GPU}" "4" "${GPU_OPTIONS[@]}"
    print_value "Keyboard" "${PROFILE_KEYBOARD}" "5" "${KEYBOARD_OPTIONS[@]}"
    
    echo ""
    printf "%s────────────────────────────────────────────────────────────────%s\n" "${C_DIM}" "${C_RESET}"
    echo ""
    printf "  %s[1-5]%s Cycle option   %s[s]%s Save & Apply   %s[r]%s Auto-detect   %s[q]%s Quit\n" \
        "${C_YELLOW}" "${C_RESET}" \
        "${C_GREEN}" "${C_RESET}" \
        "${C_BLUE}" "${C_RESET}" \
        "${C_RED}" "${C_RESET}"
    echo ""
    
    # Show profile path
    printf "%s  Profile: %s%s\n" "${C_DIM}" "${PROFILE_FILE}" "${C_RESET}"
    echo ""
}

# ==============================================================================
# Actions
# ==============================================================================
apply_changes() {
    save_profile
    ok "Profile saved to ${PROFILE_FILE}"
    
    if [[ -x "${APPLY_SCRIPT}" ]]; then
        echo ""
        info "Generating hardware-specific configs..."
        echo ""
        if bash "${APPLY_SCRIPT}"; then
            ok "Hardware configs generated!"
            echo ""
            info "Next: Run 'uke gen && uke reload' to apply all changes"
        else
            fail "Config generation failed!"
        fi
    else
        warn "apply_profile.sh not found at: ${APPLY_SCRIPT}"
        info "Run 'uke apply' manually to generate hardware configs"
    fi
    
    echo ""
    printf "Press any key to continue..."
    read -r -n1 -s
}

reset_to_defaults() {
    info "Auto-detecting hardware..."
    init_defaults
    ok "Reset to auto-detected values"
    sleep 1
}

# ==============================================================================
# Main Loop
# ==============================================================================
main() {
    load_profile
    
    local running=true
    while ${running}; do
        print_dashboard
        
        printf "  Choice: "
        read -r -n1 choice
        echo ""
        
        case "${choice}" in
            1) PROFILE_OS=$(cycle_next "${PROFILE_OS}" "${OS_OPTIONS[@]}") ;;
            2) PROFILE_FORM_FACTOR=$(cycle_next "${PROFILE_FORM_FACTOR}" "${FORM_FACTOR_OPTIONS[@]}") ;;
            3) PROFILE_MONITORS=$(cycle_next "${PROFILE_MONITORS}" "${MONITORS_OPTIONS[@]}") ;;
            4) PROFILE_GPU=$(cycle_next "${PROFILE_GPU}" "${GPU_OPTIONS[@]}") ;;
            5) PROFILE_KEYBOARD=$(cycle_next "${PROFILE_KEYBOARD}" "${KEYBOARD_OPTIONS[@]}") ;;
            s|S) apply_changes ;;
            r|R) reset_to_defaults ;;
            q|Q) running=false ;;
            *) ;;
        esac
    done
    
    clear_screen
    info "Exiting UKE Profile Manager"
}

# Allow running with --auto flag for non-interactive setup
if [[ "${1:-}" == "--auto" ]]; then
    load_profile
    if [[ ! -f "${PROFILE_FILE}" ]]; then
        init_defaults
        save_profile
        ok "Auto-initialized profile: ${PROFILE_FILE}"
    else
        ok "Profile already exists: ${PROFILE_FILE}"
    fi
    exit 0
fi

main "$@"
