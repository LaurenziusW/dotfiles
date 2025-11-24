#!/usr/bin/env bash
source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

echo "📧 Starting: Email & Admin"

# Communication apps
$WM_FOCUS_SPACE 5
os=$(detect_os)
if [[ "$os" == "macos" ]]; then
    open -a "Mail"
    sleep 1
    open -a "Slack"
else
    gtk-launch thunderbird &
    sleep 1
    gtk-launch slack &
fi

# Browser for webmail/admin panels
$WM_FOCUS_SPACE 1
launch_app "browser"

# Office apps if needed
$WM_FOCUS_SPACE 7

echo "✅ Admin environment ready!"
