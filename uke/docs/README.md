# UKE v7.0 - Unified Keyboard Environment

**One muscle memory for macOS & Linux** with hardware-agnostic dotfiles.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         VERSION CONTROLLED (Git)                            │
│  ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────────┐   │
│  │  registry.yaml  │────▶│     gen.sh      │────▶│  Generated Configs  │   │
│  │ (preferences)   │     │   (generator)   │     │  (skhdrc, yabairc)  │   │
│  └─────────────────┘     └─────────────────┘     └─────────────────────┘   │
│                                                              │              │
│                                                    source = ...            │
│                                                              ↓              │
└─────────────────────────────────────────────────────────────────────────────┘
                                                               │
┌─────────────────────────────────────────────────────────────────────────────┐
│                         LOCAL ONLY (.gitignored)                            │
│  ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────────┐   │
│  │ machine.profile │────▶│ apply_profile.sh│────▶│   Ghost Files       │   │
│  │  (hardware)     │     │   (generator)   │     │  generated_*.conf   │   │
│  └─────────────────┘     └─────────────────┘     └─────────────────────┘   │
│                                                                             │
│  UKE_OS=arch                                      ~/.config/hypr/           │
│  UKE_GPU=nvidia         →  Computed Settings  →   generated_hardware.conf  │
│  UKE_FORM_FACTOR=laptop    (font size, gaps)     ~/.config/alacritty/      │
│                                                   generated_font.toml      │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Quick Start

```bash
# Clone and install
git clone <your-repo> ~/dotfiles/uke
cd ~/dotfiles/uke
./scripts/install.sh

# Configure hardware (interactive TUI)
uke profile

# Apply changes
uke gen && uke reload
```

## Key Concepts

### 1. Single Source of Truth
- **registry.yaml**: All software preferences, keybindings, app assignments
- **machine.profile**: Hardware-specific settings (local only, not committed)

### 2. Ghost Files
Machine-specific configs that are:
- Generated from `machine.profile`
- Sourced by main configs via `source = ...`
- Never version controlled
- Regenerated on each machine

### 3. Modifier Hierarchy

| Layer | macOS | Linux | Purpose |
|:------|:------|:------|:--------|
| **PRIMARY** | Cmd ⌘ | Alt | Window Manager |
| **+SHIFT** | Cmd+Shift | Alt+Shift | Move Windows |
| **SECONDARY** | Alt ⌥ | Super | Terminal (WezTerm) |
| **TERTIARY** | Alt+Shift | Super+Shift | Resize Windows |
| **QUATERNARY** | Ctrl | Ctrl | Shell (never intercepted) |

## Commands

### Core
```bash
uke gen              # Generate configs from registry.yaml
uke apply            # Generate hardware configs from machine.profile
uke profile          # Interactive hardware settings TUI
uke reload           # Reload window manager
uke status           # Show current status
uke validate         # Validate configuration
```

### Workflow
```bash
# New machine setup
uke profile          # Set hardware (auto-detects)
uke apply            # Generate ghost files
uke gen && uke reload # Apply everything

# After editing registry.yaml
uke gen && uke reload

# After changing hardware (new monitor, etc.)
uke profile          # Update settings
uke apply            # Regenerate ghost files
uke reload           # Apply
```

## Hardware Profile Variables

| Variable | Options | Description |
|----------|---------|-------------|
| `UKE_OS` | `arch`, `macos` | Operating system |
| `UKE_FORM_FACTOR` | `desktop`, `laptop_14`, `laptop_10` | Display size |
| `UKE_MONITORS` | `1`, `2`, `3` | Monitor count |
| `UKE_GPU` | `integrated`, `nvidia`, `amd` | GPU type |
| `UKE_KEYBOARD` | `pc`, `mac` | Keyboard layout |

### Form Factor Effects
| Form Factor | Font Size | Gaps |
|-------------|-----------|------|
| `desktop` | 11pt | 3/6/2 |
| `laptop_14` | 12.5pt | 2/4/2 |
| `laptop_10` | 10pt | 1/2/1 |

## File Structure

```
~/dotfiles/uke/
├── bin/                      # CLI tools
│   └── uke                   # Main command
├── lib/
│   ├── core.sh              # Foundation (cloud path support)
│   ├── wm.sh                # Window manager abstraction
│   └── gen.sh               # Config generator
├── config/
│   └── registry.yaml        # Single source of truth
├── scripts/
│   ├── manage_profile.sh    # Hardware TUI
│   ├── apply_profile.sh     # Ghost file generator
│   └── install.sh           # Installer
├── gen/                     # Generated (committed)
│   ├── skhd/skhdrc
│   ├── yabai/yabairc
│   └── hyprland/hyprland.conf
├── bunches/                 # Environment presets
└── stow/                    # Dotfiles
```

### Ghost Files (Local Only)
```
~/.local/state/uke/
└── machine.profile          # Hardware identity

~/.config/hypr/
└── generated_hardware.conf  # GPU, monitors, gaps

~/.config/alacritty/
└── generated_font.toml      # Font size

~/.config/wezterm/
└── generated_hardware.lua   # All settings as Lua
```

## Cloud Sync Support

Set `UKE_CLOUD_PATH` to use cloud storage for registry.yaml:

```bash
# In ~/.zshrc or similar
export UKE_CLOUD_PATH="$HOME/Dropbox/uke-config"
# or
export UKE_CLOUD_PATH="$HOME/iCloud/uke-config"
```

When set, UKE reads `registry.yaml` from the cloud path instead of `~/dotfiles/uke/config/`.

## Keybindings Quick Reference

### Window Management (PRIMARY)
| Action | macOS | Linux |
|:-------|:------|:------|
| Focus hjkl | Cmd + hjkl | Alt + hjkl |
| Move window | Cmd+Shift + hjkl | Alt+Shift + hjkl |
| Resize | Alt+Shift + hjkl | Super+Shift + hjkl |
| Workspace 1-10 | Cmd + 0-9 | Alt + 0-9 |
| Move to WS | Cmd+Shift + 0-9 | Alt+Shift + 0-9 |

### Bunches
| Bunch | macOS | Linux |
|:------|:------|:------|
| Study | Cmd+Ctrl + 1 | Alt+Ctrl + F1 |
| Coding | Cmd+Ctrl + 3 | Alt+Ctrl + F3 |

### Scratchpads
| Window | macOS | Linux |
|:-------|:------|:------|
| Terminal | Cmd+Alt + ` | Alt + ` |
| Notes | Cmd+Alt + n | Alt+Super + n |

## Troubleshooting

### No hardware profile
```bash
uke profile  # Create one interactively
```

### Ghost files missing
```bash
uke apply    # Generate from machine.profile
```

### Configs out of sync
```bash
uke gen && uke reload
```

### Check everything
```bash
uke status
uke validate
```

---

## Version History

- **v7.0** - Ghost Files architecture, hardware profiles, cloud sync
- **v6.x** - Original UKE with static generation
