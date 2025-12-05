#!/usr/bin/env bash

# This script detects the current workspace and gathers all
# windows that "belong" to it, based on the unified config.

# Load the OS detection library from its expected path
source "$(dirname "$0")/lib-os-detect.sh"

# Capture the output of detect_os (which echoes the OS name)
OS_TYPE=$(detect_os)

# --- macOS (Yabai) Implementation ---
if [ "$OS_TYPE" = "macos" ]; then
    CURRENT_SPACE=$(yabai -m query --spaces --space | jq '.index')
    echo "Gathering windows for macOS Space $CURRENT_SPACE..."
    
    case $CURRENT_SPACE in
        1) # Browser
            yabai -m query --windows | jq -r '.[] | select(.app == "Safari" or .app == "Brave Browser") | .id' | xargs -I {} yabai -m window {} --space 1 ;;
        2) # Notes
            yabai -m query --windows | jq -r '.[] | select(.app == "Obsidian") | .id' | xargs -I {} yabai -m window {} --space 2 ;;
        3) # Terminal & Code
            yabai -m query --windows | jq -r '.[] | select(.app == "WezTerm" or .app == "Code" or .app == "Xcode") | .id' | xargs -I {} yabai -m window {} --space 3 ;;
        5) # PDF
            yabai -m query --windows | jq -r '.[] | select(.app == "Preview" or .app == "PDF Expert") | .id' | xargs -I {} yabai -m window {} --space 5 ;;
        6) # Raindrop
            yabai -m query --windows | jq -r '.[] | select(.app == "Raindrop.io") | .id' | xargs -I {} yabai -m window {} --space 6 ;;
        7) # Media
            yabai -m query --windows | jq -r '.[] | select(.app == "Spotify") | .id' | xargs -I {} yabai -m window {} --space 7 ;;
        8) # Office
            yabai -m query --windows | jq -r '.[] | select(.app == "Microsoft Word" or .app == "Microsoft Excel" or .app == "Microsoft PowerPoint") | .id' | xargs -I {} yabai -m window {} --space 8 ;;

        9) # Comms
            yabai -m query --windows | jq -r '.[] | select(.app == "Slack" or .app == "Discord" or .app == "Mail" or .app == "Telegram") | .id' | xargs -I {} yabai -m window {} --space 9 ;;

        10) # AI
            yabai -m query --windows | jq -r '.[] | select(.app == "Claude" or .app == "Perplexity") | .id' | xargs -I {} yabai -m window {} --space 10 ;;
        *) # Spaces 4 (Catch-all) and others
            echo "No gather action defined for this space." ;;
    esac

# --- Linux (Hyprland) Implementation ---
elif [ "$OS_TYPE" = "linux" ]; then
    CURRENT_SPACE=$(hyprctl activeworkspace | grep 'workspace ID' | awk '{print $3}')
    echo "Gathering windows for Linux Workspace $CURRENT_SPACE..."

    case $CURRENT_SPACE in
        1) # Browser
            hyprctl dispatch movetoworkspace 1,class:Safari
            hyprctl dispatch movetoworkspace 1,class:Brave-browser ;;
        2) # Notes
            hyprctl dispatch movetoworkspace 2,class:Obsidian ;;
        3) # Terminal & Code
            hyprctl dispatch movetoworkspace 3,class:WezTerm
            hyprctl dispatch movetoworkspace 3,class:Code
            hyprctl dispatch movetoworkspace 3,class:Xcode ;;
        5) # PDF
            hyprctl dispatch movetoworkspace 5,class:Preview
            hyprctl dispatch movetoworkspace 5,class:PDFExpert ;;
        6) # Raindrop
            hyprctl dispatch movetoworkspace 6,class:Raindrop.io ;;
        7) # Media
            hyprctl dispatch movetoworkspace 7,class:Spotify ;;
        8) # Office
            hyprctl dispatch movetoworkspace 8,class:"Microsoft Word"
            hyprctl dispatch movetoworkspace 8,class:"Microsoft Excel"
            hyprctl dispatch movetoworkspace 8,class:"Microsoft PowerPoint" ;;
        9) # Comms
            hyprctl dispatch movetoworkspace 9,class:Slack
            hyprctl dispatch movetoworkspace 9,class:discord
            hyprctl dispatch movetoworkspace 9,class:Mail ;;
        *) # Spaces 4 (Catch-all) and others
            echo "No gather action defined for this space." ;;
    esac
fi
