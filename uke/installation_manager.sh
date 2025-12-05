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
        if [[ -e "$path" || -L "$path" ]]; then
            ((configs_found++))
            local is_uke=0
            
            if [[ -L "$path" ]]; then
                local target
                target=$(readlink "$path")
                local target_abs
                if [[ "$target" == /* ]]; then
                    target_abs="$target"
                else
                    # Resolve relative symlink
                    target_abs=$(
                        cd "$(dirname "$path")" 2>/dev/null || exit
                        cd "$(dirname "$target")" 2>/dev/null || exit
                        pwd -P
                    )/$(basename "$target")
                fi
                
                [[ "$target_abs" == *"$UKE_ROOT"* ]] && is_uke=1
            else
                # Regular file: check if it resides in UKE_ROOT (via directory symlink)
                local phys_dir
                phys_dir=$(cd "$(dirname "$path")" 2>/dev/null && pwd -P)
                [[ "$phys_dir" == *"$UKE_ROOT"* ]] && is_uke=1
            fi

            if [[ $is_uke -eq 1 ]]; then
                ok "${path/#$HOME/\~} → UKE Linked"
            else
                if [[ -L "$path" ]]; then
                    local target
                    target=$(readlink "$path")
                    warn "${path/#$HOME/\~} → Linked to $target (Conflict)"
                else
                    fail "${path/#$HOME/\~} → Regular file (Conflict)"
                fi
            fi
        fi
    done

    echo ""
    # We count conflicts (failures) specifically? 
    # The original script counted *any* existing file as 'configs_found' which prompted 'wipe'.
    # We should probably only suggest wipe if there are conflicts.
    # But for now, let's keep the logic simple: if things are linked, it's good.
    
    # Check if we have any FAIL/WARN
    # We'll rely on the visual output for the user.
    info "Status check complete."
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

    local failed=0

    run_stow() {
        local pkg="$1"
        info "Stowing $pkg..."
        cd "$UKE_ROOT/$pkg" || return 1
        
        # Run stow, capture output
        local output
        # We temporarily disable exit-on-error for the command substitution to capture the exit code
        set +e
        output=$(stow -v --restow -t "$HOME" . 2>&1)
        local stow_exit=$?
        set -e
        
        # Display output filtering out "LINK:" messages
        # We use 'grep' but ensure we don't fail if no lines match (grep returns 1 on no match)
        echo "$output" | grep -v "LINK:" || true
        
        if [[ $stow_exit -ne 0 ]]; then
            fail "Stow failed for $pkg"
            return 1
        fi
        ok "$pkg installed"
    }

    # Install Shared
    if ! run_stow "shared"; then failed=1; fi
    
    # Install Platform
    if ! run_stow "$PLATFORM_DIR"; then failed=1; fi

    # Platform Specific Setup
    if [[ "$OS" == "linux" ]]; then
        if [[ -f "$UKE_ROOT/arch/.local/bin/uke-keyd-setup" ]]; then
            "$UKE_ROOT/arch/.local/bin/uke-keyd-setup" || failed=1
        else
            warn "uke-keyd-setup not found."
        fi
    fi

    # Post-Install
    chmod +x "$HOME/.local/bin/uke-"* 2>/dev/null || true
    
    echo ""
    if [[ $failed -eq 0 ]]; then
        ok "Installation Complete!"
        info "Restart your shell or window manager to see changes."
    else
        fail "Installation completed with errors."
        exit 1
    fi
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