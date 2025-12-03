#!/usr/bin/env bash
# ==============================================================================
# BUNCH: Study - Note-taking and Research
# ==============================================================================
source "$(dirname "$0")/lib-os-detect.sh"

BUNCH_NAME="study"
PRIMARY_SPACE=2

echo "🚀 Starting bunch: $BUNCH_NAME"

$WM_FOCUS_SPACE $PRIMARY_SPACE

launch_app "obsidian"
sleep 1
launch_app "browser"
sleep 1
launch_app "terminal"
sleep 0.5
launch_app "pdf"

notify "UKE Bunch" "$BUNCH_NAME environment ready"
echo "✅ Bunch '$BUNCH_NAME' ready → Workspace $PRIMARY_SPACE"
