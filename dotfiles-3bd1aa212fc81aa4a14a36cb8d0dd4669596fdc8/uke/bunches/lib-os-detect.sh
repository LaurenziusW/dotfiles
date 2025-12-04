#!/usr/bin/env bash
# ==============================================================================
# UKE OS Detection Library v7.0
# ==============================================================================
# Provides cross-platform helpers for bunches and scripts
# Source this in any bunch script: source "$(dirname "$0")/lib-os-detect.sh"
# ==============================================================================

# ==============================================================================
# OS Detection
# ==============================================================================
detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "macos" ;;
        Linux*)  echo "linux" ;;
        *)       echo "unknown" ;;
    esac
}

OS_TYPE=$(detect_os)

# ==============================================================================
# Window Manager Commands
# ==============================================================================
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

# ==============================================================================
# App Name Mapping
# ==============================================================================
get_app_command() {
    local app_key="$1"
    
    case "$app_key" in
        browser|brave)
            [ "$OS_TYPE" = "macos" ] && echo "Brave Browser" || echo "brave" ;;
        safari)
            [ "$OS_TYPE" = "macos" ] && echo "Safari" || echo "" ;;
        firefox)
            echo "firefox" ;;
        notes|obsidian)
            [ "$OS_TYPE" = "macos" ] && echo "Obsidian" || echo "obsidian" ;;
        terminal|wezterm)
            [ "$OS_TYPE" = "macos" ] && echo "WezTerm" || echo "wezterm" ;;
        code|vscode)
            [ "$OS_TYPE" = "macos" ] && echo "Visual Studio Code" || echo "code" ;;
        music|spotify)
            [ "$OS_TYPE" = "macos" ] && echo "Spotify" || echo "spotify" ;;
        pdf|preview)
            [ "$OS_TYPE" = "macos" ] && echo "Preview" || echo "evince" ;;
        slack)
            [ "$OS_TYPE" = "macos" ] && echo "Slack" || echo "slack" ;;
        discord)
            [ "$OS_TYPE" = "macos" ] && echo "Discord" || echo "discord" ;;
        mail)
            [ "$OS_TYPE" = "macos" ] && echo "Mail" || echo "thunderbird" ;;
        *)
            echo "$app_key" ;;
    esac
}

# ==============================================================================
# App Launcher
# ==============================================================================
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
        local cmd="${app_name,,}"
        if command -v "$cmd" &>/dev/null; then
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

# ==============================================================================
# Notification Helper
# ==============================================================================
notify() {
    local title="$1"
    local message="${2:-}"
    
    if [ "$OS_TYPE" = "macos" ]; then
        osascript -e "display notification \"$message\" with title \"$title\"" 2>/dev/null || true
    else
        command -v notify-send &>/dev/null && notify-send "$title" "$message" 2>/dev/null || true
    fi
}

# Auto-setup
setup_os_commands
