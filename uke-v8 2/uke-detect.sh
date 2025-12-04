#!/usr/bin/env bash
# =============================================================================
# UKE v8 - System Detect & Setup
# Detects system configuration, finds existing configs, and manages installation
# Usage: ./uke-detect.sh [command]
#   Commands: detect, install, wipe, backup, status
# =============================================================================
set -eo pipefail

# =============================================================================
# Colors & Formatting
# =============================================================================
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

# =============================================================================
# Script Setup
# =============================================================================
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
    if [[ -f /etc/arch-release ]]; then
        DISTRO="arch"
    elif [[ -f /etc/debian_version ]]; then
        DISTRO="debian"
    elif [[ -f /etc/fedora-release ]]; then
        DISTRO="fedora"
    fi
fi

# =============================================================================
# Detection Functions
# =============================================================================

detect_system() {
    header "System Information"
    
    echo "  OS:           $OS"
    [[ -n "$DISTRO" ]] && echo "  Distro:       $DISTRO"
    echo "  Hostname:     $(hostname)"
    echo "  Kernel:       $(uname -r)"
    echo "  Architecture: $(uname -m)"
    echo "  User:         ${USER:-$(whoami)}"
    echo "  Home:         ${HOME:-~}"
    echo "  Shell:        ${SHELL:-/bin/bash}"
}

detect_window_managers() {
    header "Window Managers"
    
    # macOS
    if [[ "$OS" == "macos" ]]; then
        # Yabai
        if command -v yabai &>/dev/null; then
            if pgrep -q yabai; then
                ok "yabai installed and running"
                dim "    Version: $(yabai --version 2>/dev/null || echo 'unknown')"
                dim "    Config: $(yabai -m config status_bar 2>/dev/null && echo 'loaded' || echo 'not loaded')"
            else
                warn "yabai installed but not running"
            fi
        else
            info "yabai not installed"
        fi
        
        # skhd
        if command -v skhd &>/dev/null; then
            if pgrep -q skhd; then
                ok "skhd installed and running"
            else
                warn "skhd installed but not running"
            fi
        else
            info "skhd not installed"
        fi
        
        # Other macOS WMs
        for wm in amethyst rectangle magnet spectacle; do
            if [[ -d "/Applications/${wm^}.app" ]] || [[ -d "$HOME/Applications/${wm^}.app" ]]; then
                warn "${wm^} detected (may conflict with yabai)"
            fi
        done
    fi
    
    # Linux
    if [[ "$OS" == "linux" ]]; then
        # Hyprland
        if command -v hyprctl &>/dev/null; then
            if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
                ok "Hyprland installed and running"
                dim "    Version: $(hyprctl version 2>/dev/null | head -1 || echo 'unknown')"
            else
                warn "Hyprland installed but not in session"
            fi
        else
            info "Hyprland not installed"
        fi
        
        # i3
        if command -v i3 &>/dev/null; then
            if pgrep -x i3 &>/dev/null; then
                ok "i3 installed and running"
            else
                warn "i3 installed but not running"
            fi
        fi
        
        # Sway
        if command -v sway &>/dev/null; then
            if [[ -n "${SWAYSOCK:-}" ]]; then
                ok "Sway installed and running"
            else
                warn "Sway installed but not running"
            fi
        fi
        
        # Check display server
        if [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
            info "Display server: Wayland"
        elif [[ -n "${DISPLAY:-}" ]]; then
            info "Display server: X11"
        else
            info "Display server: None detected"
        fi
    fi
}

detect_terminals() {
    header "Terminal Emulators"
    
    for term in wezterm alacritty kitty iterm2 terminal hyper; do
        if command -v "$term" &>/dev/null; then
            ok "$term installed"
        elif [[ "$OS" == "macos" ]]; then
            # Check macOS apps
            local app_name
            case "$term" in
                wezterm) app_name="WezTerm" ;;
                alacritty) app_name="Alacritty" ;;
                kitty) app_name="kitty" ;;
                iterm2) app_name="iTerm" ;;
                terminal) app_name="Terminal" ;;
                hyper) app_name="Hyper" ;;
            esac
            if [[ -d "/Applications/${app_name}.app" ]] || [[ -d "$HOME/Applications/${app_name}.app" ]]; then
                ok "$term installed (app)"
            fi
        fi
    done
}

detect_shells() {
    header "Shells"
    
    echo "  Current: $SHELL"
    echo "  Available:"
    
    for shell in bash zsh fish; do
        if command -v "$shell" &>/dev/null; then
            local version
            version=$("$shell" --version 2>/dev/null | head -1 || echo '')
            ok "  $shell: $version"
        fi
    done
}

detect_existing_configs() {
    header "Existing Configurations"
    
    local configs_found=0
    
    # Define config locations to check
    declare -A config_files=(
        # WezTerm
        ["wezterm"]="$HOME/.config/wezterm/wezterm.lua"
        ["wezterm-alt"]="$HOME/.wezterm.lua"
        
        # Tmux
        ["tmux"]="$HOME/.config/tmux/tmux.conf"
        ["tmux-alt"]="$HOME/.tmux.conf"
        
        # Zsh
        ["zshrc"]="$HOME/.zshrc"
        ["zprofile"]="$HOME/.zprofile"
        
        # Nvim
        ["nvim"]="$HOME/.config/nvim/init.lua"
        ["nvim-vim"]="$HOME/.config/nvim/init.vim"
        
        # macOS
        ["yabai"]="$HOME/.config/yabai/yabairc"
        ["yabai-alt"]="$HOME/.yabairc"
        ["skhd"]="$HOME/.config/skhd/skhdrc"
        ["skhd-alt"]="$HOME/.skhdrc"
        
        # Linux
        ["hyprland"]="$HOME/.config/hypr/hyprland.conf"
        ["waybar"]="$HOME/.config/waybar/config"
        ["keyd"]="$HOME/.config/keyd/default.conf"
        ["keyd-system"]="/etc/keyd/default.conf"
        
        # Others
        ["zathura"]="$HOME/.config/zathura/zathurarc"
        ["starship"]="$HOME/.config/starship.toml"
        ["alacritty"]="$HOME/.config/alacritty/alacritty.yml"
        ["kitty"]="$HOME/.config/kitty/kitty.conf"
    )
    
    for name in "${!config_files[@]}"; do
        local path="${config_files[$name]}"
        if [[ -e "$path" ]]; then
            ((configs_found++))
            if [[ -L "$path" ]]; then
                local target
                target=$(readlink -f "$path" 2>/dev/null || readlink "$path")
                if [[ "$target" == *"uke"* ]]; then
                    ok "$name: $path → UKE managed"
                else
                    warn "$name: $path → symlink to $target"
                fi
            else
                warn "$name: $path (standalone file)"
            fi
        fi
    done
    
    if [[ $configs_found -eq 0 ]]; then
        info "No existing configurations found"
    else
        echo ""
        dim "Found $configs_found configuration file(s)"
    fi
}

detect_dependencies() {
    header "Dependencies"
    
    # Required
    echo "${C_BOLD}Required:${C_RESET}"
    for cmd in bash stow; do
        if command -v "$cmd" &>/dev/null; then
            ok "  $cmd"
        else
            fail "  $cmd (MISSING)"
        fi
    done
    
    # Recommended
    echo ""
    echo "${C_BOLD}Recommended:${C_RESET}"
    for cmd in jq git zsh nvim tmux; do
        if command -v "$cmd" &>/dev/null; then
            ok "  $cmd"
        else
            warn "  $cmd (not installed)"
        fi
    done
    
    # Platform-specific
    echo ""
    echo "${C_BOLD}Platform ($OS):${C_RESET}"
    
    if [[ "$OS" == "macos" ]]; then
        for cmd in yabai skhd brew; do
            if command -v "$cmd" &>/dev/null; then
                ok "  $cmd"
            else
                warn "  $cmd (not installed)"
            fi
        done
    else
        for cmd in hyprctl waybar wofi keyd; do
            if command -v "$cmd" &>/dev/null; then
                ok "  $cmd"
            else
                warn "  $cmd (not installed)"
            fi
        done
    fi
}

detect_services() {
    header "Services"
    
    if [[ "$OS" == "macos" ]]; then
        # Check launchd services
        for service in yabai skhd; do
            if launchctl list | grep -q "$service" 2>/dev/null; then
                ok "$service service registered"
            else
                info "$service service not registered"
            fi
        done
    else
        # Check systemd services
        echo "${C_BOLD}System services:${C_RESET}"
        for service in keyd NetworkManager bluetooth cups; do
            if systemctl is-active "$service" &>/dev/null; then
                ok "  $service"
            elif systemctl is-enabled "$service" &>/dev/null; then
                warn "  $service (enabled but not running)"
            else
                dim "  $service (not enabled)"
            fi
        done
        
        echo ""
        echo "${C_BOLD}User services:${C_RESET}"
        for service in pipewire pipewire-pulse wireplumber; do
            if systemctl --user is-active "$service" &>/dev/null; then
                ok "  $service"
            else
                dim "  $service (not running)"
            fi
        done
    fi
}

# =============================================================================
# Action Functions
# =============================================================================

do_backup() {
    header "Backing Up Existing Configs"
    
    mkdir -p "$BACKUP_DIR"
    info "Backup directory: $BACKUP_DIR"
    
    local backed_up=0
    
    # Configs to backup
    local configs=(
        "$HOME/.config/wezterm"
        "$HOME/.config/tmux"
        "$HOME/.config/nvim"
        "$HOME/.config/yabai"
        "$HOME/.config/skhd"
        "$HOME/.config/hypr"
        "$HOME/.config/waybar"
        "$HOME/.config/keyd"
        "$HOME/.config/zathura"
        "$HOME/.zshrc"
        "$HOME/.zprofile"
        "$HOME/.tmux.conf"
        "$HOME/.wezterm.lua"
    )
    
    for config in "${configs[@]}"; do
        if [[ -e "$config" ]] && [[ ! -L "$config" ]]; then
            local name
            name=$(basename "$config")
            cp -r "$config" "$BACKUP_DIR/$name"
            ok "Backed up: $name"
            ((backed_up++))
        fi
    done
    
    if [[ $backed_up -eq 0 ]]; then
        info "Nothing to backup (no standalone configs found)"
        rmdir "$BACKUP_DIR" 2>/dev/null || true
    else
        echo ""
        ok "Backed up $backed_up item(s) to $BACKUP_DIR"
    fi
}

do_wipe() {
    header "Wipe Existing Configs"
    
    warn "This will remove existing configuration files!"
    echo ""
    echo "The following will be removed:"
    
    local to_remove=()
    
    # Configs to potentially remove
    local configs=(
        "$HOME/.config/wezterm"
        "$HOME/.config/tmux"
        "$HOME/.config/nvim"
        "$HOME/.config/yabai"
        "$HOME/.config/skhd"
        "$HOME/.config/hypr"
        "$HOME/.config/waybar"
        "$HOME/.config/keyd"
        "$HOME/.config/zathura"
        "$HOME/.zshrc"
        "$HOME/.zprofile"
        "$HOME/.tmux.conf"
        "$HOME/.wezterm.lua"
        "$HOME/.local/bin/uke-"*
    )
    
    for config in "${configs[@]}"; do
        # Handle glob expansion
        for expanded in $config; do
            if [[ -e "$expanded" ]]; then
                echo "  - $expanded"
                to_remove+=("$expanded")
            fi
        done
    done
    
    if [[ ${#to_remove[@]} -eq 0 ]]; then
        info "Nothing to remove"
        return 0
    fi
    
    echo ""
    read -p "Create backup first? [Y/n] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        do_backup
    fi
    
    echo ""
    read -p "Proceed with removal? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        for item in "${to_remove[@]}"; do
            rm -rf "$item"
            ok "Removed: $item"
        done
        echo ""
        ok "Wipe complete"
    else
        info "Cancelled"
    fi
}

do_install() {
    header "Install UKE v8"
    
    # Check for stow
    if ! command -v stow &>/dev/null; then
        fail "GNU Stow is required but not installed"
        echo ""
        if [[ "$OS" == "macos" ]]; then
            echo "Install with: brew install stow"
        else
            echo "Install with: sudo pacman -S stow"
        fi
        exit 1
    fi
    
    # Check for existing configs
    local has_conflicts=false
    local conflict_files=()
    
    # Check shared configs
    for file in .zshrc .config/wezterm/wezterm.lua .config/tmux/tmux.conf .config/nvim/init.lua; do
        local target="$HOME/$file"
        if [[ -e "$target" ]] && [[ ! -L "$target" ]]; then
            has_conflicts=true
            conflict_files+=("$target")
        fi
    done
    
    # Check platform configs
    if [[ "$OS" == "macos" ]]; then
        for file in .config/yabai/yabairc .config/skhd/skhdrc; do
            local target="$HOME/$file"
            if [[ -e "$target" ]] && [[ ! -L "$target" ]]; then
                has_conflicts=true
                conflict_files+=("$target")
            fi
        done
    else
        for file in .config/hypr/hyprland.conf .config/waybar/config; do
            local target="$HOME/$file"
            if [[ -e "$target" ]] && [[ ! -L "$target" ]]; then
                has_conflicts=true
                conflict_files+=("$target")
            fi
        done
    fi
    
    if $has_conflicts; then
        warn "Existing configs found that will conflict:"
        for f in "${conflict_files[@]}"; do
            echo "  - $f"
        done
        echo ""
        read -p "Backup and remove conflicting files? [Y/n] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            do_backup
            for f in "${conflict_files[@]}"; do
                rm -rf "$f"
                info "Removed: $f"
            done
        else
            fail "Cannot install with existing configs. Run with 'wipe' first."
            exit 1
        fi
    fi
    
    # Install shared configs
    info "Installing shared configs..."
    cd "$UKE_ROOT/shared"
    stow -t "$HOME" . 2>&1 | grep -v "^LINK:" || true
    ok "Shared configs installed"
    
    # Install platform configs
    if [[ "$OS" == "macos" ]]; then
        info "Installing macOS configs..."
        cd "$UKE_ROOT/mac"
        stow -t "$HOME" . 2>&1 | grep -v "^LINK:" || true
        ok "macOS configs installed"
    else
        info "Installing Arch Linux configs..."
        cd "$UKE_ROOT/arch"
        stow -t "$HOME" . 2>&1 | grep -v "^LINK:" || true
        ok "Arch configs installed"
    fi
    
    # Make scripts executable
    chmod +x "$HOME/.local/bin/uke-"* 2>/dev/null || true
    
    echo ""
    ok "Installation complete!"
    echo ""
    echo "Next steps:"
    if [[ "$OS" == "macos" ]]; then
        echo "  1. Start services: yabai --start-service && skhd --start-service"
        echo "  2. Reload: Cmd+Alt+s (skhd) / Cmd+Alt+y (yabai)"
    else
        echo "  1. Copy keyd config: sudo cp ~/.config/keyd/default.conf /etc/keyd/"
        echo "  2. Enable keyd: sudo systemctl enable --now keyd"
        echo "  3. Reload Hyprland: hyprctl reload"
    fi
    echo "  4. Run health check: uke-doctor"
}

do_status() {
    echo ""
    echo "${C_CYAN}╔══════════════════════════════════════╗${C_RESET}"
    echo "${C_CYAN}║${C_RESET}  UKE System Status                   ${C_CYAN}║${C_RESET}"
    echo "${C_CYAN}╚══════════════════════════════════════╝${C_RESET}"
    
    detect_system
    detect_window_managers
    detect_terminals
    detect_shells
    detect_existing_configs
    detect_dependencies
    detect_services
    
    echo ""
}

# =============================================================================
# Help
# =============================================================================

show_help() {
    cat << EOF
${C_BOLD}UKE v8 - System Detect & Setup${C_RESET}

${C_BOLD}Usage:${C_RESET}
  $0 [command]

${C_BOLD}Commands:${C_RESET}
  detect, status   Full system detection (default)
  install          Install UKE configs via stow
  backup           Backup existing configs
  wipe             Remove existing configs (with backup option)
  help             Show this help

${C_BOLD}Examples:${C_RESET}
  $0                    # Run full detection
  $0 install            # Install UKE configs
  $0 backup             # Backup current configs
  $0 wipe               # Remove configs and start fresh

${C_BOLD}What it detects:${C_RESET}
  • Operating system and distribution
  • Window managers (yabai, skhd, Hyprland, i3, Sway)
  • Terminal emulators
  • Shells and configurations
  • Existing config files (and if they're UKE-managed)
  • Required and optional dependencies
  • Running services

EOF
}

# =============================================================================
# Main
# =============================================================================

case "${1:-status}" in
    detect|status|"")
        do_status
        ;;
    install)
        do_status
        do_install
        ;;
    backup)
        do_backup
        ;;
    wipe)
        do_wipe
        ;;
    -h|--help|help)
        show_help
        ;;
    *)
        fail "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
