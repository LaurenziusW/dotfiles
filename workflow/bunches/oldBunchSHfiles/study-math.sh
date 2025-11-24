#!/usr/bin/env bash
source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

echo "📚 Starting: Study Math"

# Focus workspace 2 (Notes)
$WM_FOCUS_SPACE 2
sleep 0.5

# Open Obsidian to math notes
launch_app "notes"
sleep 2

# Open browser for research
launch_app "browser"
sleep 1

# Open terminal for calculations (Julia, Python, etc.)
$WM_FOCUS_SPACE 3
launch_app "terminal"

# Open PDF reader for textbooks
$WM_FOCUS_SPACE 8
launch_app "pdf"

# Return to notes
$WM_FOCUS_SPACE 2

echo "✅ Math study environment ready!"
