#!/usr/bin/env bash
# ==============================================================================
# BUNCH: Guitar
# Description: Guitar practice environment
# ==============================================================================

source "$(dirname "$0")/lib-os-detect.sh"

BUNCH_NAME="guitar"
PRIMARY_SPACE=7

echo "🚀 Starting bunch: $BUNCH_NAME"

# Switch to media workspace
$WM_FOCUS_SPACE $PRIMARY_SPACE

# Launch applications
launch_app "spotify"
sleep 1
launch_app "browser"

echo "✅ Bunch '$BUNCH_NAME' ready!"
echo "   → Workspace: $PRIMARY_SPACE (Media)"
