#!/usr/bin/env bash
# ==============================================================================
# BUNCH: Reading
# Description: Focused reading environment
# ==============================================================================

source "$(dirname "$0")/lib-os-detect.sh"

BUNCH_NAME="reading"
PRIMARY_SPACE=5

echo "🚀 Starting bunch: $BUNCH_NAME"

# Switch to documents workspace
$WM_FOCUS_SPACE $PRIMARY_SPACE

# Launch applications
launch_app "pdf"
sleep 1
launch_app "obsidian"

echo "✅ Bunch '$BUNCH_NAME' ready!"
echo "   → Workspace: $PRIMARY_SPACE (Documents)"
