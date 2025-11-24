#!/bin/bash
OUTPUT="dotfiles-context.tar.gz"
echo "📦 Packing repo context..."
tar --exclude='.git' --exclude='*.tar.gz' --exclude='.DS_Store' \
    -czf "$OUTPUT" -C "$HOME/dotfiles" .
echo "✅ Context ready: $OUTPUT"
