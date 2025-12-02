#!/usr/bin/env bash
# ==============================================================================
# UKE OS Detection Library
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
        notes|obsidian)
            echo "Obsidian" ;;
        terminal|wezterm)
            echo "WezTerm" ;;
        code|vscode)
            echo "Code" ;;
        music|spotify)
            echo "Spotify" ;;
        pdf|preview)
            [ "$OS_TYPE" = "macos" ] && echo "Preview" || echo "evince" ;;
        slack)
            echo "Slack" ;;
        discord)
            echo "Discord" ;;
        mail)
            [ "$OS_TYPE" = "macos" ] && echo "Mail" || echo "thunderbird" ;;
        raindrop)
            echo "Raindrop.io" ;;
        word)
            [ "$OS_TYPE" = "macos" ] && echo "Microsoft Word" || echo "libreoffice-writer" ;;
        excel)
            [ "$OS_TYPE" = "macos" ] && echo "Microsoft Excel" || echo "libreoffice-calc" ;;
        powerpoint)
            [ "$OS_TYPE" = "macos" ] && echo "Microsoft PowerPoint" || echo "libreoffice-impress" ;;
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

# ------------------------------------------------------------------------------
# Gather Functions
# ------------------------------------------------------------------------------
get_current_workspace() {
    if [ "$OS_TYPE" = "macos" ]; then
        yabai -m query --spaces --space | jq -r '.index'
    else
        hyprctl activeworkspace | grep 'workspace ID' | awk '{print $3}'
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
        hyprctl dispatch movetoworkspace "$target_space,class:$app_name" 2>/dev/null
    fi
}

# ------------------------------------------------------------------------------
# Auto-setup when sourced
# ------------------------------------------------------------------------------
setup_os_commands
