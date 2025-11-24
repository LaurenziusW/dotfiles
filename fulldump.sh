#!/bin/bash

OUTPUT_FILE="$HOME/full-system-dump.txt"
DOTFILES_DIR="$HOME/dotfiles"

# Header for the output file
echo "═══════════════════════════════════════════════════════════" > "$OUTPUT_FILE"
echo "UNIFIED KEYBOARD ENVIRONMENT - SYSTEM VERIFICATION & DUMP" >> "$OUTPUT_FILE"
echo "Generated: $(date)" >> "$OUTPUT_FILE"
echo "═══════════════════════════════════════════════════════════" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "🔍 Starting System Verification..."

# ==============================================================================
# PART 1: STRUCTURE & SYMLINK CHECK
# ==============================================================================

check_link() {
    local name="$1"
    local path="$2"
    local expected_target="$3"

    printf "%-25s " "Checking $name..."

    if [ ! -e "$path" ]; then
        echo "❌ MISSING ($path)"
        echo "MISSING: $name at $path" >> "$OUTPUT_FILE"
        return
    fi

    if [ -L "$path" ]; then
        # It is a symlink, check where it points
        target=$(readlink "$path")
        if [[ "$target" == *"$expected_target"* ]]; then
            echo "✅ OK (Linked)"
            echo "LINK OK: $path -> $target" >> "$OUTPUT_FILE"
        else
            echo "⚠️  WRONG TARGET ($target)"
            echo "LINK MISMATCH: $path -> $target (Expected *$expected_target*)" >> "$OUTPUT_FILE"
        fi
    else
        echo "⚠️  NOT A LINK (Physical File)"
        echo "NOT LINKED: $path" >> "$OUTPUT_FILE"
    fi
}

echo "1️⃣  Verifying Symlinks..."
check_link "Zsh"             "$HOME/.zshrc"                  "dotfiles/zsh/.zshrc"
check_link "WezTerm"         "$HOME/.wezterm.lua"            "dotfiles/wezterm/.wezterm.lua"
check_link "Tmux"            "$HOME/.tmux.conf"              "dotfiles/tmux/.tmux.conf"
check_link "Neovim"          "$HOME/.config/nvim"            "dotfiles/nvim/.config/nvim"
check_link "Yabai"           "$HOME/.config/yabai"           "dotfiles/yabai/.config/yabai"
check_link "Skhd"            "$HOME/.config/skhd"            "dotfiles/skhd/.config/skhd"
check_link "Local Bin"       "$HOME/.local/bin/gather-current-space" "dotfiles/local-bin/.local/bin/gather-current-space"

echo ""

# ==============================================================================
# PART 2: EXECUTABLE CHECK
# ==============================================================================
echo "2️⃣  Verifying Executables..."

check_exec() {
    local cmd="$1"
    if command -v "$cmd" &> /dev/null; then
        echo "✅ FOUND: $cmd ($(which $cmd))"
        echo "EXEC OK: $cmd found at $(which $cmd)" >> "$OUTPUT_FILE"
    else
        echo "❌ NOT FOUND: $cmd"
        echo "EXEC MISSING: $cmd" >> "$OUTPUT_FILE"
    fi
}

check_exec "gather-current-space"
check_exec "bunch-manager"
check_exec "nvim"
check_exec "yabai"

echo ""

# ==============================================================================
# PART 3: CONTENT DUMP
# ==============================================================================
echo "3️⃣  Gathering Content into $OUTPUT_FILE..."

dump_file() {
    local filepath="$1"
    echo "" >> "$OUTPUT_FILE"
    echo "────────────────────────────────────────────────────────────" >> "$OUTPUT_FILE"
    echo "FILE: $filepath" >> "$OUTPUT_FILE"
    echo "────────────────────────────────────────────────────────────" >> "$OUTPUT_FILE"
    
    if [ -f "$filepath" ]; then
        cat "$filepath" >> "$OUTPUT_FILE"
    else
        echo "[File not found]" >> "$OUTPUT_FILE"
    fi
}

# --- Core Configs ---
dump_file "$HOME/.zshrc"
dump_file "$HOME/.wezterm.lua"
dump_file "$HOME/.tmux.conf"
dump_file "$HOME/.config/yabai/yabairc"
dump_file "$HOME/.config/skhd/skhdrc"

# --- Scripts ---
dump_file "$HOME/.local/bin/gather-current-space"
dump_file "$HOME/.local/bin/bunch-manager"
dump_file "$HOME/.local/bin/lib-os-detect"

# --- Bunches (All .sh files) ---
if [ -d "$HOME/bunches" ]; then
    for bunch in "$HOME/bunches/"*.sh; do
        [ -e "$bunch" ] || continue
        dump_file "$bunch"
    done
fi

# --- Neovim (Main init.lua only to keep it readable) ---
dump_file "$HOME/.config/nvim/init.lua"

echo ""
echo "✅ Verification Complete!"
echo "📄 Full dump saved to: $OUTPUT_FILE"
