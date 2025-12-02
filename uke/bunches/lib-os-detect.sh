#!/usr/bin/env bash
# ==============================================================================
# UKE OS Detection Library v6.3
# ==============================================================================
# Provides cross-platform helpers for bunches and scripts
# Source this in any bunch script: source "$(dirname "$0")/lib-os-detect.sh"
# ==============================================================================

# ------------------------------------------------------------------------------
# OS Detection
# ------------------------------------------------------------------------------
detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "macos" ;;
        Linux*)  echo "linux" ;;
        *)       echo "unknown" ;;
    esac
}

OS_TYPE=$(detect_os)

# ------------------------------------------------------------------------------
# Distro Detection (Linux only)
# ------------------------------------------------------------------------------
detect_distro() {
    if [[ "$OS_TYPE" != "linux" ]]; then
        echo ""
        return
    fi
    
    if [[ -f /etc/arch-release ]]; then
        echo "arch"
    elif [[ -f /etc/debian_version ]]; then
        echo "debian"
    elif [[ -f /etc/fedora-release ]]; then
        echo "fedora"
    else
        echo "unknown"
    fi
}

DISTRO=$(detect_distro)

# ------------------------------------------------------------------------------
# Window Manager Commands (set based on OS)
# ------------------------------------------------------------------------------
setup_os_commands() {
    if [ "$OS_TYPE" = "macos" ]; then
        WM_FOCUS_SPACE="yabai -m space --focus"
        WM_SEND_WINDOW="yabai -m window --space"
        WM_QUERY_SPACE="yabai -m query --spaces --space"
    else
        WM_FOCUS_SPACE="hyprctl dispatch workspace"
        WM_SEND_WINDOW="hyprctl dispatch movetoworkspace"
        WM_QUERY_SPACE="hyprctl activeworkspace"
    fi
    export WM_FOCUS_SPACE WM_SEND_WINDOW WM_QUERY_SPACE
}

# ------------------------------------------------------------------------------
# App Name Mapping
# ------------------------------------------------------------------------------
# Returns the correct app name/command for the current OS
get_app_command() {
    local app_key="$1"
    
    case "$app_key" in
        browser|brave)
            [ "$OS_TYPE" = "macos" ] && echo "Brave Browser" || echo "brave" ;;
        safari)
            [ "$OS_TYPE" = "macos" ] && echo "Safari" || echo "" ;;
        firefox)
            echo "firefox" ;;
        chromium)
            [ "$OS_TYPE" = "macos" ] && echo "Chromium" || echo "chromium" ;;
        notes|obsidian)
            [ "$OS_TYPE" = "macos" ] && echo "Obsidian" || echo "obsidian" ;;
        terminal|wezterm)
            [ "$OS_TYPE" = "macos" ] && echo "WezTerm" || echo "wezterm" ;;
        alacritty)
            [ "$OS_TYPE" = "macos" ] && echo "Alacritty" || echo "alacritty" ;;
        kitty)
            echo "kitty" ;;
        code|vscode)
            [ "$OS_TYPE" = "macos" ] && echo "Code" || echo "code" ;;
        codium|vscodium)
            [ "$OS_TYPE" = "macos" ] && echo "VSCodium" || echo "codium" ;;
        music|spotify)
            [ "$OS_TYPE" = "macos" ] && echo "Spotify" || echo "spotify" ;;
        pdf|preview)
            [ "$OS_TYPE" = "macos" ] && echo "Preview" || echo "evince" ;;
        zathura)
            echo "zathura" ;;
        okular)
            echo "okular" ;;
        slack)
            [ "$OS_TYPE" = "macos" ] && echo "Slack" || echo "slack" ;;
        discord)
            [ "$OS_TYPE" = "macos" ] && echo "Discord" || echo "discord" ;;
        mail)
            [ "$OS_TYPE" = "macos" ] && echo "Mail" || echo "thunderbird" ;;
        telegram)
            [ "$OS_TYPE" = "macos" ] && echo "Telegram" || echo "telegram-desktop" ;;
        signal)
            [ "$OS_TYPE" = "macos" ] && echo "Signal" || echo "signal-desktop" ;;
        raindrop)
            [ "$OS_TYPE" = "macos" ] && echo "Raindrop.io" || echo "raindrop" ;;
        word)
            [ "$OS_TYPE" = "macos" ] && echo "Microsoft Word" || echo "libreoffice --writer" ;;
        excel)
            [ "$OS_TYPE" = "macos" ] && echo "Microsoft Excel" || echo "libreoffice --calc" ;;
        powerpoint)
            [ "$OS_TYPE" = "macos" ] && echo "Microsoft PowerPoint" || echo "libreoffice --impress" ;;
        libreoffice)
            echo "libreoffice" ;;
        files|finder)
            [ "$OS_TYPE" = "macos" ] && echo "Finder" || echo "thunar" ;;
        nautilus)
            echo "nautilus" ;;
        thunar)
            echo "thunar" ;;
        dolphin)
            echo "dolphin" ;;
        *)
            echo "$app_key" ;;
    esac
}

# ------------------------------------------------------------------------------
# App Launcher
# ------------------------------------------------------------------------------
launch_app() {
    local app_key="$1"
    local app_name
    app_name=$(get_app_command "$app_key")
    
    if [ -z "$app_name" ]; then
        echo "⚠️  App '$app_key' not available on $OS_TYPE"
        return 1
    fi
    
    if [ "$OS_TYPE" = "macos" ]; then
        open -a "$app_name" 2>/dev/null &
    else
        # Linux: try to find and run the command
        local cmd="${app_name,,}"  # lowercase
        
        # Handle commands with arguments (like libreoffice --writer)
        if [[ "$app_name" == *" "* ]]; then
            $app_name &>/dev/null &
        elif command -v "$cmd" &>/dev/null; then
            "$cmd" &>/dev/null &
        elif command -v "$app_name" &>/dev/null; then
            "$app_name" &>/dev/null &
        else
            echo "⚠️  Could not launch: $app_name"
            return 1
        fi
    fi
    
    echo "✓ Launched: $app_name"
}

# ------------------------------------------------------------------------------
# Gather Functions
# ------------------------------------------------------------------------------
get_current_workspace() {
    if [ "$OS_TYPE" = "macos" ]; then
        yabai -m query --spaces --space | jq -r '.index'
    else
        hyprctl activeworkspace -j | jq -r '.id'
    fi
}

# Move windows of specific app to a workspace
gather_app_to_space() {
    local app_name="$1"
    local target_space="$2"
    
    if [ "$OS_TYPE" = "macos" ]; then
        yabai -m query --windows | jq -r ".[] | select(.app == \"$app_name\") | .id" | \
            xargs -I {} yabai -m window {} --space "$target_space" 2>/dev/null
    else
        # On Linux, use class name matching
        hyprctl clients -j | jq -r ".[] | select(.class | test(\"$app_name\"; \"i\")) | .address" | \
            while read -r addr; do
                hyprctl dispatch movetoworkspacesilent "$target_space,address:$addr" 2>/dev/null
            done
    fi
}

# ------------------------------------------------------------------------------
# Notification Helper
# ------------------------------------------------------------------------------
notify() {
    local title="$1"
    local message="${2:-}"
    
    if [ "$OS_TYPE" = "macos" ]; then
        osascript -e "display notification \"$message\" with title \"$title\"" 2>/dev/null || true
    else
        if command -v notify-send &>/dev/null; then
            notify-send "$title" "$message" 2>/dev/null || true
        fi
    fi
}

# ------------------------------------------------------------------------------
# Clipboard Helper
# ------------------------------------------------------------------------------
clipboard_copy() {
    if [ "$OS_TYPE" = "macos" ]; then
        pbcopy
    else
        if command -v wl-copy &>/dev/null; then
            wl-copy
        elif command -v xclip &>/dev/null; then
            xclip -selection clipboard
        fi
    fi
}

clipboard_paste() {
    if [ "$OS_TYPE" = "macos" ]; then
        pbpaste
    else
        if command -v wl-paste &>/dev/null; then
            wl-paste
        elif command -v xclip &>/dev/null; then
            xclip -selection clipboard -o
        fi
    fi
}

# ------------------------------------------------------------------------------
# Auto-setup when sourced
# ------------------------------------------------------------------------------
setup_os_commands
