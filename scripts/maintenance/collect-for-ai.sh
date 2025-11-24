#!/bin/bash
OUTPUT="dotfiles-context-$(date +%Y%m%d).tar.gz"
echo "📦 Packing repo context..."
tar --exclude='.git' --exclude='*.tar.gz' --exclude='.DS_Store' --exclude='*.bak' \
    -czf "$OUTPUT" -C "$HOME/dotfiles" .
echo "✅ Context ready: $OUTPUT"
