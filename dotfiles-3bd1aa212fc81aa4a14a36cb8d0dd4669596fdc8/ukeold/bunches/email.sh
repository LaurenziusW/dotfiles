#!/usr/bin/env bash
# ==============================================================================
# BUNCH: Email
# Description: Communication and admin environment
# ==============================================================================

source "$(dirname "$0")/lib-os-detect.sh"

BUNCH_NAME="email"
PRIMARY_SPACE=9

echo "🚀 Starting bunch: $BUNCH_NAME"

# Switch to communication workspace
$WM_FOCUS_SPACE $PRIMARY_SPACE

# Launch applications
launch_app "mail"
sleep 1
launch_app "slack"
sleep 1
launch_app "browser"

echo "✅ Bunch '$BUNCH_NAME' ready!"
echo "   → Workspace: $PRIMARY_SPACE (Communication)"
