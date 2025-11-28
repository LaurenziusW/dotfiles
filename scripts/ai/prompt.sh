#!/usr/bin/env bash
# ==============================================================================
# UKE AI Prompt Generator
# ==============================================================================
# Generates focused prompts for specific AI tasks
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UKE_ROOT="${SCRIPT_DIR%/scripts/ai}"

prompt_add_keybinding() {
    cat << EOF
# Task: Add a new keybinding to UKE

## Context
I need to add a new keybinding to my UKE configuration.

## Current registry.yaml structure (keys section):
\`\`\`yaml
$(grep -A 100 "^keys:" "$UKE_ROOT/config/registry.yaml" | head -50)
\`\`\`

## Modifier options:
- primary: Cmd (macOS) / Alt (Linux) - main modifier
- primary_shift: + Shift
- tertiary: Cmd+Alt / Super - launchers
- bunch: Cmd+Ctrl / Super+Ctrl - bunches
- resize: Alt+Shift

## Request
[DESCRIBE YOUR KEYBINDING HERE]

Please provide:
1. The YAML entry to add to the keys section
2. Any other changes needed
EOF
}

prompt_add_workspace() {
    cat << EOF
# Task: Add/modify workspace in UKE

## Current workspaces:
\`\`\`yaml
$(grep -A 30 "^workspaces:" "$UKE_ROOT/config/registry.yaml")
\`\`\`

## Current apps:
\`\`\`yaml
$(grep -A 50 "^apps:" "$UKE_ROOT/config/registry.yaml" | head -40)
\`\`\`

## Request
[DESCRIBE YOUR WORKSPACE CHANGE HERE]
EOF
}

prompt_add_bunch() {
    cat << EOF
# Task: Create a new bunch in UKE

## Current bunches:
\`\`\`yaml
$(grep -A 20 "^bunches:" "$UKE_ROOT/config/registry.yaml")
\`\`\`

## Available apps:
$(grep "^  [a-z]" "$UKE_ROOT/config/registry.yaml" | head -30)

## Request
[DESCRIBE YOUR BUNCH HERE]
EOF
}

prompt_debug() {
    cat << EOF
# Task: Debug UKE issue

## System Info
- Platform: $(uname -s)
- Shell: $SHELL
- UKE_ROOT: $UKE_ROOT

## Generated Configs
$(ls -la "$UKE_ROOT/gen/" 2>/dev/null || echo "No generated configs")

## Recent Log
\`\`\`
$(tail -20 "${XDG_STATE_HOME:-$HOME/.local/state}/uke/uke.log" 2>/dev/null || echo "No logs")
\`\`\`

## Issue
[DESCRIBE YOUR ISSUE HERE]
EOF
}

prompt_full() {
    bash "$SCRIPT_DIR/dump-context.sh"
}

usage() {
    cat << EOF
Usage: $0 <type>

Types:
  keybinding    Prompt for adding keybindings
  workspace     Prompt for workspace changes
  bunch         Prompt for new bunches
  debug         Prompt for debugging issues
  full          Full project context dump

Example:
  $0 keybinding | pbcopy    # Copy to clipboard (macOS)
  $0 debug > /tmp/debug.md  # Save to file
EOF
}

case "${1:-}" in
    keybinding) prompt_add_keybinding ;;
    workspace)  prompt_add_workspace ;;
    bunch)      prompt_add_bunch ;;
    debug)      prompt_debug ;;
    full)       prompt_full ;;
    *)          usage ;;
esac
