#!/usr/bin/env bash
# OS Detection Library for Bunches

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "unknown"
    fi
}

# Export OS-specific commands
setup_os_commands() {
    local os=$(detect_os)
    
    if [[ "$os" == "macos" ]]; then
        export OPEN_CMD="open -a"
        export WM_FOCUS_SPACE="yabai -m space --focus"
        export WM_SEND_WINDOW="yabai -m window --space"
    elif [[ "$os" == "linux" ]]; then
        export OPEN_CMD="gtk-launch"  # or "exo-open" on some distros
        export WM_FOCUS_SPACE="hyprctl dispatch workspace"
        export WM_SEND_WINDOW="hyprctl dispatch movetoworkspace"
    fi
}

# App name translation between macOS and Linux
get_app_command() {
    local app_key=$1
    local os=$(detect_os)
    
    case "$app_key" in
        "browser")
            [[ "$os" == "macos" ]] && echo "Safari" || echo "firefox"
            ;;
        "notes")
            echo "Obsidian"  # Same on both platforms
            ;;
        "terminal")
            echo "WezTerm"  # Same on both platforms
            ;;
        "code")
            [[ "$os" == "macos" ]] && echo "Visual Studio Code" || echo "code"
            ;;
        "music")
            [[ "$os" == "macos" ]] && echo "Spotify" || echo "spotify"
            ;;
        "office-word")
            [[ "$os" == "macos" ]] && echo "Microsoft Word" || echo "libreoffice"
            ;;
        "pdf")
            [[ "$os" == "macos" ]] && echo "Preview" || echo "evince"
            ;;
        *)
            echo "$app_key"
            ;;
    esac
}

# Launch app with proper command
launch_app() {
    local app_key=$1
    local app_name=$(get_app_command "$app_key")
    local os=$(detect_os)
    
    if [[ "$os" == "macos" ]]; then
        open -a "$app_name"
    else
        gtk-launch "$app_name" &>/dev/null || "$app_name" &
    fi
}
