#!/usr/bin/env bash
# UKE v6 - Installation Detector & Cleaner
set -uo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'; BLUE='\033[0;34m'; NC='\033[0m'

STOW_TARGETS=(
    "$HOME/.wezterm.lua"
    "$HOME/.tmux.conf"
    "$HOME/.zshrc"
    "$HOME/.config/nvim"
    "$HOME/.config/karabiner/karabiner.json"
)

GEN_TARGETS=(
    "$HOME/.config/skhd/skhdrc"
    "$HOME/.config/yabai/yabairc"
    "$HOME/.config/hypr/hyprland.conf"
)

BIN_TARGETS=(
    "$HOME/.local/bin/uke"
    "$HOME/.local/bin/uke-bunch"
    "$HOME/.local/bin/uke-gather"
    "$HOME/.local/bin/uke-doctor"
    "$HOME/.local/bin/uke-backup"
    "$HOME/.local/bin/uke-debug"
)

FOUND_ISSUES=0

check_path() {
    local path="$1" category="$2"
    if [[ -L "$path" ]]; then
        echo -e "${YELLOW}SYMLINK${NC} [$category] $path -> $(readlink "$path" 2>/dev/null)"
        FOUND_ISSUES=$((FOUND_ISSUES + 1))
    elif [[ -e "$path" ]]; then
        echo -e "${RED}EXISTS${NC}  [$category] $path"
        FOUND_ISSUES=$((FOUND_ISSUES + 1))
    fi
}

detect() {
    echo -e "${BLUE}═══ UKE Installation Detector ═══${NC}\n"
    echo -e "${BLUE}[Stow]${NC}"; for t in "${STOW_TARGETS[@]}"; do check_path "$t" "stow"; done
    echo -e "\n${BLUE}[Generated]${NC}"; for t in "${GEN_TARGETS[@]}"; do check_path "$t" "gen"; done
    echo -e "\n${BLUE}[Binaries]${NC}"; for t in "${BIN_TARGETS[@]}"; do check_path "$t" "bin"; done
    echo ""
    [[ $FOUND_ISSUES -eq 0 ]] && echo -e "${GREEN}✓ Clean slate.${NC}" || echo -e "${YELLOW}Found $FOUND_ISSUES paths. Run '$0 clean' to remove.${NC}"
}

clean() {
    echo -e "${RED}═══ UKE Cleaner ═══${NC}\n"
    local removed=0
    for path in "${STOW_TARGETS[@]}" "${GEN_TARGETS[@]}" "${BIN_TARGETS[@]}"; do
        if [[ -L "$path" ]]; then
            rm "$path" && echo "Removed: $path" && removed=$((removed + 1))
        elif [[ -e "$path" ]]; then
            mv "$path" "${path}.bak" && echo "Backed up: $path" && removed=$((removed + 1))
        fi
    done
    echo -e "\n${GREEN}✓ Cleaned $removed paths.${NC}"
}

case "${1:-detect}" in
    detect) detect ;;
    clean) read -p "Continue? [y/N] " -n1 -r; echo; [[ $REPLY =~ ^[Yy]$ ]] && clean ;;
    *) echo "Usage: $0 [detect|clean]" ;;
esac
