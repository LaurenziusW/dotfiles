#!/usr/bin/env bash

# Source and Destination
WORKFLOW_SRC="$HOME/workflow"
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Migrating from $WORKFLOW_SRC to $DOTFILES_DIR..."

# 1. Create the Stow-compatible directory structure
# -------------------------------------------------
echo "Creating directory structure..."
mkdir -p "$DOTFILES_DIR/local-bin/.local/bin"
mkdir -p "$DOTFILES_DIR/workflow/bunches"
mkdir -p "$DOTFILES_DIR/scripts/maintenance"

# 2. Migrate Scripts (and rename to remove .sh extension)
# -------------------------------------------------
echo "Migrating Scripts to local-bin..."

# Helper function to move if exists
move_script() {
    if [ -f "$WORKFLOW_SRC/scripts/$1.sh" ]; then
        cp "$WORKFLOW_SRC/scripts/$1.sh" "$DOTFILES_DIR/local-bin/.local/bin/$1"
        chmod +x "$DOTFILES_DIR/local-bin/.local/bin/$1"
        echo "  [+] Moved $1"
    else
        echo "  [!] Warning: $1.sh not found in source"
    fi
}

move_script "bunch-manager"
move_script "gather-current-space"
move_script "lib-os-detect"

# Move AI collector to maintenance scripts (not bin path)
if [ -f "$WORKFLOW_SRC/scripts/collect-for-ai.sh" ]; then
    cp "$WORKFLOW_SRC/scripts/collect-for-ai.sh" "$DOTFILES_DIR/scripts/maintenance/collect-for-ai.sh"
    chmod +x "$DOTFILES_DIR/scripts/maintenance/collect-for-ai.sh"
    echo "  [+] Moved collect-for-ai.sh"
fi

# 3. Migrate Bunches
# -------------------------------------------------
echo "Migrating Bunches..."
if [ -d "$WORKFLOW_SRC/bunches" ]; then
    cp -r "$WORKFLOW_SRC/bunches/"* "$DOTFILES_DIR/workflow/bunches/"
    echo "  [+] Copied all bunches"
else
    echo "  [!] Bunches directory not found at source"
fi

echo "------------------------------------------------"
echo "Migration prepared."
echo "Run ./install.sh to symlink these files to your system."
