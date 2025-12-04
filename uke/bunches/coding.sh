#!/usr/bin/env bash
# ==============================================================================
# BUNCH: Coding - Development Environment
# ==============================================================================
source "$(dirname "$0")/lib-os-detect.sh"

BUNCH_NAME="coding"
PRIMARY_SPACE=3

echo "🚀 Starting bunch: $BUNCH_NAME"

$WM_FOCUS_SPACE $PRIMARY_SPACE

launch_app "terminal"
sleep 1
launch_app "code"
sleep 1
launch_app "browser"

notify "UKE Bunch" "$BUNCH_NAME environment ready"
echo "✅ Bunch '$BUNCH_NAME' ready → Workspace $PRIMARY_SPACE"
