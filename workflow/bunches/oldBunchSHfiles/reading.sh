#!/usr/bin/env bash
source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

echo "📖 Starting: Reading"

# PDF reader
$WM_FOCUS_SPACE 8
launch_app "pdf"
sleep 1

# Notes for highlights/thoughts
$WM_FOCUS_SPACE 2
launch_app "notes"

# Focus on reading space
$WM_FOCUS_SPACE 8

echo "✅ Reading environment ready!"
