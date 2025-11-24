#!/usr/bin/env bash
source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

echo "🎸 Starting: Guitar Practice"

# Open music player
$WM_FOCUS_SPACE 6
launch_app "music"
sleep 1

# Open browser for tabs/tutorials
$WM_FOCUS_SPACE 1
launch_app "browser"
sleep 1

# Open notes for practice log
$WM_FOCUS_SPACE 2
launch_app "notes"

echo "✅ Guitar practice environment ready!"
