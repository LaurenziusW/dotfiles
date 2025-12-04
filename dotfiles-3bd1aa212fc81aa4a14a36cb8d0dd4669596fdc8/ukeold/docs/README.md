# UKE v6.4 - Complete Documentation

**Unified Keyboard Environment** — One muscle memory for macOS & Linux

---

## Table of Contents

1. [Overview](#overview)
2. [Installation](#installation)
3. [Keybindings Reference](#keybindings)
4. [Features](#features)
5. [Configuration](#configuration)
6. [Troubleshooting](#troubleshooting)
7. [CLI Reference](#cli)

---

## Overview

UKE provides identical keyboard-driven workflows across macOS (yabai/skhd) and Linux (Hyprland). The core principle: **same muscle memory, different platforms**.

### Modifier Hierarchy

| Layer | macOS | Linux | Scope |
|:------|:------|:------|:------|
| **PRIMARY** | Cmd ⌘ | Alt | Window Manager |
| **+SHIFT** | Cmd+Shift | Alt+Shift | Move Windows |
| **SECONDARY** | Alt ⌥ | Super | Terminal (WezTerm) |
| **TERTIARY** | Alt+Shift | Super+Shift | Resize |
| **QUATERNARY** | Ctrl | Ctrl | Shell (never intercepted) |
| **LAUNCHER** | Cmd+Alt | Alt+Super | App Launch + QoL |
| **BUNCH** | Cmd+Ctrl | Alt+Ctrl | Environment Presets |

### Workspaces

| # | Purpose | macOS Apps | Linux Apps |
|:--|:--------|:-----------|:-----------|
| 1 | Browser | Safari, Brave | brave, firefox |
| 2 | Notes | Obsidian | obsidian |
| 3 | Code | WezTerm, Code | wezterm, code |
| 4 | Catch-all | Everything else | Everything else |
| 5 | Documents | Preview | evince, zathura |
| 6 | Raindrop | Raindrop.io | raindrop |
| 7 | Media | Spotify | spotify |
| 8 | Office | Word, Excel | libreoffice |
| 9 | Comms | Slack, Discord, Mail | slack, discord |
| 10 | AI | Claude | claude |

---

## Installation

### Arch Linux

```bash
# 1. Install packages
sudo pacman -S hyprland keyd stow jq wezterm zsh waybar dunst wofi \
               grim slurp wl-clipboard cliphist polkit-kde-agent \
               thunar pavucontrol network-manager-applet lxappearance

# AUR (optional)
yay -S brave-bin obsidian-bin spotify

# 2. Clone UKE
git clone https://github.com/YOUR_USER/uke.git ~/dotfiles/uke

# 3. Install
cd ~/dotfiles/uke
./scripts/install.sh

# 4. Setup keyd (Caps Lock → Hyper)
./scripts/keyd-setup.sh
sudo usermod -aG input $USER  # Log out/in after

# 5. Verify
uke-doctor
```

### macOS

```bash
# 1. Install dependencies
brew install koekeishiya/formulae/yabai koekeishiya/formulae/skhd
brew install FelixKratz/formulae/borders stow jq

# 2. Clone UKE
git clone https://github.com/YOUR_USER/uke.git ~/dotfiles/uke

# 3. Install
cd ~/dotfiles/uke
./scripts/install.sh

# 4. Start services
yabai --start-service
skhd --start-service

# 5. Verify
uke-doctor
```

---

## Keybindings

### Window Focus (PRIMARY)

| Action | macOS | Linux |
|:-------|:------|:------|
| Focus left | Cmd + h | Alt + h |
| Focus down | Cmd + j | Alt + j |
| Focus up | Cmd + k | Alt + k |
| Focus right | Cmd + l | Alt + l |
| Focus recent | Cmd+Shift + ` | Alt+Shift + Escape |

### Window Move (PRIMARY+SHIFT)

| Action | macOS | Linux |
|:-------|:------|:------|
| Move left | Cmd+Shift + h | Alt+Shift + h |
| Move down | Cmd+Shift + j | Alt+Shift + j |
| Move up | Cmd+Shift + k | Alt+Shift + k |
| Move right | Cmd+Shift + l | Alt+Shift + l |

### Window Resize (TERTIARY)

| Action | macOS | Linux |
|:-------|:------|:------|
| Resize left | Alt+Shift + h | Super+Shift + h |
| Resize down | Alt+Shift + j | Super+Shift + j |
| Resize up | Alt+Shift + k | Super+Shift + k |
| Resize right | Alt+Shift + l | Super+Shift + l |

### Workspaces

| Action | macOS | Linux |
|:-------|:------|:------|
| Switch WS 1-9 | Cmd + 1-9 | Alt + 1-9 |
| Switch WS 10 | Cmd + 0 | Alt + 0 |
| Previous WS | Cmd + [ | Alt + [ |
| Next WS | Cmd + ] | Alt + ] |
| Move to WS | Cmd+Shift + # | Alt+Shift + # |

### Window Controls

| Action | macOS | Linux |
|:-------|:------|:------|
| Launch terminal | Cmd + Return | Alt + Return |
| Kill window | — | Alt + q |
| Toggle fullscreen | Cmd+Shift + f | Alt+Shift + f |
| Toggle float | Cmd+Shift + Space | Alt+Shift + Space |
| Toggle split | Cmd+Shift + \\ | Alt+Shift + \\ |
| Gather windows | Cmd + ` | Alt + ` |

### Quality of Life (Linux)

| Action | Keybinding |
|:-------|:-----------|
| Spotlight (Wofi) | Alt+Super + Space |
| Zoom in (2x) | Alt+Super + = |
| Zoom reset | Alt+Super + - |
| Clipboard history | Alt + v |
| File manager | Alt+Super + f |
| Appearance | Alt+Super + s |

### Scratchpads

| Scratchpad | macOS | Linux |
|:-----------|:------|:------|
| Terminal | Cmd+Alt + ` | Alt + ` |
| Notes | Cmd+Alt + n | Alt+Super + n |
| Music | Cmd+Alt + m | Alt+Super + m |

### Smart Launchers

| App | macOS | Linux |
|:----|:------|:------|
| Brave | Cmd+Alt + b | Alt+Super + b |
| Obsidian | Cmd+Alt + o | Alt+Super + o |
| Code | Cmd+Alt + c | Alt+Super + c |
| WezTerm | Cmd+Alt + t | Alt+Super + t |

### Bunches (Environment Presets)

| Bunch | macOS | Linux |
|:------|:------|:------|
| Study | Cmd+Ctrl + 1 | Alt+Ctrl + F1 |
| Guitar | Cmd+Ctrl + 2 | Alt+Ctrl + F2 |
| Coding | Cmd+Ctrl + 3 | Alt+Ctrl + F3 |
| Email | Cmd+Ctrl + 4 | Alt+Ctrl + F4 |
| Reading | Cmd+Ctrl + 5 | Alt+Ctrl + F5 |

### Session Management

| Action | macOS | Linux |
|:-------|:------|:------|
| Quick save | Cmd+Ctrl + s | Alt+Ctrl + s |
| Quick restore | Cmd+Ctrl+Shift + s | Alt+Ctrl+Shift + s |

### WezTerm (SECONDARY Layer)

| Action | macOS | Linux |
|:-------|:------|:------|
| New tab | Alt + t | Super + t |
| Close pane | Alt + w | Super + w |
| Tab 1-9 | Alt + 1-9 | Super + 1-9 |
| Split horiz | Alt + \\ | Super + \\ |
| Split vert | Alt + - | Super + - |
| Nav left | Alt + h | Super + h |
| Nav down | Alt + j | Super + j |
| Nav up | Alt + k | Super + k |
| Nav right | Alt + l | Super + l |
| Zoom pane | Alt + z | Super + z |

### Hyper Key (Caps Lock)

| Action | Keybinding |
|:-------|:-----------|
| Escape | Caps (tap) |
| Arrows | Caps + hjkl |
| Home/End | Caps + y/o |
| Page Up/Down | Caps + i/u |
| Select | Caps + wasd |
| Word jump | Caps + fg |
| Word select | Caps + qe |
| Delete forward | Caps + Backspace |
| Toggle Caps | Caps + ' |

---

## Features

### Scratchpads

Dropdown windows that toggle with a hotkey:

```bash
uke-scratchpad terminal  # Toggle dropdown terminal
uke-scratchpad notes     # Toggle notes window
uke-scratchpad music     # Toggle music player
uke-scratchpad list      # Show available scratchpads
```

**Behavior:**
- If window doesn't exist → launches app
- If window exists but hidden → shows and focuses
- If window has focus → hides it
- Always floats and positions automatically

### Smart Launching

`uke-launch` opens apps AND switches to their workspace:

```bash
uke-launch brave      # Opens Brave → switches to WS 1
uke-launch obsidian   # Opens Obsidian → switches to WS 2
uke-launch code       # Opens VS Code → switches to WS 3
uke-launch list       # Show all apps
```

### Bunches

Pre-configured environments:

```bash
uke-bunch study    # Opens: Obsidian, Brave, WezTerm → WS 2
uke-bunch coding   # Opens: WezTerm, Code, Brave → WS 3
uke-bunch email    # Opens: Mail, Slack → WS 9
```

### Gather

Organizes scattered windows to their designated workspaces:

```bash
uke-gather  # Triggered by Cmd/Alt + `
```

When on WS 1, gathers all browser windows to WS 1.
When on WS 3, gathers all code/terminal windows to WS 3.

### Sessions

Save and restore window layouts:

```bash
uke-session save mysetup     # Save current layout
uke-session restore mysetup  # Restore layout
uke-session list             # List saved sessions
uke-session delete mysetup   # Delete session
```

### Multi-Monitor (Linux)

Configure in `gen/hyprland/hyprland.conf`:

```bash
# Example: laptop + external monitor
monitor=eDP-1,1920x1080@60,0x0,1
monitor=HDMI-A-1,2560x1440@60,1920x0,1

# Assign workspaces to monitors
workspace = 1, monitor:eDP-1
workspace = 6, monitor:HDMI-A-1
```

---

## Configuration

### Directory Structure

```
~/dotfiles/uke/
├── config/registry.yaml     # Source of truth
├── gen/                     # Generated configs (don't edit!)
│   ├── skhd/skhdrc
│   ├── yabai/yabairc
│   └── hyprland/hyprland.conf
├── bin/                     # UKE commands
├── bunches/                 # Environment presets
├── stow/                    # Dotfiles
│   ├── wezterm/
│   ├── tmux/
│   ├── zsh/
│   ├── nvim/
│   └── keyd/               # Linux only
└── lib/
    ├── core.sh             # Foundation
    ├── wm.sh               # WM abstraction
    └── gen.sh              # Config generator
```

### Customization

**Edit generator (persistent):**
```bash
vim ~/dotfiles/uke/lib/gen.sh
uke gen
uke reload
```

**Edit generated config (temporary):**
```bash
vim ~/dotfiles/uke/gen/hyprland/hyprland.conf
hyprctl reload
```

### Colorscheme (Nord)

Colors are unified in `lib/gen.sh`:

```bash
COLORS=(
    [accent]="#88c0d0"
    [bg]="#2e3440"
    [border_active]="88c0d0"
    [border_inactive]="3b4252"
)
```

---

## Troubleshooting

### Quick Diagnostics

```bash
uke-doctor          # Health check
uke-debug dump      # Full report
uke log tail        # View logs
```

### Common Issues

**Keybindings not working:**
```bash
# macOS
pgrep skhd || skhd --start-service
cat ~/.config/skhd/skhdrc | head -20

# Linux
echo $HYPRLAND_INSTANCE_SIGNATURE
hyprctl reload
```

**keyd not working (Linux):**
```bash
systemctl status keyd
groups | grep input  # Must be in input group
sudo keyd reload
```

**Windows not moving to correct workspace:**
```bash
# Get exact app/class name
yabai -m query --windows | jq '.[].app'     # macOS
hyprctl clients -j | jq '.[].class'         # Linux
```

**Scratchpad not appearing:**
```bash
uke-scratchpad terminal  # Test manually
ls -la ~/.local/bin/uke-scratchpad
```

### Reset

```bash
cd ~/dotfiles/uke
./bin/uke gen
uke reload
```

---

## CLI Reference

```bash
# Core
uke gen              # Generate configs
uke reload           # Restart WM
uke status           # Show status
uke edit             # Edit registry.yaml

# Tools
uke-doctor           # Health check
uke-gather           # Organize windows
uke-bunch <name>     # Launch environment
uke-launch <app>     # Smart app launch
uke-scratchpad <n>   # Toggle scratchpad
uke-session <cmd>    # Layout management
uke-debug dump       # Diagnostics
uke-backup           # Backup configs
```

---

## Quick Reference Card

```
┌───────────────────────────────────────────────────────────────────────────────┐
│                      UKE QUICK REFERENCE                                      │
├───────────────────────────────────────────────────────────────────────────────┤
│  LAYER          │ macOS           │ Linux                                     │
│  PRIMARY        │ Cmd             │ Alt              ← Window Manager         │
│  SECONDARY      │ Alt             │ Super            ← WezTerm                 │
│  TERTIARY       │ Alt+Shift       │ Super+Shift      ← Resize                  │
│  QUATERNARY     │ Ctrl            │ Ctrl             ← Shell (untouched)       │
├───────────────────────────────────────────────────────────────────────────────┤
│  FOCUS          │ Cmd + hjkl      │ Alt + hjkl                                │
│  MOVE           │ Cmd+Shift + hjkl│ Alt+Shift + hjkl                          │
│  RESIZE         │ Alt+Shift + hjkl│ Super+Shift + hjkl                        │
│  WORKSPACE      │ Cmd + 1-9,0     │ Alt + 1-9,0                               │
├───────────────────────────────────────────────────────────────────────────────┤
│  WEZTERM        │ Alt + hjkl      │ Super + hjkl     ← pane nav               │
│  SPLIT          │ Alt + \ / -     │ Super + \ / -                             │
│  TABS           │ Alt + t/w/1-9   │ Super + t/w/1-9                           │
├───────────────────────────────────────────────────────────────────────────────┤
│  CAPS + hjkl = Arrows  │  CAPS + wasd = Select  │  CAPS + fg = Word Jump      │
└───────────────────────────────────────────────────────────────────────────────┘
```

---

## Version History

- **v6.4** — Scratchpads, smart launch, multi-monitor, unified colors
- **v6.3.2** — Arch QoL (zoom, clipboard, spotlight)
- **v6.3** — Full Hyprland support, keyd integration
- **v6.1** — Bunches system, gather, sessions
