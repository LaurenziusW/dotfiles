#!/bin/bash
output_file="combined.md"
> "$output_file"  # Clear the output file

for file in *.md; do
    if [[ "$file" != "$output_file" ]]; then  # Exclude the combined file
        echo "# $file" >> "$output_file"      # Add file name as header
        cat "$file" >> "$output_file"         # Append file content
        echo -e "\n\n" >> "$output_file"      # Add space between files
    fi
done

