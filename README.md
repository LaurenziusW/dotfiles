# UKE v6 - Unified Keyboard Environment

Cross-platform keyboard-driven workflow system.

## Quick Start

```bash
tar -xzf uke-v6.tar.gz
mv uke ~/dotfiles/
cd ~/dotfiles/uke
./scripts/install.sh
uke gen && uke reload
```

## Structure

```
uke/
├── config/registry.yaml   # Source of truth
├── lib/                   # core.sh, gen.sh, wm.sh
├── bin/                   # uke, uke-bunch, uke-gather, uke-doctor, uke-backup, uke-debug
├── gen/                   # Generated configs (don't edit)
├── stow/                  # Stow packages
├── scripts/ai/            # AI helpers
└── docs/                  # ARCHITECTURE, TROUBLESHOOTING, MIGRATION
```

## Workflow

```bash
uke edit            # Edit registry.yaml
uke gen             # Generate platform configs
uke reload          # Apply changes
```

## Modifiers

| Modifier | macOS | Linux | Use |
|----------|-------|-------|-----|
| primary | Cmd | Alt | Focus, workspaces |
| primary_shift | Cmd+Shift | Alt+Shift | Move windows |
| tertiary | Cmd+Alt | Super | Launchers |
| bunch | Cmd+Ctrl | Super+Ctrl | Bunches |
| resize | Alt+Shift | Alt+Shift | Resize |

## CLI

```bash
uke gen             # Generate configs
uke reload          # Reload WM
uke status          # Status
uke edit            # Edit registry
uke validate        # Validate
uke log tail        # View logs

uke-doctor          # Health check
uke-backup          # Backup configs
uke-debug dump      # Diagnostics
```

## AI Helpers

```bash
./scripts/ai/dump-context.sh    # Full project dump
./scripts/ai/prompt.sh debug    # Debug prompt
```

## Deps

- stow, yq, jq
- macOS: yabai, skhd
- Linux: hyprland, keyd
