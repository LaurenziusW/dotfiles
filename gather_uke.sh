#!/bin/bash

TARGET_DIR="uke"
OUTPUT_FILE="uke_full_context.txt"

# Clear or create the output file
echo "" > "$OUTPUT_FILE"

echo "Collecting data from $TARGET_DIR..."

# --- PART 1: The File Tree ---
echo "================================================================================" >> "$OUTPUT_FILE"
echo "DIRECTORY STRUCTURE" >> "$OUTPUT_FILE"
echo "================================================================================" >> "$OUTPUT_FILE"

# Use 'tree' if installed, otherwise fallback to 'find'
if command -v tree &> /dev/null; then
    tree -a "$TARGET_DIR" >> "$OUTPUT_FILE"
else
    find "$TARGET_DIR" -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g' >> "$OUTPUT_FILE"
fi

echo -e "\n\n" >> "$OUTPUT_FILE"

# --- PART 2: File Contents ---
# Find all files (-type f) inside TARGET_DIR.
# We skip .git, .DS_Store, and common binary extensions.
find "$TARGET_DIR" -type f \
    -not -path '*/.git/*' \
    -not -name '.DS_Store' \
    -not -name '*.png' \
    -not -name '*.jpg' \
    -not -name '*.zip' \
    | while read -r file; do

    echo "Processing: $file"

    echo "################################################################################" >> "$OUTPUT_FILE"
    echo "FILE PATH: $file" >> "$OUTPUT_FILE"
    
    # Check if it is a symlink
    if [ -L "$file" ]; then
        LINK_TARGET=$(readlink -f "$file")
        echo "TYPE: Symlink -> $LINK_TARGET" >> "$OUTPUT_FILE"
    fi

    echo "################################################################################" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"

    # Check if it's a binary file before cat-ing
    if grep -Iq . "$file" || [ ! -s "$file" ]; then
        cat "$file" >> "$OUTPUT_FILE"
    else
        echo "[BINARY FILE CONTENT SKIPPED]" >> "$OUTPUT_FILE"
    fi

    echo -e "\n\n" >> "$OUTPUT_FILE"
done

echo "---------------------------------------------------"
echo "✅ Done! All 'uke' contents saved to: $OUTPUT_FILE"
