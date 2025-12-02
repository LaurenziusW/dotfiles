#!/usr/bin/env bash
# ==============================================================================
# BUNCH: Coding
# Description: Development environment
# ==============================================================================

source "$(dirname "$0")/lib-os-detect.sh"

BUNCH_NAME="coding"
PRIMARY_SPACE=3

echo "🚀 Starting bunch: $BUNCH_NAME"

# Switch to code workspace
$WM_FOCUS_SPACE $PRIMARY_SPACE

# Launch applications
launch_app "terminal"
sleep 1
launch_app "code"
sleep 1
launch_app "browser"

echo "✅ Bunch '$BUNCH_NAME' ready!"
echo "   → Workspace: $PRIMARY_SPACE (Code)"
