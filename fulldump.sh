#!/bin/bash
OUTPUT_FILE="$HOME/full-system-dump.txt"
DOTFILES_DIR="$HOME/dotfiles"
echo "🔍 Generating System Report..."

check_link() {
    if [ -L "$2" ] && [[ "$(readlink "$2")" == *"$DOTFILES_DIR"* ]]; then echo "✅ LINK OK: $1" >> "$OUTPUT_FILE"
    else echo "❌ MISSING/DRIFT: $1" >> "$OUTPUT_FILE"; fi
}

echo "--- VERIFICATION ---" > "$OUTPUT_FILE"
check_link ".zshrc" "$HOME/.zshrc"
check_link "local-bin" "$HOME/.local/bin/gather-current-space"

echo "✅ Report saved to: $OUTPUT_FILE"
