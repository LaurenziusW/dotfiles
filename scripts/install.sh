#!/usr/bin/env bash
# ==============================================================================
# UKE Installer
# ==============================================================================
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UKE_ROOT="${SCRIPT_DIR%/scripts}"
source "$UKE_ROOT/lib/core.sh"

# ------------------------------------------------------------------------------
# Pre-flight
# ------------------------------------------------------------------------------
check_deps() {
    local missing=()
    
    command -v git &>/dev/null || missing+=("git")
    command -v stow &>/dev/null || missing+=("stow")
    command -v yq &>/dev/null || missing+=("yq")
    command -v jq &>/dev/null || missing+=("jq")
    
    if is_macos; then
        command -v yabai &>/dev/null || missing+=("yabai")
        command -v skhd &>/dev/null || missing+=("skhd")
    fi
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing dependencies: ${missing[*]}"
        echo ""
        if is_macos; then
            echo "Install with: brew install ${missing[*]}"
        else
            echo "Install with your package manager"
        fi
        exit 1
    fi
    
    ok "All dependencies present"
}

# ------------------------------------------------------------------------------
# Backup
# ------------------------------------------------------------------------------
backup_existing() {
    local backup_dir="$HOME/.uke-backup-$(date +%Y%m%d-%H%M%S)"
    local backed_up=0
    
    for item in .config/skhd .config/yabai .config/hypr .wezterm.lua .tmux.conf .zshrc .config/nvim .config/karabiner; do
        if [[ -e "$HOME/$item" && ! -L "$HOME/$item" ]]; then
            mkdir -p "$backup_dir"
            cp -r "$HOME/$item" "$backup_dir/" 2>/dev/null && backed_up=$((backed_up + 1))
        fi
    done
    
    if [[ $backed_up -gt 0 ]]; then
        ok "Backed up $backed_up items to $backup_dir"
    fi
}

# ------------------------------------------------------------------------------
# Stow Packages
# ------------------------------------------------------------------------------
stow_packages() {
    log_info "Installing stow packages..."
    
    local packages=()
    
    # Platform-specific
    if is_macos; then
        packages+=(karabiner)
    else
        packages+=(keyd)
    fi
    
    # Shared
    packages+=(wezterm tmux zsh nvim)
    
    cd "$UKE_STOW"
    for pkg in "${packages[@]}"; do
        if [[ -d "$pkg" ]]; then
            stow -R "$pkg" -t "$HOME" 2>/dev/null && ok "Stowed: $pkg" || log_warn "Failed: $pkg"
        else
            log_warn "Package not found: $pkg"
        fi
    done
}

# ------------------------------------------------------------------------------
# Link Binaries
# ------------------------------------------------------------------------------
link_bins() {
    log_info "Linking binaries..."
    
    mkdir -p "$HOME/.local/bin"
    
    for bin in "$UKE_BIN"/*; do
        [[ -f "$bin" ]] || continue
        local name="$(basename "$bin")"
        ln -sf "$bin" "$HOME/.local/bin/$name"
        chmod +x "$bin"
    done
    
    ok "Linked binaries to ~/.local/bin"
}

# ------------------------------------------------------------------------------
# Link Generated Configs
# ------------------------------------------------------------------------------
link_gen() {
    log_info "Linking generated configs..."
    
    if is_macos; then
        mkdir -p "$HOME/.config/skhd" "$HOME/.config/yabai"
        [[ -f "$UKE_GEN/skhd/skhdrc" ]] && ln -sf "$UKE_GEN/skhd/skhdrc" "$HOME/.config/skhd/skhdrc"
        [[ -f "$UKE_GEN/yabai/yabairc" ]] && ln -sf "$UKE_GEN/yabai/yabairc" "$HOME/.config/yabai/yabairc"
        ok "Linked skhd and yabai configs"
    else
        mkdir -p "$HOME/.config/hypr"
        [[ -f "$UKE_GEN/hyprland/hyprland.conf" ]] && ln -sf "$UKE_GEN/hyprland/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
        ok "Linked hyprland config"
    fi
}

# ------------------------------------------------------------------------------
# Generate Configs
# ------------------------------------------------------------------------------
generate_configs() {
    log_info "Generating configs from registry..."
    if [[ -f "$UKE_LIB/gen.sh" ]]; then
        bash "$UKE_LIB/gen.sh" all
    else
        log_warn "gen.sh not found, skipping generation"
    fi
}

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------
main() {
    echo "UKE Installer v$UKE_VERSION"
    echo "=========================="
    echo ""
    
    case "${1:-}" in
        --check) check_deps; exit 0 ;;
        --bins)  link_bins; exit 0 ;;
        --stow)  stow_packages; exit 0 ;;
        --gen)   generate_configs; exit 0 ;;
        --help|-h)
            echo "Usage: $0 [option]"
            echo "  (no args)  Full install"
            echo "  --check    Check dependencies only"
            echo "  --stow     Stow packages only"
            echo "  --bins     Link binaries only"
            echo "  --gen      Generate configs only"
            exit 0
            ;;
    esac
    
    check_deps
    backup_existing
    generate_configs
    stow_packages
    link_bins
    link_gen
    
    echo ""
    ok "Installation complete!"
    echo ""
    echo "Next steps:"
    echo "  1. source ~/.zshrc"
    echo "  2. uke reload"
    echo ""
    echo "Edit config: uke edit"
    echo "Apply changes: uke gen && uke reload"
}

main "$@"
