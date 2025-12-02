# UKE v6.1 - Complete Cheatsheet

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

| Space | Purpose | Apps |
|:------|:--------|:-----|
| **1** | Browser | Safari, Brave Browser |
| **2** | Notes | Obsidian |
| **3** | Code | WezTerm, Code, Xcode |
| **4** | Catch-all | Everything else |
| **5** | Documents | Preview, PDF Expert |
| **6** | Raindrop | Raindrop.io |
| **7** | Media | Spotify |
| **8** | Office | Word, Excel, PowerPoint |
| **9** | Comms | Slack, Discord, Mail, Telegram |
| **10** | AI | Claude, Perplexity |

---

## PRIMARY Layer: Window Management

### Focus (Cmd/Alt + hjkl)
```
PRIMARY + h     Focus window left
PRIMARY + j     Focus window down
PRIMARY + k     Focus window up
PRIMARY + l     Focus window right
```

### Move (Cmd+Shift/Alt+Shift + hjkl)
```
PRIMARY+SHIFT + h     Move window left
PRIMARY+SHIFT + j     Move window down
PRIMARY+SHIFT + k     Move window up
PRIMARY+SHIFT + l     Move window right
```

### Workspace Navigation
```
PRIMARY + 1-9         Switch to workspace 1-9
PRIMARY + 0           Switch to workspace 10
PRIMARY + [           Previous workspace
PRIMARY + ]           Next workspace
```

### Move to Workspace
```
PRIMARY+SHIFT + 1-9   Move window to workspace 1-9 (and follow)
PRIMARY+SHIFT + 0     Move window to workspace 10
```

### Window Controls
```
PRIMARY + Return          Launch terminal (WezTerm)
PRIMARY + `               Gather windows for current space
PRIMARY + Escape          Focus window under mouse
PRIMARY+SHIFT + f         Toggle fullscreen
PRIMARY+SHIFT + Space     Toggle float/tile
PRIMARY+SHIFT + \         Toggle split direction
PRIMARY+SHIFT + r         Rotate layout 90°
PRIMARY+SHIFT + b         Balance windows
PRIMARY+SHIFT + x         Mirror x-axis
PRIMARY+SHIFT + y         Mirror y-axis
PRIMARY+CTRL + s          Insert stack
PRIMARY+CTRL + t          Toggle BSP ↔ Stack layout
```

---

## SECONDARY Layer: WezTerm Terminal

### Tabs (Alt/Super)
```
SECONDARY + t         New tab
SECONDARY + w         Close tab
SECONDARY + 1-9       Switch to tab 1-9
SECONDARY + [         Previous tab
SECONDARY + ]         Next tab
```

### Panes (Alt/Super)
```
SECONDARY + \         Split horizontal
SECONDARY + -         Split vertical
SECONDARY + x         Close pane
SECONDARY + z         Toggle zoom
```

### Pane Navigation (Alt/Super + hjkl)
```
SECONDARY + h         Navigate left
SECONDARY + j         Navigate down
SECONDARY + k         Navigate up
SECONDARY + l         Navigate right
```

### Pane Resizing (Alt+Shift/Super+Shift + hjkl)
```
SECONDARY+SHIFT + h   Resize left
SECONDARY+SHIFT + j   Resize down
SECONDARY+SHIFT + k   Resize up
SECONDARY+SHIFT + l   Resize right
```

---

## TERTIARY Layer: Window Resizing

```
TERTIARY + h          Resize window left
TERTIARY + j          Resize window down
TERTIARY + k          Resize window up
TERTIARY + l          Resize window right
```

> **Note:** When WezTerm has focus, TERTIARY resizes terminal panes. When other apps have focus, it resizes application windows.

---

## QUATERNARY Layer: Shell Control

```
CTRL + c              Interrupt (kill) process
CTRL + z              Suspend process
CTRL + d              Logout (EOF)
CTRL + l              Clear screen
CTRL + r              Search history
CTRL + a              Beginning of line (or tmux prefix)
CTRL + e              End of line
CTRL + w              Kill word backward
```

---

## TMUX Layer (Prefix: Ctrl+A)

```
C-a + \               Split vertical
C-a + -               Split horizontal
C-a + h/j/k/l         Navigate panes
C-a + H/J/K/L         Resize panes
C-a + c               New window
C-a + 1-5             Switch to window 1-5
C-a + r               Reload config
C-a + d               Detach session
```

---

## App Launchers (Cmd+Alt / Alt+Super)

```
LAUNCHER + b          Brave Browser
LAUNCHER + o          Obsidian
LAUNCHER + c          VS Code
LAUNCHER + r          Raindrop.io
LAUNCHER + m          Spotify (music)
LAUNCHER + t          WezTerm (terminal)
```

---

## Bunches (Cmd+Ctrl / Alt+Ctrl)

```
BUNCH + 1             Study (Obsidian, Brave, WezTerm, Preview → WS 2)
BUNCH + 2             Guitar (Spotify, Brave → WS 7)
BUNCH + 3             Coding (WezTerm, Code, Brave → WS 3)
BUNCH + 4             Email (Mail, Slack, Brave → WS 9)
BUNCH + 5             Reading (Preview, Obsidian → WS 5)
```

---

## UKE CLI Commands

```bash
uke gen               Generate configs from registry.yaml
uke reload            Restart window manager
uke status            Show current state
uke validate          Check configurations
uke edit              Edit registry.yaml
uke edit skhd         Edit generated skhd config
uke log tail          View recent logs
uke-bunch list        List available bunches
uke-bunch <name>      Run a bunch
uke-gather            Organize windows to workspaces
uke-doctor            Health check
uke-backup            Backup configs
uke-debug dump        Full diagnostics
uke-logs <component>  Live log viewer (uke|yabai|skhd|hyprland|all)
```

---

## Quick Reference

| Action | macOS | Linux |
|:-------|:------|:------|
| Focus window | `Cmd + hjkl` | `Alt + hjkl` |
| Move window | `Cmd+Shift + hjkl` | `Alt+Shift + hjkl` |
| Resize window | `Alt+Shift + hjkl` | `Super+Shift + hjkl` |
| Switch workspace | `Cmd + 1-9` | `Alt + 1-9` |
| Move to workspace | `Cmd+Shift + 1-9` | `Alt+Shift + 1-9` |
| Launch terminal | `Cmd + Return` | `Alt + Return` |
| Fullscreen | `Cmd+Shift + f` | `Alt+Shift + f` |
| Gather windows | `Cmd + \`` | `Alt + \`` |
| WezTerm pane nav | `Alt + hjkl` | `Super + hjkl` |
| WezTerm split | `Alt + \ / -` | `Super + \ / -` |
| Shell interrupt | `Ctrl + c` | `Ctrl + c` |

---

## Philosophy

- **PRIMARY** = OS-level window management (intercepted before apps)
- **SECONDARY** = App-internal navigation (passed to apps like WezTerm)
- **TERTIARY** = Resizing (context-aware: windows or terminal panes)
- **QUATERNARY** = Shell commands (never override Ctrl+C, Ctrl+Z)
- **No conflicts** = Each layer has exclusive control of its domain
- **Cross-platform** = Same logical keys, different physical modifiers
