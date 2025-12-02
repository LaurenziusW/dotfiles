#!/usr/bin/env bash
# ==============================================================================
# BUNCH: Study
# Description: Math and study environment
# ==============================================================================

source "$(dirname "$0")/lib-os-detect.sh"

BUNCH_NAME="study"
PRIMARY_SPACE=2

echo "🚀 Starting bunch: $BUNCH_NAME"

# Switch to notes workspace
$WM_FOCUS_SPACE $PRIMARY_SPACE

# Launch applications
launch_app "obsidian"
sleep 1
launch_app "browser"
sleep 1
launch_app "terminal"
sleep 0.5
launch_app "pdf"

echo "✅ Bunch '$BUNCH_NAME' ready!"
echo "   → Workspace: $PRIMARY_SPACE (Notes)"
