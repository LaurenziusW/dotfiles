# UKE - Unified Keyboard Environment v6.2

**One keyboard workflow for macOS and Linux.**

UKE provides identical keyboard-driven window management across platforms through a single configuration that generates platform-specific configs.

## Quick Start

```bash
# Clone/extract to ~/dotfiles/uke
cd ~/dotfiles/uke

# Install
./scripts/install.sh

# Verify
uke-doctor
```

## Features

- **Cross-platform**: Same muscle memory on macOS (yabai/skhd) and Linux (Hyprland)
- **Single source of truth**: Edit `config/registry.yaml`, generate platform configs
- **10 workspaces**: Organized by purpose (Browser, Notes, Code, etc.)
- **Bunches**: Environment presets (study, coding, guitar, email, reading)
- **Scratchpads**: Dropdown/toggle windows (terminal, notes) with hotkeys
- **Sessions**: Save and restore complete window layouts
- **Window Rules**: Fine-grained control over floating, sticky, opacity
- **Multi-Monitor**: Assign workspaces to specific displays
- **Gather**: Organize scattered windows to their designated workspaces
- **Conflict-free**: Layered modifier system prevents keybinding conflicts

## Modifier Hierarchy

| Layer | macOS | Linux | Scope |
|:------|:------|:------|:------|
| PRIMARY | Cmd | Alt | Window Manager |
| SECONDARY | Alt | Super | Terminal (WezTerm) |
| TERTIARY | Alt+Shift | Super+Shift | Resize |
| QUATERNARY | Ctrl | Ctrl | Shell |

## Key Commands

```bash
uke gen              # Generate platform configs
uke reload           # Restart window manager
uke-gather           # Organize windows (Cmd+`)
uke-bunch study      # Launch study environment (Cmd+Ctrl+1)
uke-scratchpad terminal # Toggle dropdown terminal (Cmd+`)
uke-session save work  # Save current layout
uke-session restore work # Restore layout
uke-doctor           # Health check
uke-logs yabai       # Live log viewer
```

## Essential Keybindings

| Action | macOS | Linux |
|:-------|:------|:------|
| Focus window | Cmd + hjkl | Alt + hjkl |
| Move window | Cmd+Shift + hjkl | Alt+Shift + hjkl |
| Switch workspace | Cmd + 1-9 | Alt + 1-9 |
| Launch terminal | Cmd + Return | Alt + Return |
| Scratchpad terminal | Cmd + \` | Alt + \` |
| Scratchpad notes | Cmd+Alt + n | Alt+Super + n |
| Quick save session | Cmd+Ctrl + s | Alt+Ctrl + s |
| WezTerm panes | Alt + hjkl | Super + hjkl |

See `docs/CHEATSHEET.md` for complete reference.

## Structure

```
uke/
├── config/registry.yaml    # Edit this
├── lib/                    # Core scripts
├── gen/                    # Generated (don't edit)
├── bin/                    # CLI commands
├── bunches/                # Environment presets
├── stow/                   # Dotfiles
└── docs/                   # Documentation
```

## Documentation

- [CHEATSHEET.md](docs/CHEATSHEET.md) - Quick reference
- [ARCHITECTURE.md](docs/ARCHITECTURE.md) - System design
- [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) - Problem solving
- [MIGRATION.md](docs/MIGRATION.md) - Upgrade guide

## Requirements

**macOS:**
- yabai
- skhd
- borders (optional, for window borders)

**Linux:**
- Hyprland

**Both:**
- stow
- jq

## License

MIT
