#!/usr/bin/env bash
source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

echo "💻 Starting: Coding Project"

# Terminal for git/builds
$WM_FOCUS_SPACE 3
launch_app "terminal"
sleep 1

# Code editor
$WM_FOCUS_SPACE 4
launch_app "code"
sleep 2

# Browser for docs
$WM_FOCUS_SPACE 1
launch_app "browser"

# Return to terminal
$WM_FOCUS_SPACE 3

echo "✅ Coding environment ready!"
# Optional: cd to project and start tmux session
# cd ~/Projects/my-awesome-project
# tmux new-session -d -s coding
