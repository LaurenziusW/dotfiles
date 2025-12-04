#!/usr/bin/env bash
# =============================================================================
# UKE v8 - System Detect & Setup (FIXED)
# Usage: ./uke-detect.sh [command]
# =============================================================================
set -eo pipefail

# Colors
if [[ -t 1 ]]; then
    C_RED=$'\e[31m' C_GREEN=$'\e[32m' C_YELLOW=$'\e[33m'
    C_BLUE=$'\e[34m' C_MAGENTA=$'\e[35m' C_CYAN=$'\e[36m'
    C_BOLD=$'\e[1m' C_DIM=$'\e[2m' C_RESET=$'\e[0m'
else
    C_RED='' C_GREEN='' C_YELLOW='' C_BLUE='' C_MAGENTA='' C_CYAN=''
    C_BOLD='' C_DIM='' C_RESET=''
fi

ok()      { printf "%s✓%s %s\n" "$C_GREEN" "$C_RESET" "$*"; }
fail()    { printf "%s✗%s %s\n" "$C_RED" "$C_RESET" "$*"; }
warn()    { printf "%s!%s %s\n" "$C_YELLOW" "$C_RESET" "$*"; }
info()    { printf "%s→%s %s\n" "$C_BLUE" "$C_RESET" "$*"; }
header()  { printf "\n%s=== %s ===%s\n" "$C_BOLD" "$*" "$C_RESET"; }
dim()     { printf "%s%s%s\n" "$C_DIM" "$*" "$C_RESET"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UKE_ROOT="$SCRIPT_DIR"
BACKUP_DIR="$HOME/.local/share/uke-backups/$(date +%Y%m%d-%H%M%S)"

# OS Detection
case "$(uname -s)" in
    Darwin) OS="macos" ;;
    Linux)  OS="linux" ;;
    *)      OS="unknown" ;;
esac

# Distro detection
DISTRO=""
if [[ "$OS" == "linux" ]]; then
    if [[ -f /etc/arch-release ]]; then DISTRO="arch"; fi
    if [[ -f /etc/debian_version ]]; then DISTRO="debian"; fi
fi

# =============================================================================
# Functions
# =============================================================================

detect_system() {
    header "System Information"
    echo "  OS:           $OS"
    [[ -n "$DISTRO" ]] && echo "  Distro:       $DISTRO"
    # FIXED: Use uname -n instead of hostname command which might be missing
    echo "  Hostname:     $(uname -n)"
    echo "  Kernel:       $(uname -r)"
    echo "  User:         ${USER:-$(whoami)}"
    echo "  Shell:        ${SHELL:-/bin/bash}"
}

detect_existing_configs() {
    header "Existing Configurations"
    local configs_found=0
    
    # List of files to check
    local check_list=(
        "$HOME/.zshrc"
        "$HOME/.config/nvim/init.lua"
        "$HOME/.config/tmux/tmux.conf"
        "$HOME/.config/wezterm/wezterm.lua"
        "$HOME/.config/hypr/hyprland.conf"
        "$HOME/.config/keyd/default.conf"
        "$HOME/.config/skhd/skhdrc"
        "$HOME/.config/yabai/yabairc"
    )

    for path in "${check_list[@]}"; do
        if [[ -e "$path" ]]; then
            ((configs_found++))
            if [[ -L "$path" ]]; then
                # Check if it points to UKE
                local target
                target=$(readlink -f "$path" 2>/dev/null || readlink "$path")
                if [[ "$target" == *"$UKE_ROOT"* ]]; then
                    ok "${path/$HOME/\~} → UKE managed"
                else
                    warn "${path/$HOME/\~} → Symlink to $target"
                fi
            else
                fail "${path/$HOME/\~} (Real file - Conflict!)"
            fi
        fi
    done

    if [[ $configs_found -eq 0 ]]; then
        info "No conflicting config files found."
    fi
}

do_backup() {
    header "Backing Up Configs"
    mkdir -p "$BACKUP_DIR"
    info "Backup location: $BACKUP_DIR"
    
    # We backup the whole folders if they exist to be safe
    local folders=(
        ".config/wezterm" ".config/tmux" ".config/nvim" 
        ".config/yabai" ".config/skhd" ".config/hypr" 
        ".config/waybar" ".config/keyd" ".config/zathura"
    )
    local files=(".zshrc" ".zprofile" ".tmux.conf" ".wezterm.lua")

    for item in "${folders[@]}" "${files[@]}"; do
        if [[ -e "$HOME/$item" ]] && [[ ! -L "$HOME/$item" ]]; then
            # Recreate parent dir structure in backup
            mkdir -p "$BACKUP_DIR/$(dirname "$item")"
            cp -r "$HOME/$item" "$BACKUP_DIR/$item"
            ok "Backed up: ~/$item"
        fi
    done
}

do_wipe() {
    header "Wipe & Clean Slate"
    echo "${C_RED}WARNING: This will remove configuration files from your home directory.${C_RESET}"
    echo "We will backup everything to: $BACKUP_DIR"
    echo ""
    read -p "Proceed with backup and wipe? [y/N] " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi

    do_backup

    header "Removing Configs"
    # Specific paths that cause Stow conflicts
    local to_remove=(
        "$HOME/.zshrc"
        "$HOME/.config/wezterm"
        "$HOME/.config/tmux"
        "$HOME/.config/nvim"
        "$HOME/.config/hypr"
        "$HOME/.config/waybar"
        "$HOME/.config/keyd"
        "$HOME/.config/zathura"
        "$HOME/.config/yabai"
        "$HOME/.config/skhd"
        "$HOME/.local/bin/uke-"*
    )

    for path in "${to_remove[@]}"; do
        # Use glob expansion in case of wildcards
        for p in $path; do
            if [[ -e "$p" || -L "$p" ]]; then
                rm -rf "$p"
                ok "Removed: $p"
            fi
        done
    done
    
    # Recreate empty config dirs for stow to populate if needed
    mkdir -p "$HOME/.config"
    
    echo ""
    ok "System is clean and ready for install."
}

do_install() {
    header "Installing UKE v8"
    
    if ! command -v stow &>/dev/null; then
        fail "Stow is not installed."
        exit 1
    fi

    # Install Shared
    info "Stowing shared..."
    cd "$UKE_ROOT/shared"
    # mkdirs ensures parent directories exist
    stow -v --adopt -t "$HOME" . 2>&1 | grep -v "LINK:" || true
    
    # Install Platform
    if [[ "$OS" == "macos" ]]; then
        info "Stowing mac..."
        cd "$UKE_ROOT/mac"
        stow -v --adopt -t "$HOME" . 2>&1 | grep -v "LINK:" || true
    elif [[ "$OS" == "linux" ]]; then
        info "Stowing arch..."
        cd "$UKE_ROOT/arch"
        stow -v --adopt -t "$HOME" . 2>&1 | grep -v "LINK:" || true
    fi

    # Post-install hooks
    chmod +x "$HOME/.local/bin/uke-"* 2>/dev/null || true
    
    echo ""
    ok "Installation Complete!"
}

# =============================================================================
# Main
# =============================================================================
case "${1:-status}" in
    status|detect)
        detect_system
        detect_existing_configs
        echo ""
        info "To install fresh (recommended): ./uke-detect.sh wipe && ./uke-detect.sh install"
        ;;
    wipe)
        detect_system
        do_wipe
        ;;
    install)
        do_install
        ;;
    *)
        echo "Usage: $0 {status|wipe|install}"
        exit 1
        ;;
esac