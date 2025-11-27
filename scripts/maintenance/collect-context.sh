#!/usr/bin/env bash
set -euo pipefail

# ═══════════════════════════════════════════════════════════
# CONTEXT COLLECTOR
# Generates AI-consumable markdown aggregates from dotfiles
# ═══════════════════════════════════════════════════════════

readonly REPO_ROOT="${DOTFILES_ROOT:-$HOME/dotfiles}"
readonly TIMESTAMP=$(date +%Y%m%d_%H%M%S)
readonly OUTPUT_DIR="${OUTPUT_DIR:-$HOME/dotfiles-context-$TIMESTAMP}"

[[ ! -d "$REPO_ROOT" ]] && { echo "ERROR: $REPO_ROOT not found"; exit 1; }

mkdir -p "$OUTPUT_DIR"
cd "$REPO_ROOT"

# ───────────────────────────────────────────────────────────
# Core Aggregation Function
# ───────────────────────────────────────────────────────────
aggregate() {
    local output_file=$1
    local header=$2
    shift 2
    
    {
        echo "# $header"
        echo "Generated: $(date -Iseconds)"
        echo "Repository: $REPO_ROOT"
        echo ""
    } > "$output_file"
    
    for pattern in "$@"; do
        while IFS= read -r -d '' file; do
            rel_path="${file#$REPO_ROOT/}"
            ext="${file##*.}"
            
            # Language detection
            case "$ext" in
                lua) lang="lua" ;;
                sh) lang="bash" ;;
                conf|config) lang="conf" ;;
                json) lang="json" ;;
                md) lang="markdown" ;;
                zshrc) lang="zsh" ;;
                *) lang="text" ;;
            esac
            
            {
                echo "## \`$rel_path\`"
                echo ""
                echo '```'"$lang"
                cat "$file"
                echo ""
                echo '```'
                echo ""
            } >> "$output_file"
        done < <(find . -path "$pattern" -type f -print0 2>/dev/null | sort -z)
    done
}

# ───────────────────────────────────────────────────────────
# Collection Pipeline
# ───────────────────────────────────────────────────────────

echo "→ Aggregating configurations..."
aggregate "$OUTPUT_DIR/collected_configs.md" "Configuration Files" \
    './zsh/.zshrc' \
    './wezterm/.wezterm.lua' \
    './tmux/.tmux.conf' \
    './nvim/.config/nvim/init.lua' \
    './nvim/.config/nvim/lua/**/*.lua' \
    './hyprland/.config/hypr/hyprland.conf' \
    './yabai/.config/yabai/yabairc' \
    './skhd/.config/skhd/skhdrc' \
    './keyd/default.conf'

echo "→ Aggregating scripts..."
aggregate "$OUTPUT_DIR/collected_scripts.md" "Executable Scripts" \
    './local-bin/.local/bin/*' \
    './workflow/bunches/*.sh' \
    './scripts/**/*.sh'

echo "→ Aggregating documentation..."
aggregate "$OUTPUT_DIR/collected_documentation.md" "Documentation" \
    './README.md' \
    './PHILOSOPHY.md' \
    './CHEAT-SHEET.md' \
    './docs/**/*.md'

# ───────────────────────────────────────────────────────────
# Optional Tarball Creation
# ───────────────────────────────────────────────────────────
if [[ "${CREATE_TARBALL:-0}" == "1" ]]; then
    echo "→ Creating tarball..."
    tar czf "$OUTPUT_DIR.tar.gz" \
        --exclude='.git' \
        --exclude='*.tar.gz' \
        --exclude='.DS_Store' \
        -C "$REPO_ROOT" .
    echo "✓ Archive: $OUTPUT_DIR.tar.gz"
fi

echo ""
echo "✓ Context collected: $OUTPUT_DIR"
ls -lh "$OUTPUT_DIR"
