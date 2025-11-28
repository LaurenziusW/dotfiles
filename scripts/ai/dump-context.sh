#!/usr/bin/env bash
# Complete project dump for AI context
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UKE_ROOT="${SCRIPT_DIR%/scripts/ai}"
OUTPUT="${1:-$HOME/uke-context-$(date +%Y%m%d-%H%M%S).md}"

exec > "$OUTPUT"

cat << 'HEADER'
# UKE Context Dump

Purpose: Complete project context for AI assistance

## Project Structure

```
HEADER

find "$UKE_ROOT" -type f \( -name "*.sh" -o -name "*.yaml" -o -name "*.lua" -o -name "*.conf" -o -name "*.json" -o -name "*.md" \) 2>/dev/null | \
    grep -v '.git' | sort | sed "s|$UKE_ROOT/||"

cat << 'SECTION'
```

## Registry Configuration

```yaml
SECTION

cat "$UKE_ROOT/config/registry.yaml"

cat << 'SECTION'
```

## Core Libraries

### lib/core.sh
```bash
SECTION

cat "$UKE_ROOT/lib/core.sh"

cat << 'SECTION'
```

### lib/gen.sh
```bash
SECTION

cat "$UKE_ROOT/lib/gen.sh"

cat << 'SECTION'
```

### lib/wm.sh
```bash
SECTION

cat "$UKE_ROOT/lib/wm.sh"

cat << 'SECTION'
```

## CLI Tools

### bin/uke
```bash
SECTION

cat "$UKE_ROOT/bin/uke"

cat << 'SECTION'
```

### bin/uke-bunch
```bash
SECTION

cat "$UKE_ROOT/bin/uke-bunch"

cat << 'SECTION'
```

### bin/uke-gather
```bash
SECTION

cat "$UKE_ROOT/bin/uke-gather"

cat << 'SECTION'
```

### bin/uke-doctor
```bash
SECTION

[[ -f "$UKE_ROOT/bin/uke-doctor" ]] && cat "$UKE_ROOT/bin/uke-doctor" || echo "# Not created yet"

cat << 'SECTION'
```

### bin/uke-backup
```bash
SECTION

[[ -f "$UKE_ROOT/bin/uke-backup" ]] && cat "$UKE_ROOT/bin/uke-backup" || echo "# Not created yet"

cat << 'SECTION'
```

### bin/uke-debug
```bash
SECTION

[[ -f "$UKE_ROOT/bin/uke-debug" ]] && cat "$UKE_ROOT/bin/uke-debug" || echo "# Not created yet"

cat << 'SECTION'
```

## Stow Packages

### wezterm/.wezterm.lua
```lua
SECTION

cat "$UKE_ROOT/stow/wezterm/.wezterm.lua"

cat << 'SECTION'
```

### tmux/.tmux.conf
```
SECTION

cat "$UKE_ROOT/stow/tmux/.tmux.conf"

cat << 'SECTION'
```

### zsh/.zshrc
```bash
SECTION

cat "$UKE_ROOT/stow/zsh/.zshrc"

cat << 'SECTION'
```

### nvim/.config/nvim/init.lua
```lua
SECTION

cat "$UKE_ROOT/stow/nvim/.config/nvim/init.lua"

cat << 'SECTION'
```

## Generated Configs

### skhd/skhdrc
```
SECTION

[[ -f "$UKE_ROOT/gen/skhd/skhdrc" ]] && cat "$UKE_ROOT/gen/skhd/skhdrc" || echo "# Not generated"

cat << 'SECTION'
```

### yabai/yabairc
```bash
SECTION

[[ -f "$UKE_ROOT/gen/yabai/yabairc" ]] && cat "$UKE_ROOT/gen/yabai/yabairc" || echo "# Not generated"

cat << 'SECTION'
```

### hyprland/hyprland.conf
```
SECTION

[[ -f "$UKE_ROOT/gen/hyprland/hyprland.conf" ]] && cat "$UKE_ROOT/gen/hyprland/hyprland.conf" || echo "# Not generated"

cat << 'SECTION'
```

## Install Script

```bash
SECTION

cat "$UKE_ROOT/scripts/install.sh"

echo '```'

exec >&2
echo ""
echo "Context dump saved: $OUTPUT"
echo "File size: $(du -h "$OUTPUT" | cut -f1)"
echo "Copy: cat $OUTPUT | pbcopy"
