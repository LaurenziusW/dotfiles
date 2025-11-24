#!/bin/bash

OUTPUT_FILE="$HOME/full-system-dump.txt"
DOTFILES_DIR="$HOME/dotfiles"

# Header
echo "═══════════════════════════════════════════════════════════" > "$OUTPUT_FILE"
echo "UNIFIED DOTFILES - SYSTEM STATE REPORT" >> "$OUTPUT_FILE"
echo "Generated: $(date)" >> "$OUTPUT_FILE"
echo "OS: $OSTYPE" >> "$OUTPUT_FILE"
echo "═══════════════════════════════════════════════════════════" >> "$OUTPUT_FILE"

echo "🔍 Generating System Report..."

# --- Helpers ---
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then echo "macos"; else echo "linux"; fi
}
OS=$(detect_os)

check_link() {
    local name=$1
    local path=$2
    if [ -L "$path" ] && [[ "$(readlink "$path")" == *"$DOTFILES_DIR"* ]]; then
        echo "✅ LINK OK: $name" >> "$OUTPUT_FILE"
    elif [ -e "$path" ]; then
        echo "⚠️  DRIFT: $name (Physical File)" >> "$OUTPUT_FILE"
    else
        echo "❌ MISSING: $name" >> "$OUTPUT_FILE"
    fi
}

check_exec() {
    if command -v "$1" &> /dev/null; then
        echo "✅ EXEC OK: $1" >> "$OUTPUT_FILE"
    else
        echo "❌ EXEC MISSING: $1" >> "$OUTPUT_FILE"
    fi
}

# --- 1. Verification ---
echo "1️⃣  Verifying Links & Tools..." >> "$OUTPUT_FILE"

# Common
check_link ".zshrc" "$HOME/.zshrc"
check_link ".wezterm.lua" "$HOME/.wezterm.lua"
check_link ".tmux.conf" "$HOME/.tmux.conf"
check_link "nvim" "$HOME/.config/nvim"
check_link "local-bin" "$HOME/.local/bin/gather-current-space"

# OS Specific
if [[ "$OS" == "macos" ]]; then
    check_link "yabai" "$HOME/.config/yabai"
    check_link "skhd" "$HOME/.config/skhd"
    check_exec "yabai"
    check_exec "skhd"
elif [[ "$OS" == "linux" ]]; then
    check_link "hyprland" "$HOME/.config/hypr"
    check_exec "hyprctl"
fi

# Tools
check_exec "gather-current-space"
check_exec "bunch-manager"
check_exec "nvim"

# --- 2. Content Dump ---
echo "" >> "$OUTPUT_FILE"
echo "2️⃣  Configuration Content..." >> "$OUTPUT_FILE"

dump_file() {
    if [ -f "$1" ]; then
        echo "" >> "$OUTPUT_FILE"
        echo "------------------------------------------------" >> "$OUTPUT_FILE"
        echo "FILE: $1" >> "$OUTPUT_FILE"
        echo "------------------------------------------------" >> "$OUTPUT_FILE"
        cat "$1" >> "$OUTPUT_FILE"
    fi
}

dump_file "$HOME/.zshrc"
dump_file "$HOME/.wezterm.lua"
dump_file "$HOME/.tmux.conf"
dump_file "$HOME/.local/bin/gather-current-space"
dump_file "$HOME/.local/bin/lib-os-detect"

if [[ "$OS" == "macos" ]]; then
    dump_file "$HOME/.config/yabai/yabairc"
    dump_file "$HOME/.config/skhd/skhdrc"
elif [[ "$OS" == "linux" ]]; then
    dump_file "$HOME/.config/hypr/hyprland.conf"
fi

echo "✅ Report saved to: $OUTPUT_FILE"
