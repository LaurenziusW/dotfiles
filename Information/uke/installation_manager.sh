#!/usr/bin/env bash
# =============================================================================
# UKE v8 - Installation Manager
# Single entry point for System Status, Backup, Wipe, and Installation.
# =============================================================================
# Usage:
#   ./installation-manager.sh status   -> Check system health & conflicts
#   ./installation-manager.sh wipe     -> Backup & Remove existing configs
#   ./installation-manager.sh install  -> Symlink UKE configs via Stow
#   ./installation-manager.sh backup   -> Just backup, don't delete
# =============================================================================
set -eo pipefail

# Colors
if [[ -t 1 ]]; then
    C_RED=$'\e[31m' C_GREEN=$'\e[32m' C_YELLOW=$'\e[33m'
    C_BLUE=$'\e[34m' C_BOLD=$'\e[1m' C_RESET=$'\e[0m'
else
    C_RED='' C_GREEN='' C_YELLOW='' C_BLUE='' C_BOLD='' C_RESET=''
fi

ok()      { printf "%s✓%s %s\n" "$C_GREEN" "$C_RESET" "$*"; }
fail()    { printf "%s✗%s %s\n" "$C_RED" "$C_RESET" "$*"; }
warn()    { printf "%s!%s %s\n" "$C_YELLOW" "$C_RESET" "$*"; }
info()    { printf "%s→%s %s\n" "$C_BLUE" "$C_RESET" "$*"; }
header()  { printf "\n%s=== %s ===%s\n" "$C_BOLD" "$*" "$C_RESET"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UKE_ROOT="$SCRIPT_DIR"
BACKUP_DIR="$HOME/.local/share/uke-backups/$(date +%Y%m%d-%H%M%S)"

# OS Detection
case "$(uname -s)" in
    Darwin) OS="macos"; PLATFORM_DIR="mac" ;;
    Linux)  OS="linux"; PLATFORM_DIR="arch" ;;
    *)      OS="unknown"; echo "Unsupported OS"; exit 1 ;;
esac

# =============================================================================
# 1. STATUS / DETECT
# =============================================================================
detect_system() {
    header "System Status ($OS)"
    echo "  Hostname:     $(uname -n)"
    echo "  Kernel:       $(uname -r)"
    echo "  Shell:        ${SHELL:-/bin/bash}"
    echo ""

    # Check Tools
    local missing=0
    if [[ "$OS" == "macos" ]]; then
        for tool in stow yabai skhd jq; do
            if command -v "$tool" &>/dev/null; then ok "$tool installed"; else fail "$tool missing"; ((missing++)); fi
        done
    else
        for tool in stow hyprctl waybar keyd jq; do
            if command -v "$tool" &>/dev/null; then ok "$tool installed"; else fail "$tool missing"; ((missing++)); fi
        done
    fi

    # Check Conflicts
    header "Configuration Check"
    local configs_found=0
    
    # Files to check for conflicts
    local check_list=(
        "$HOME/.zshrc" "$HOME/.zprofile"
        "$HOME/.config/nvim/init.lua"
        "$HOME/.config/tmux/tmux.conf"
        "$HOME/.config/wezterm/wezterm.lua"
    )
    [[ "$OS" == "macos" ]] && check_list+=("$HOME/.config/skhd/skhdrc" "$HOME/.config/yabai/yabairc")
    [[ "$OS" == "linux" ]] && check_list+=("$HOME/.config/hypr/hyprland.conf" "$HOME/.config/waybar/config" "$HOME/.config/keyd/default.conf")

    for path in "${check_list[@]}"; do
        if [[ -e "$path" ]]; then
            ((configs_found++))
            if [[ -L "$path" ]]; then
                local target
                target=$(readlink -f "$path" 2>/dev/null || readlink "$path")
                if [[ "$target" == *"$UKE_ROOT"* ]]; then
                    ok "${path/#$HOME/\~} → UKE Linked"
                else
                    warn "${path/#$HOME/\~} → Linked to $target (Conflict)"
                fi
            else
                fail "${path/#$HOME/\~} → Regular file (Conflict)"
            fi
        fi
    done

    echo ""
    if [[ $configs_found -gt 0 ]]; then
        info "Found existing configs. Run './installation-manager.sh wipe' before installing."
    else
        info "Clean slate detected. Ready to install."
    fi
}

# =============================================================================
# 2. BACKUP & WIPE
# =============================================================================
do_backup() {
    header "Backing Up"
    mkdir -p "$BACKUP_DIR"
    info "Destination: $BACKUP_DIR"
    
    local items=(
        ".zshrc" ".zprofile" ".tmux.conf" ".wezterm.lua"
        ".config/nvim" ".config/wezterm" ".config/tmux"
        ".config/yabai" ".config/skhd" 
        ".config/hypr" ".config/waybar" ".config/keyd" ".config/zathura"
        ".local/bin/uke-"*
    )

    for item in "${items[@]}"; do
        # Handle wildcards by expanding
        for p in $HOME/$item; do
            if [[ -e "$p" || -L "$p" ]]; then
                # Recreate directory structure
                local rel_path="${p#$HOME/}"
                mkdir -p "$BACKUP_DIR/$(dirname "$rel_path")"
                cp -R -L "$p" "$BACKUP_DIR/$rel_path" 2>/dev/null || true
                ok "Backed up: ~/$rel_path"
            fi
        done
    done
}

do_wipe() {
    header "Wipe System Configs"
    warn "This will DELETE your current configs in ~/"
    warn "A backup will be created at: $BACKUP_DIR"
    echo ""
    read -p "Are you sure? [y/N] " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then echo "Aborted."; exit 0; fi

    do_backup

    header "Removing Files"
    local items=(
        ".zshrc" ".zprofile" ".tmux.conf" ".wezterm.lua"
        ".config/nvim" ".config/wezterm" ".config/tmux"
        ".config/yabai" ".config/skhd" 
        ".config/hypr" ".config/waybar" ".config/keyd" ".config/zathura"
        ".local/bin/uke-"*
    )

    for item in "${items[@]}"; do
        for p in $HOME/$item; do
            if [[ -e "$p" || -L "$p" ]]; then
                rm -rf "$p"
                ok "Removed: ~/${p#$HOME/}"
            fi
        done
    done
    
    # Ensure config dir exists for Stow
    mkdir -p "$HOME/.config"
    echo ""
    ok "System is clean. Run './installation-manager.sh install' next."
}

# =============================================================================
# 3. INSTALL
# =============================================================================
do_install() {
    header "Installing UKE v8"
    
    if ! command -v stow &>/dev/null; then
        fail "GNU Stow not found. Install it first."
        exit 1
    fi

    # Install Shared
    info "Stowing shared..."
    cd "$UKE_ROOT/shared"
    stow -v --restow -t "$HOME" . 2>&1 | grep -v "LINK:" || true
    
    # Install Platform
    info "Stowing $PLATFORM_DIR..."
    cd "$UKE_ROOT/$PLATFORM_DIR"
    stow -v --restow -t "$HOME" . 2>&1 | grep -v "LINK:" || true

    # Post-Install
    chmod +x "$HOME/.local/bin/uke-"* 2>/dev/null || true
    
    echo ""
    ok "Installation Complete!"
    info "Restart your shell or window manager to see changes."
}

# =============================================================================
# MAIN
# =============================================================================
case "${1:-status}" in
    status|check) detect_system ;;
    wipe)         do_wipe ;;
    install)      do_install ;;
    backup)       do_backup ;;
    *)
        echo "Usage: $0 {status|wipe|install|backup}"
        exit 1
        ;;
esac