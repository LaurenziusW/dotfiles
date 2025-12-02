# UKE v6.3.2 - Complete Cheatsheet (Arch Fixed)

**Unified Keyboard Environment - One muscle memory for macOS & Linux**

---

## Modifier Hierarchy

| Layer | macOS | Linux | Scope |
|:------|:------|:------|:------|
| **PRIMARY** | Cmd (⌘) | Alt | Window Manager |
| **PRIMARY+SHIFT** | Cmd+Shift | Alt+Shift | Move Windows |
| **SECONDARY** | Alt (⌥) | Super | Terminal UI (WezTerm) |
| **TERTIARY** | Alt+Shift | Super+Shift | Resize Windows/Panes |
| **QUATERNARY** | Ctrl | Ctrl | Shell Commands |
| **LAUNCHER** | Cmd+Alt | Alt+Super | Quick App Launch & QoL |
| **BUNCH** | Cmd+Ctrl | Alt+Ctrl | Environment Presets |

---

## Quality of Life (Linux-Specific)

| Action | Keybinding | Notes |
|:-------|:-----------|:------|
| **Spotlight (Wofi)** | Alt+Super + Space | App launcher |
| **Zoom In** | Alt+Super + = | 2x zoom (great for small screens) |
| **Zoom Reset** | Alt+Super + - | Back to 1x |
| **Clipboard History** | Alt + v | Like CopyLess on macOS |
| **File Manager** | Alt+Super + f | Opens Thunar |
| **Appearance** | Alt+Super + s | Opens lxappearance |

---

## PRIMARY Layer: Window Management

### Focus (Cmd/Alt + hjkl)

| Action | macOS | Linux |
|:-------|:------|:------|
| Focus left | Cmd + h | Alt + h |
| Focus down | Cmd + j | Alt + j |
| Focus up | Cmd + k | Alt + k |
| Focus right | Cmd + l | Alt + l |

### Move (Cmd+Shift/Alt+Shift + hjkl)

| Action | macOS | Linux |
|:-------|:------|:------|
| Move left | Cmd+Shift + h | Alt+Shift + h |
| Move down | Cmd+Shift + j | Alt+Shift + j |
| Move up | Cmd+Shift + k | Alt+Shift + k |
| Move right | Cmd+Shift + l | Alt+Shift + l |

### Workspace Navigation

| Action | macOS | Linux |
|:-------|:------|:------|
| Workspace 1-9 | Cmd + 1-9 | Alt + 1-9 |
| Workspace 10 | Cmd + 0 | Alt + 0 |
| Previous workspace | Cmd + [ | Alt + [ |
| Next workspace | Cmd + ] | Alt + ] |

### Move to Workspace

| Action | macOS | Linux |
|:-------|:------|:------|
| Move to WS 1-9 | Cmd+Shift + 1-9 | Alt+Shift + 1-9 |
| Move to WS 10 | Cmd+Shift + 0 | Alt+Shift + 0 |

### Window Controls

| Action | macOS | Linux |
|:-------|:------|:------|
| Launch terminal | Cmd + Return | Alt + Return |
| Gather windows | Cmd + ` | Alt + ` |
| Toggle fullscreen | Cmd+Shift + f | Alt+Shift + f |
| Toggle float | Cmd+Shift + Space | Alt+Shift + Space |
| Toggle split | Cmd+Shift + \\ | Alt+Shift + \\ |
| Kill window | - | Alt + q |

---

## TERTIARY Layer: Window Resizing

| Action | macOS | Linux |
|:-------|:------|:------|
| Resize left | Alt+Shift + h | Super+Shift + h |
| Resize down | Alt+Shift + j | Super+Shift + j |
| Resize up | Alt+Shift + k | Super+Shift + k |
| Resize right | Alt+Shift + l | Super+Shift + l |

---

## SECONDARY Layer: WezTerm Terminal

### Tabs (Alt/Super)

| Action | macOS | Linux |
|:-------|:------|:------|
| New tab | Alt + t | Super + t |
| Close pane/tab | Alt + w | Super + w |
| Tab 1-9 | Alt + 1-9 | Super + 1-9 |
| Previous tab | Alt + [ | Super + [ |
| Next tab | Alt + ] | Super + ] |

### Panes

| Action | macOS | Linux |
|:-------|:------|:------|
| Split horizontal | Alt + \\ | Super + \\ |
| Split vertical | Alt + - | Super + - |
| Close pane | Alt + x | Super + x |
| Toggle zoom | Alt + z | Super + z |

### Pane Navigation

| Action | macOS | Linux |
|:-------|:------|:------|
| Navigate left | Alt + h | Super + h |
| Navigate down | Alt + j | Super + j |
| Navigate up | Alt + k | Super + k |
| Navigate right | Alt + l | Super + l |

---

## LAUNCHER Layer: Quick App Launch

| Action | macOS | Linux |
|:-------|:------|:------|
| Brave | Cmd+Alt + b | Alt+Super + b |
| Obsidian | Cmd+Alt + o | Alt+Super + o |
| Code | Cmd+Alt + c | Alt+Super + c |
| Spotify | Cmd+Alt + m | Alt+Super + m |
| WezTerm | Cmd+Alt + t | Alt+Super + t |
| File Manager | - | Alt+Super + f |
| Appearance | - | Alt+Super + s |
| Spotlight/Wofi | - | Alt+Super + Space |

---

## BUNCH Layer: Environment Presets

| Bunch | macOS | Linux |
|:------|:------|:------|
| Study | Cmd+Ctrl + 1 | Alt+Ctrl + F1 |
| Guitar | Cmd+Ctrl + 2 | Alt+Ctrl + F2 |
| Coding | Cmd+Ctrl + 3 | Alt+Ctrl + F3 |
| Email | Cmd+Ctrl + 4 | Alt+Ctrl + F4 |
| Reading | Cmd+Ctrl + 5 | Alt+Ctrl + F5 |

---

## Scratchpads & Sessions

| Action | macOS | Linux |
|:-------|:------|:------|
| Terminal scratchpad | Cmd+Shift + ` | Alt+Shift + ` |
| Notes scratchpad | Cmd+Alt + n | Alt+Super + n |
| Quick save | Cmd+Ctrl + s | Alt+Ctrl + s |
| Quick restore | Cmd+Ctrl+Shift + s | Alt+Ctrl+Shift + s |

---

## Hyper Key (via keyd on Linux / Karabiner on macOS)

**Caps Lock becomes a modifier key**

| Action | Keybinding |
|:-------|:-----------|
| Escape | Caps (tap) |
| Left/Down/Up/Right | Caps + hjkl |
| Home/End | Caps + y/o |
| Page Up/Down | Caps + i/u |
| Select (arrows) | Caps + wasd |
| Word jump | Caps + fg |
| Word select | Caps + qe |
| Delete Forward | Caps + Backspace |
| Toggle Caps Lock | Caps + ' |

---

## Linux: Screenshots & System

| Action | Keybinding |
|:-------|:-----------|
| Screenshot (region) | Print |
| Screenshot (full) | Shift + Print |
| Clipboard history | Alt + v |

---

## System Settings Tools (Arch Linux)

| Tool | Purpose | Command |
|:-----|:--------|:--------|
| pavucontrol | Audio/Mic settings | `pavucontrol` |
| lxappearance | Themes/Appearance | `lxappearance` or Alt+Super+s |
| nm-connection-editor | Network/Wi-Fi | `nm-connection-editor` |
| arandr | Display arrangement | `arandr` |
| thunar | File manager | `thunar` or Alt+Super+f |

---

## CLI Commands

```bash
uke gen              # Generate platform configs
uke reload           # Restart window manager
uke status           # Show current status
uke edit             # Edit registry.yaml
uke-doctor           # Health check

uke-gather           # Organize windows by workspace
uke-bunch study      # Launch study environment
uke-scratchpad term  # Toggle dropdown terminal
uke-session save     # Save window layout
uke-session restore  # Restore window layout
```

---

## Quick Reference Card (Linux)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     UKE QUICK REFERENCE (Arch Linux)                        │
├─────────────────────────────────────────────────────────────────────────────┤
│  FOCUS      Alt + hjkl          MOVE       Alt+Shift + hjkl                 │
│  RESIZE     Super+Shift + hjkl  WORKSPACE  Alt + 1-9,0                      │
│  TERMINAL   Alt + Return        KILL       Alt + q                          │
│  FULLSCREEN Alt+Shift + f       FLOAT      Alt+Shift + Space                │
├─────────────────────────────────────────────────────────────────────────────┤
│  SPOTLIGHT  Alt+Super + Space   ZOOM IN    Alt+Super + =                    │
│  CLIPBOARD  Alt + v             ZOOM OUT   Alt+Super + -                    │
│  FILES      Alt+Super + f       SETTINGS   Alt+Super + s                    │
├─────────────────────────────────────────────────────────────────────────────┤
│  WEZTERM: Super + hjkl (nav) | Super + \\ - (split) | Super + z (zoom)      │
│  CAPS: Tap=Esc | +hjkl=Arrows | +wasd=Select | +fg=WordJump                 │
└─────────────────────────────────────────────────────────────────────────────┘
```
