# UKE v6.3 - Complete Cheatsheet

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
| **TMUX** | Ctrl+A | Ctrl+A | Terminal Multiplexer |
| **BUNCH** | Cmd+Ctrl | Alt+Ctrl | Environment Presets |
| **LAUNCHER** | Cmd+Alt | Alt+Super | Quick App Launch |

---

## Workspaces

| Space | Purpose | macOS Apps | Linux Apps |
|:------|:--------|:-----------|:-----------|
| **1** | Browser | Safari, Brave | brave, firefox |
| **2** | Notes | Obsidian | obsidian |
| **3** | Code | WezTerm, Code, Xcode | wezterm, code, kitty |
| **4** | Catch-all | Everything else | Everything else |
| **5** | Documents | Preview, PDF Expert | evince, zathura |
| **6** | Raindrop | Raindrop.io | raindrop |
| **7** | Media | Spotify | spotify |
| **8** | Office | Word, Excel, PowerPoint | libreoffice |
| **9** | Comms | Slack, Discord, Mail | slack, discord, thunderbird |
| **10** | AI | Claude, Perplexity | claude |

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
| Rotate layout | Cmd+Shift + r | Alt+Shift + r |
| Balance windows | Cmd+Shift + b | - |
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

### Pane Resizing

| Action | macOS | Linux |
|:-------|:------|:------|
| Resize left | Alt+Shift + h | Super+Shift + h |
| Resize down | Alt+Shift + j | Super+Shift + j |
| Resize up | Alt+Shift + k | Super+Shift + k |
| Resize right | Alt+Shift + l | Super+Shift + l |

---

## QUATERNARY Layer: Shell Control

**Never intercepted by window manager - passed directly to terminal**

| Action | Keybinding |
|:-------|:-----------|
| Interrupt (SIGINT) | Ctrl + c |
| Suspend (SIGTSTP) | Ctrl + z |
| End of input | Ctrl + d |
| Clear screen | Ctrl + l |
| Search history | Ctrl + r |
| Beginning of line | Ctrl + a |
| End of line | Ctrl + e |

---

## LAUNCHER Layer: Quick App Launch

| Action | macOS | Linux |
|:-------|:------|:------|
| Brave | Cmd+Alt + b | Alt+Super + b |
| Obsidian | Cmd+Alt + o | Alt+Super + o |
| Code | Cmd+Alt + c | Alt+Super + c |
| Spotify | Cmd+Alt + m | Alt+Super + m |
| WezTerm | Cmd+Alt + t | Alt+Super + t |
| Raindrop | Cmd+Alt + r | Alt+Super + r |
| File Manager | - | Alt+Super + f |
| App Launcher | - | Alt+Super + Space |

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

## Scratchpads

| Action | macOS | Linux |
|:-------|:------|:------|
| Terminal scratchpad | Cmd+Shift + ` | Alt+Shift + ` |
| Notes scratchpad | Cmd+Alt + n | Alt+Super + n |

---

## Session Management

| Action | macOS | Linux |
|:-------|:------|:------|
| Quick save | Cmd+Ctrl + s | Alt+Ctrl + s |
| Quick restore | Cmd+Ctrl+Shift + s | Alt+Ctrl+Shift + s |

---

## Hyper Key (via keyd on Linux / Karabiner on macOS)

**Caps Lock becomes a modifier key**

| Action | Keybinding |
|:-------|:-----------|
| Escape | Caps (tap) |
| Left | Caps + h |
| Down | Caps + j |
| Up | Caps + k |
| Right | Caps + l |
| Home | Caps + y |
| Page Down | Caps + u |
| Page Up | Caps + i |
| End | Caps + o |
| Delete Forward | Caps + Backspace |
| Select Left | Caps + a |
| Select Down | Caps + s |
| Select Right | Caps + d |
| Select Up | Caps + w |
| Word Left | Caps + f |
| Word Right | Caps + g |
| Word Select Left | Caps + q |
| Word Select Right | Caps + e |
| Toggle Caps Lock | Caps + ' |

---

## Linux-Specific: Screenshots & Clipboard

| Action | Keybinding |
|:-------|:-----------|
| Screenshot (region) | Print |
| Screenshot (full) | Shift + Print |
| Clipboard history | Alt + v |

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
uke-logs hyprland    # View Hyprland logs
```

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     UKE QUICK REFERENCE (Linux)                             │
├─────────────────────────────────────────────────────────────────────────────┤
│  FOCUS      Alt + hjkl          MOVE       Alt+Shift + hjkl                 │
│  RESIZE     Super+Shift + hjkl  WORKSPACE  Alt + 1-9,0                      │
│  TERMINAL   Alt + Return        KILL       Alt + q                          │
│  FULLSCREEN Alt+Shift + f       FLOAT      Alt+Shift + Space                │
│  GATHER     Alt + `             LAUNCHER   Alt+Super + Space                │
├─────────────────────────────────────────────────────────────────────────────┤
│  WEZTERM PANES: Super + hjkl (nav) | Super + \\ - (split) | Super + z (zoom)│
│  WEZTERM TABS:  Super + t (new) | Super + w (close) | Super + 1-9 (switch)  │
├─────────────────────────────────────────────────────────────────────────────┤
│  CAPS + hjkl = Arrows | CAPS + wasd = Select | CAPS + fg = Word Jump        │
└─────────────────────────────────────────────────────────────────────────────┘
```
