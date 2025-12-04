#!/usr/bin/env bash
# =============================================================================
# UKE v8 - Collect Project for AI Handoff
# Generates a single file containing all project contents for sharing with AI
# Usage: ./collect-for-ai.sh [output-file]
# =============================================================================
set -eo pipefail

# Colors
C_GREEN=$'\e[32m' C_CYAN=$'\e[36m' C_DIM=$'\e[2m' C_RESET=$'\e[0m'

# Find script directory (UKE root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UKE_ROOT="$SCRIPT_DIR"

OUTPUT_FILE="${1:-uke-full-context.txt}"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "${C_CYAN}╔══════════════════════════════════════╗${C_RESET}"
echo "${C_CYAN}║${C_RESET}  UKE Project Collector              ${C_CYAN}║${C_RESET}"
echo "${C_CYAN}╚══════════════════════════════════════╝${C_RESET}"
echo ""

# Start output file
cat > "$OUTPUT_FILE" << EOF
================================================================================
UKE v8 - COMPLETE PROJECT CONTEXT
Generated: $TIMESTAMP
================================================================================

This file contains the complete contents of the UKE (Unified Keyboard Environment)
project for AI assistance or documentation purposes.

================================================================================
TABLE OF CONTENTS
================================================================================
1. Project Structure
2. Configuration Files
3. Scripts
4. Documentation

EOF

# =============================================================================
# Project Structure
# =============================================================================
echo "${C_GREEN}→${C_RESET} Generating project structure..."

cat >> "$OUTPUT_FILE" << 'EOF'
================================================================================
1. PROJECT STRUCTURE
================================================================================

EOF

# Generate tree structure
if command -v tree &>/dev/null; then
    tree -a -I '.git|.DS_Store|*.pyc|__pycache__|node_modules' "$UKE_ROOT" >> "$OUTPUT_FILE"
else
    # Fallback without tree
    find "$UKE_ROOT" -type f \
        ! -path '*/.git/*' \
        ! -name '.DS_Store' \
        ! -name '*.pyc' \
        | sed "s|$UKE_ROOT|.|g" \
        | sort >> "$OUTPUT_FILE"
fi

echo "" >> "$OUTPUT_FILE"

# =============================================================================
# File Contents
# =============================================================================
echo "${C_GREEN}→${C_RESET} Collecting file contents..."

cat >> "$OUTPUT_FILE" << 'EOF'
================================================================================
2. FILE CONTENTS
================================================================================

EOF

# Define file patterns to include
include_patterns=(
    "*.sh"
    "*.lua"
    "*.conf"
    "*.yaml"
    "*.yml"
    "*.toml"
    "*.md"
    "*.css"
    "*.json"
    ".zshrc"
    ".zprofile"
    ".gitignore"
    "skhdrc"
    "yabairc"
    "zathurarc"
)

# Build find command
find_args=()
for pattern in "${include_patterns[@]}"; do
    find_args+=(-name "$pattern" -o)
done
# Remove last -o
unset 'find_args[-1]'

# Collect files
files=$(find "$UKE_ROOT" \( "${find_args[@]}" \) \
    ! -path '*/.git/*' \
    ! -name '.DS_Store' \
    -type f \
    | sort)

file_count=0
for file in $files; do
    rel_path="${file#$UKE_ROOT/}"
    
    echo "" >> "$OUTPUT_FILE"
    echo "────────────────────────────────────────────────────────────────────────────" >> "$OUTPUT_FILE"
    echo "FILE: $rel_path" >> "$OUTPUT_FILE"
    echo "────────────────────────────────────────────────────────────────────────────" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    # Add file contents
    cat "$file" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    ((file_count++))
    echo "${C_DIM}  Added: $rel_path${C_RESET}"
done

# =============================================================================
# System Information (if running on target system)
# =============================================================================
cat >> "$OUTPUT_FILE" << 'EOF'

================================================================================
3. SYSTEM INFORMATION (Current Host)
================================================================================

EOF

echo "${C_GREEN}→${C_RESET} Collecting system information..."

{
    echo "Hostname: $(hostname 2>/dev/null || echo 'unknown')"
    echo "OS: $(uname -s)"
    echo "Kernel: $(uname -r)"
    echo "Architecture: $(uname -m)"
    echo "Date: $TIMESTAMP"
    echo ""
    
    # Check for installed tools
    echo "=== Installed Tools ==="
    for cmd in yabai skhd hyprctl waybar wezterm tmux nvim zsh stow jq yq git; do
        if command -v "$cmd" &>/dev/null; then
            version=$("$cmd" --version 2>/dev/null | head -1 || echo "installed")
            echo "  ✓ $cmd: $version"
        else
            echo "  ✗ $cmd: not installed"
        fi
    done
    echo ""
    
    # Check for active services
    echo "=== Active Services ==="
    if [[ "$(uname -s)" == "Darwin" ]]; then
        pgrep -l yabai 2>/dev/null && echo "  ✓ yabai running" || echo "  ✗ yabai not running"
        pgrep -l skhd 2>/dev/null && echo "  ✓ skhd running" || echo "  ✗ skhd not running"
    else
        if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
            echo "  ✓ Hyprland running"
        else
            echo "  ✗ Hyprland not running"
        fi
        systemctl is-active keyd 2>/dev/null && echo "  ✓ keyd running" || echo "  ✗ keyd not running"
    fi
} >> "$OUTPUT_FILE"

# =============================================================================
# Summary
# =============================================================================
file_size=$(du -h "$OUTPUT_FILE" | cut -f1)
line_count=$(wc -l < "$OUTPUT_FILE")

echo ""
echo "${C_GREEN}✓${C_RESET} Collection complete!"
echo ""
echo "  Output file: ${C_CYAN}$OUTPUT_FILE${C_RESET}"
echo "  Files collected: $file_count"
echo "  Total lines: $line_count"
echo "  File size: $file_size"
echo ""
echo "${C_DIM}Use this file to share project context with AI assistants.${C_RESET}"
