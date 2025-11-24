#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════
# BUNCH MANAGER
# Create and manage environment bunches
# ═══════════════════════════════════════════════════════════

BUNCHES_DIR="$(dirname "$0")"

show_help() {
    cat << HELP
Bunch Manager - Environment Management System

Usage:
  bunch-manager.sh list                    List all available bunches
  bunch-manager.sh create <name>           Create new bunch from template
  bunch-manager.sh run <name>              Run a bunch
  bunch-manager.sh edit <name>             Edit a bunch script
  bunch-manager.sh help                    Show this help

Examples:
  bunch-manager.sh create deep-work
  bunch-manager.sh run study-math
  bunch-manager.sh list

HELP
}

list_bunches() {
    echo "Available Bunches:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    for script in "$BUNCHES_DIR"/*.sh; do
        if [[ -f "$script" && -x "$script" ]]; then
            name=$(basename "$script" .sh)
            [[ "$name" == "lib-os-detect" || "$name" == "bunch-manager" ]] && continue
            echo "  • $name"
        fi
    done
}

create_bunch() {
    local name=$1
    if [[ -z "$name" ]]; then
        echo "Error: Bunch name required"
        exit 1
    fi
    
    local filepath="$BUNCHES_DIR/${name}.sh"
    if [[ -f "$filepath" ]]; then
        echo "Error: Bunch '$name' already exists"
        exit 1
    fi
    
    # Copy template
    cp "$BUNCHES_DIR/templates/bunch-template.sh" "$filepath"
    
    # Replace placeholders
    sed -i.bak "s/\[BUNCH_NAME\]/$name/g" "$filepath"
    sed -i.bak "s/\[DESCRIPTION\]/Custom bunch for $name/g" "$filepath"
    rm "${filepath}.bak" 2>/dev/null || true
    
    chmod +x "$filepath"
    echo "✅ Created bunch: $filepath"
    echo "Edit it with: \$EDITOR $filepath"
}

run_bunch() {
    local name=$1
    if [[ -z "$name" ]]; then
        echo "Error: Bunch name required"
        exit 1
    fi
    
    local filepath="$BUNCHES_DIR/${name}.sh"
    if [[ ! -f "$filepath" ]]; then
        echo "Error: Bunch '$name' not found"
        list_bunches
        exit 1
    fi
    
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
        exit 1
    fi
    
    ${EDITOR:-vim} "$filepath"
}

case "${1:-help}" in
    list)
        list_bunches
        ;;
    create)
        create_bunch "$2"
        ;;
    run)
        run_bunch "$2"
        ;;
    edit)
        edit_bunch "$2"
        ;;
    help|*)
        show_help
        ;;
esac
