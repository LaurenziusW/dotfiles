#!/usr/bin/env bash
# =============================================================================
# UKE v8 - Project Collector
# usage: ./collect-for-ai.sh
# =============================================================================
set -e

OUTPUT="uke-full-context.txt"
ROOT="$(cd "$(dirname "$0")" && pwd)"

echo "Collecting project files from: $ROOT"
echo "Output file: $OUTPUT"

{
    echo "PROJECT: UKE v8"
    echo "DATE: $(date)"
    echo "================================================================================"
    echo "TREE STRUCTURE"
    echo "================================================================================"
    
    # Standard tree or find fallback
    if command -v tree &>/dev/null; then
        tree -a -I '.git|.DS_Store|*.jpg|*.png|node_modules' "$ROOT"
    else
        find . -maxdepth 3 -not -path '*/.*'
    fi

    echo ""
    echo "================================================================================"
    echo "FILE CONTENTS"
    echo "================================================================================"

    # Find relevant text files, excluding git, images, binary, and the output file itself
    find "$ROOT" -type f \
        \( -name "*.sh" -o -name "*.md" -o -name "*.conf" -o -name "*.lua" -o -name "*.yml" -o -name ".*rc" -o -name "config" -o -name ".gitignore" \) \
        -not -path "*/.git/*" \
        -not -name "$OUTPUT" \
        -not -name ".DS_Store" \
        | sort | while read -r file; do
            
        rel_path="${file#$ROOT/}"
        echo ""
        echo "--------------------------------------------------------------------------------"
        echo "FILE: $rel_path"
        echo "--------------------------------------------------------------------------------"
        cat "$file"
    done

} > "$OUTPUT"

echo "Done! File size: $(du -h "$OUTPUT" | cut -f1)"