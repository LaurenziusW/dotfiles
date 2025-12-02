#!/usr/bin/env bash
# ==============================================================================
# UKE Detect - Find all UKE installations and artifacts
# ==============================================================================

echo "╔══════════════════════════════════════╗"
echo "║     UKE Detection Report             ║"
echo "╚══════════════════════════════════════╝"

echo -e "\n[1] Binary Symlinks (~/.local/bin)"
for bin in uke uke-gather uke-bunch uke-doctor uke-backup uke-debug uke-logs; do
    if [[ -L "$HOME/.local/bin/$bin" ]]; then
        target=$(readlink "$HOME/.local/bin/$bin")
        echo "  ✓ $bin → $target"
    elif [[ -f "$HOME/.local/bin/$bin" ]]; then
        echo "  ⚠ $bin (file, not symlink)"
    else
        echo "  ✗ $bin (missing)"
    fi
done

echo -e "\n[2] Config Symlinks (~/.config)"
for cfg in "skhd/skhdrc" "yabai/yabairc" "hypr/hyprland.conf"; do
    path="$HOME/.config/$cfg"
    if [[ -L "$path" ]]; then
        echo "  ✓ $cfg → $(readlink "$path")"
    elif [[ -f "$path" ]]; then
        echo "  ⚠ $cfg (file, not symlink)"
    else
        echo "  - $cfg (not present)"
    fi
done

echo -e "\n[3] Stowed Dotfiles"
for dot in .wezterm.lua .tmux.conf .zshrc; do
    path="$HOME/$dot"
    if [[ -L "$path" ]]; then
        echo "  ✓ $dot → $(readlink "$path")"
    elif [[ -f "$path" ]]; then
        echo "  ⚠ $dot (file, not symlink - may not be UKE)"
    else
        echo "  - $dot (not present)"
    fi
done

if [[ -L "$HOME/.config/nvim" ]]; then
    echo "  ✓ .config/nvim → $(readlink "$HOME/.config/nvim")"
elif [[ -d "$HOME/.config/nvim" ]]; then
    echo "  ⚠ .config/nvim (directory, check if stowed)"
fi

echo -e "\n[4] UKE Directories"
for dir in "$HOME/dotfiles/uke" "$HOME/.local/state/uke" "$HOME/.uke-backups"; do
    if [[ -d "$dir" ]]; then
        count=$(find "$dir" -type f 2>/dev/null | wc -l)
        echo "  ✓ $dir ($count files)"
    else
        echo "  - $dir (not present)"
    fi
done

echo -e "\n[5] Running Services"
pgrep -x yabai &>/dev/null && echo "  ✓ yabai running" || echo "  - yabai not running"
pgrep -x skhd &>/dev/null && echo "  ✓ skhd running" || echo "  - skhd not running"
[[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]] && echo "  ✓ hyprland running"

echo -e "\n[6] Log Files"
[[ -f "$HOME/.local/state/uke/uke.log" ]] && echo "  ✓ UKE log exists" || echo "  - No UKE log"
ls /tmp/yabai_*.err.log &>/dev/null && echo "  ✓ Yabai logs exist" || echo "  - No yabai logs"
ls /tmp/skhd_*.err.log &>/dev/null && echo "  ✓ skhd logs exist" || echo "  - No skhd logs"

echo ""
