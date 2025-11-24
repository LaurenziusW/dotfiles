#!/bin/bash

# Output filename
OUTPUT="dotfiles-context-$(date +%Y%m%d).tar.gz"
REPO_ROOT="$HOME/dotfiles"

echo "🤖 Collecting Repository Context..."
echo "   Target: $OUTPUT"

# Create the archive
# -C changes directory before archiving so paths are relative to repo root
tar --exclude='.git' \
    --exclude='.DS_Store' \
    --exclude='*.tar.gz' \
    --exclude='*.bak' \
    -czf "$OUTPUT" \
    -C "$REPO_ROOT" .

echo "✅ Done. Upload '$OUTPUT' to your AI assistant."
