# UKE v6.1 - Architecture

## Overview

The **Unified Keyboard Environment (UKE)** provides identical keyboard-driven workflows across macOS and Linux through a single source of truth that generates platform-specific configurations.

```
┌─────────────────────────────────────────────────────────────────────┐
│                     config/registry.yaml                            │
│                    (Single Source of Truth)                         │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             │  uke gen
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                        lib/gen.sh                                    │
│                    (Config Generator)                                │
└────────┬───────────────────┼───────────────────────┬────────────────┘
         │                   │                       │
         ▼                   ▼                       ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────────────────┐
│ gen/skhd/skhdrc │ │gen/yabai/yabairc│ │ gen/hyprland/hyprland.conf  │
│    (macOS)      │ │    (macOS)      │ │        (Linux)              │
└────────┬────────┘ └────────┬────────┘ └──────────────┬──────────────┘
         │                   │                         │
         ▼                   ▼                         ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────────────────┐
│  skhd daemon    │ │  yabai daemon   │ │     Hyprland compositor     │
└─────────────────┘ └─────────────────┘ └─────────────────────────────┘
```

## Directory Structure

```
uke/
├── config/
│   └── registry.yaml      # Single source of truth
│
├── lib/
│   ├── core.sh            # Foundation: paths, logging, OS detection
│   ├── wm.sh              # Window manager abstraction layer
│   └── gen.sh             # Config generator
│
├── gen/                   # Generated configs (don't edit!)
│   ├── skhd/skhdrc
│   ├── yabai/yabairc
│   └── hyprland/hyprland.conf
│
├── bin/
│   ├── uke                # Main CLI
│   ├── uke-gather         # Window organization
│   ├── uke-bunch          # Environment presets
│   ├── uke-doctor         # Health check
│   ├── uke-backup         # Backup utility
│   ├── uke-debug          # Diagnostics
│   └── uke-logs           # Live log viewer
│
├── bunches/
│   ├── lib-os-detect.sh   # OS detection helpers
│   ├── bunch-manager.sh   # Bunch management CLI
│   ├── study.sh           # Study environment
│   ├── guitar.sh          # Guitar practice
│   ├── coding.sh          # Development
│   ├── email.sh           # Communication
│   └── reading.sh         # Focused reading
│
├── stow/                  # Dotfiles (symlinked to ~)
│   ├── wezterm/
│   ├── tmux/
│   ├── zsh/
│   ├── nvim/
│   └── karabiner/         # macOS only
│   # Note: keyd (Linux) is managed separately (requires /etc/keyd/)
│
├── templates/
│   └── bunch-template.sh  # Template for new bunches
│
├── scripts/
│   └── install.sh         # Installation script
│
└── docs/
    ├── ARCHITECTURE.md    # This file
    ├── CHEATSHEET.md      # Quick reference
    ├── TROUBLESHOOTING.md # Problem solving
    └── MIGRATION.md       # Upgrade guide
```

## Component Details

### Core Library (`lib/core.sh`)

Foundation for all scripts:

- **Path Resolution**: Automatically finds UKE_ROOT
- **OS Detection**: `is_macos()`, `is_linux()`, `$UKE_OS`
- **Logging**: `log_info`, `log_warn`, `log_error`, `log_fatal`
- **Utilities**: `require_cmd`, `require_file`, `ok`, `fail`

### Window Manager Abstraction (`lib/wm.sh`)

Platform-agnostic window management:

```bash
wm_focus left|right|up|down     # Focus window
wm_move left|right|up|down      # Move window
wm_resize left|right|up|down    # Resize window
wm_workspace 3                   # Switch workspace
wm_move_to_workspace 5           # Move window to workspace
wm_fullscreen                    # Toggle fullscreen
wm_reload                        # Restart services
```

### Config Generator (`lib/gen.sh`)

Transforms `registry.yaml` into platform configs:

- `gen_skhd()` → macOS hotkeys
- `gen_yabai()` → macOS window manager rules
- `gen_hyprland()` → Linux compositor config

### Bunches System

Environment presets that launch apps and focus workspaces:

```bash
uke-bunch study    # Opens Obsidian, Brave, WezTerm → focuses WS 2
uke-bunch coding   # Opens WezTerm, Code, Brave → focuses WS 3
```

Individual scripts in `bunches/` can be customized.

### Gather System

Organizes windows to their assigned workspaces:

```bash
uke-gather         # Move all windows to correct workspaces
# Triggered by: Cmd + ` (macOS) / Alt + ` (Linux)
```

## Modifier Hierarchy

The key to conflict-free operation:

```
┌─────────────────────────────────────────────────────────────────────┐
│  LAYER        │ macOS Key │ Linux Key │ Intercepted By              │
├───────────────┼───────────┼───────────┼─────────────────────────────┤
│  PRIMARY      │ Cmd (⌘)   │ Alt       │ skhd/Hyprland (global)      │
│  SECONDARY    │ Alt (⌥)   │ Super     │ WezTerm (app-level)         │
│  TERTIARY     │ Alt+Shift │ Super+Shft│ Context-aware (WM or app)   │
│  QUATERNARY   │ Ctrl      │ Ctrl      │ Shell (never intercepted)   │
│  TMUX         │ Ctrl+A    │ Ctrl+A    │ tmux (prefix mode)          │
└───────────────┴───────────┴───────────┴─────────────────────────────┘
```

**Why this works:**

1. **PRIMARY** is intercepted by the window manager before apps see it
2. **SECONDARY** is passed through to apps (WezTerm uses it for internal nav)
3. **QUATERNARY** is sacred for shell operations - never override Ctrl+C/Z

## Data Flow

### Editing Workflow

```
User edits registry.yaml
        │
        ▼
uke gen              # Generates platform configs
        │
        ▼
uke reload           # Restarts window manager services
        │
        ▼
Changes take effect
```

### Gather Workflow

```
User presses Cmd + `
        │
        ▼
skhd triggers uke-gather
        │
        ▼
uke-gather queries current workspace
        │
        ▼
For current workspace, find all windows belonging there
        │
        ▼
Move each window to its designated workspace
```

### Bunch Workflow

```
User presses Cmd+Ctrl+1
        │
        ▼
skhd triggers uke-bunch study
        │
        ▼
uke-bunch reads bunch definition
        │
        ▼
Launches: Obsidian, Brave, WezTerm, Preview
        │
        ▼
Focuses workspace 2 (Notes)
```

## Installation

```bash
# Clone or extract to ~/dotfiles/uke
cd ~/dotfiles/uke

# Generate configs
./bin/uke gen

# Stow dotfiles
cd stow && stow wezterm tmux zsh nvim

# Link binaries
mkdir -p ~/.local/bin
ln -sf ~/dotfiles/uke/bin/* ~/.local/bin/

# Link generated configs
ln -sf ~/dotfiles/uke/gen/skhd/skhdrc ~/.config/skhd/skhdrc
ln -sf ~/dotfiles/uke/gen/yabai/yabairc ~/.config/yabai/yabairc

# Restart services
yabai --restart-service
skhd --restart-service
```

## Key Design Decisions

1. **Single source of truth**: All config in registry.yaml
2. **Generated configs**: Never edit gen/ files directly
3. **Stow-based dotfiles**: Easy management and version control
4. **Cross-platform abstraction**: Same scripts work on both OSes
5. **Modular bunches**: Individual scripts for each environment
6. **4px gaps**: Minimal, consistent spacing
7. **Click-to-focus**: No mouse-follows-focus surprises
8. **App name matching**: Uses actual app names, not bundle IDs
