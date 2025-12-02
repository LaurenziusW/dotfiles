#!/usr/bin/env bash
# ==============================================================================
# UKE Bunch Manager
# Create and manage environment bunches
# ==============================================================================

BUNCHES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$(dirname "$BUNCHES_DIR")/templates"

source "$BUNCHES_DIR/lib-os-detect.sh"

show_help() {
    cat << 'HELP'
Bunch Manager - Environment Management System

Usage:
  bunch-manager.sh list                    List all available bunches
  bunch-manager.sh create <name>           Create new bunch from template
  bunch-manager.sh run <name>              Run a bunch
  bunch-manager.sh edit <name>             Edit a bunch script
  bunch-manager.sh help                    Show this help

Examples:
  bunch-manager.sh create deep-work
  bunch-manager.sh run study
  bunch-manager.sh list

HELP
}

list_bunches() {
    echo "Available Bunches:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    for script in "$BUNCHES_DIR"/*.sh; do
        if [[ -f "$script" && -x "$script" ]]; then
            name=$(basename "$script" .sh)
            # Skip library files
            [[ "$name" == "lib-os-detect" || "$name" == "bunch-manager" ]] && continue
            echo "  • $name"
        fi
    done
    echo ""
    echo "Run with: bunch-manager.sh run <name>"
    echo "Or via hotkey: Cmd+Ctrl+1-5 (macOS) / Alt+Ctrl+1-5 (Linux)"
}

create_bunch() {
    local name=$1
    if [[ -z "$name" ]]; then
        echo "Error: Bunch name required"
        echo "Usage: bunch-manager.sh create <name>"
        exit 1
    fi
    
    local filepath="$BUNCHES_DIR/${name}.sh"
    if [[ -f "$filepath" ]]; then
        echo "Error: Bunch '$name' already exists at $filepath"
        exit 1
    fi
    
    local template="$TEMPLATES_DIR/bunch-template.sh"
    if [[ ! -f "$template" ]]; then
        echo "Error: Template not found at $template"
        exit 1
    fi
    
    # Copy and customize template
    sed -e "s/\[BUNCH_NAME\]/$name/g" \
        -e "s/\[DESCRIPTION\]/Custom environment for $name/g" \
        "$template" > "$filepath"
    
    chmod +x "$filepath"
    echo "✅ Created bunch: $filepath"
    echo ""
    echo "Edit it with:"
    echo "  \$EDITOR $filepath"
    echo ""
    echo "Or run: bunch-manager.sh edit $name"
}

run_bunch() {
    local name=$1
    if [[ -z "$name" ]]; then
        echo "Error: Bunch name required"
        list_bunches
        exit 1
    fi
    
    local filepath="$BUNCHES_DIR/${name}.sh"
    if [[ ! -f "$filepath" ]]; then
        echo "Error: Bunch '$name' not found"
        echo ""
        list_bunches
        exit 1
    fi
    
    echo "🚀 Running bunch: $name"
    "$filepath"
}

edit_bunch() {
    local name=$1
    if [[ -z "$name" ]]; then
        echo "Error: Bunch name required"
        exit 1
    fi
    
    local filepath="$BUNCHES_DIR/${name}.sh"
    if [[ ! -f "$filepath" ]]; then
        echo "Error: Bunch '$name' not found"
        echo "Create it with: bunch-manager.sh create $name"
        exit 1
    fi
    
    ${EDITOR:-nvim} "$filepath"
}

case "${1:-help}" in
    list|ls)    list_bunches ;;
    create|new) create_bunch "$2" ;;
    run)        run_bunch "$2" ;;
    edit)       edit_bunch "$2" ;;
    help|--help|-h|*) show_help ;;
esac
