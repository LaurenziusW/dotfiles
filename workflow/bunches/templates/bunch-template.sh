#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════
# BUNCH: [BUNCH_NAME]
# Description: [DESCRIPTION]
# ═══════════════════════════════════════════════════════════

# Load OS detection library
source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

# ───────────────────────────────────────────────────────────
# Configuration
# ───────────────────────────────────────────────────────────
BUNCH_NAME="[BUNCH_NAME]"
PRIMARY_SPACE=1  # Main workspace for this bunch

# ───────────────────────────────────────────────────────────
# Startup Sequence
# ───────────────────────────────────────────────────────────
echo "🚀 Starting bunch: $BUNCH_NAME"

# Switch to primary workspace
$WM_FOCUS_SPACE $PRIMARY_SPACE

# Launch applications (add your apps here)
# Example:
# launch_app "browser"
# sleep 1
# launch_app "notes"
# sleep 1
# launch_app "terminal"

echo "✅ Bunch '$BUNCH_NAME' ready!"

# Optional: Run additional setup commands
# cd ~/Projects/my-project
# tmux new-session -d -s bunch-session
