#!/bin/bash
# Dumps repo context for LLMs
OUTPUT="dotfiles-context.tar.gz"
echo "📦 Packing dotfiles context..."
tar --exclude='.git' --exclude='*.tar.gz' --exclude='.DS_Store' \
    -czf "$OUTPUT" -C "$HOME/dotfiles" .
echo "✅ Context ready: $OUTPUT"
