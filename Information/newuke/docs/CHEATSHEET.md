# UKE v8 - Complete Cheatsheet

**One muscle memory for macOS & Linux - CONFLICT-FREE**

---

## Modifier Hierarchy

| Layer | macOS | Linux | Scope |
|:------|:------|:------|:------|
| **PRIMARY** | Cmd ⌘ | Alt | Window Manager (yabai/Hyprland) |
| **PRIMARY+SHIFT** | Cmd+Shift | Alt+Shift | Move/Manipulate Windows |
| **SECONDARY** | Alt ⌥ | Super | Terminal UI (WezTerm) |
| **TERTIARY** | Alt+Shift | Super+Shift | Resize Windows/Panes |
| **QUATERNARY** | Ctrl | Ctrl | Shell Commands |
| **TMUX** | Ctrl+A | Ctrl+A | Terminal Multiplexer |
| **BUNCH** | Cmd+Ctrl | Alt+Ctrl | Environment Presets |
| **LAUNCHER** | Cmd+Alt | Alt+Super | Quick App Launch |

---

## Workspace Layout

| Space | Purpose | Applications |
|:------|:--------|:-------------|
| **1** | Browser | Safari, Brave, Firefox, Chrome |
| **2** | Notes | Obsidian, Notion |
| **3** | Code | WezTerm, VSCode, Xcode |
| **4** | Catch-all | Unassigned apps |
| **5** | Documents | Preview, PDF Expert, Zathura |
| **6** | Raindrop | Raindrop.io |
| **7** | Media | Spotify |
| **8** | Office | Word, Excel, PowerPoint |
| **9** | Comms | Slack, Discord, Mail, Telegram |
| **10** | AI | Claude, Perplexity |

---

## PRIMARY Layer: Window Manager

### Focus Windows (Vim-style)
| Action | macOS | Linux |
|:-------|:------|:------|
| Focus left | `Cmd + h` | `Alt + h` |
| Focus down | `Cmd + j` | `Alt + j` |
| Focus up | `Cmd + k` | `Alt + k` |
| Focus right | `Cmd + l` | `Alt + l` |

### Move Windows
| Action | macOS | Linux |
|:-------|:------|:------|
| Move/swap left | `Cmd+Shift + h` | `Alt+Shift + h` |
| Move/swap down | `Cmd+Shift + j` | `Alt+Shift + j` |
| Move/swap up | `Cmd+Shift + k` | `Alt+Shift + k` |
| Move/swap right | `Cmd+Shift + l` | `Alt+Shift + l` |

### Window Controls
| Action | macOS | Linux |
|:-------|:------|:------|
| Launch terminal | `Cmd + Return` | `Alt + Return` |
| Toggle fullscreen | `Cmd+Shift + f` | `Alt+Shift + f` |
| Toggle float/tile | `Cmd+Shift + Space` | `Alt+Shift + Space` |
| Gather windows | `Cmd + \`` | `Alt + \`` |
| Toggle split direction | `Cmd+Shift + \` | `Alt+Shift + \` |
| Rotate layout 90° | `Cmd+Shift + r` | - |
| Balance windows | `Cmd+Shift + b` | - |
| Mirror x-axis | `Cmd+Shift + x` | - |
| Mirror y-axis | `Cmd+Shift + y` | - |
| Focus under mouse | `Cmd + Escape` | - |
| Kill window | - | `Alt + q` |

### Workspace Navigation
| Action | macOS | Linux |
|:-------|:------|:------|
| Switch to WS 1-9 | `Cmd + 1-9` | `Alt + 1-9` |
| Switch to WS 10 | `Cmd + 0` | `Alt + 0` |
| Previous workspace | `Cmd + [` | `Alt + [` |
| Next workspace | `Cmd + ]` | `Alt + ]` |

### Move to Workspace
| Action | macOS | Linux |
|:-------|:------|:------|
| Move to WS 1-9 | `Cmd+Shift + 1-9` | `Alt+Shift + 1-9` |
| Move to WS 10 | `Cmd+Shift + 0` | `Alt+Shift + 0` |

---

## SECONDARY Layer: WezTerm Terminal

### Tab Management
| Action | macOS | Linux |
|:-------|:------|:------|
| New tab | `Alt + t` | `Super + t` |
| Close pane/tab | `Alt + w` | `Super + w` |
| Previous tab | `Alt + [` | `Super + [` |
| Next tab | `Alt + ]` | `Super + ]` |
| Tab 1-9 | `Alt + 1-9` | `Super + 1-9` |

### Pane Splitting
| Action | macOS | Linux |
|:-------|:------|:------|
| Split horizontal | `Alt + \` | `Super + \` |
| Split vertical | `Alt + -` | `Super + -` |
| Close pane | `Alt + x` | `Super + x` |
| Toggle zoom | `Alt + z` | `Super + z` |

### Pane Navigation
| Action | macOS | Linux |
|:-------|:------|:------|
| Navigate left | `Alt + h` | `Super + h` |
| Navigate down | `Alt + j` | `Super + j` |
| Navigate up | `Alt + k` | `Super + k` |
| Navigate right | `Alt + l` | `Super + l` |

### Pane Resizing (TERTIARY)
| Action | macOS | Linux |
|:-------|:------|:------|
| Resize left | `Alt+Shift + h` | `Super+Shift + h` |
| Resize down | `Alt+Shift + j` | `Super+Shift + j` |
| Resize up | `Alt+Shift + k` | `Super+Shift + k` |
| Resize right | `Alt+Shift + l` | `Super+Shift + l` |

### Utilities
| Action | macOS | Linux |
|:-------|:------|:------|
| Reload config | `Alt + r` | `Super + r` |
| Search | `Alt + f` | `Super + f` |
| Copy mode | `Alt+Shift + c` | `Super+Shift + c` |
| Quick select | `Alt + Space` | `Super + Space` |
| Command palette | `Alt + p` | `Super + p` |

---

## QUATERNARY Layer: Shell Control

| Action | Key | Description |
|:-------|:----|:------------|
| Interrupt | `Ctrl + c` | Kill current process |
| Suspend | `Ctrl + z` | Background process |
| EOF/Logout | `Ctrl + d` | End of input |
| Clear | `Ctrl + l` | Clear screen |
| History search | `Ctrl + r` | Search command history |
| Beginning of line | `Ctrl + a` | (or tmux prefix) |
| End of line | `Ctrl + e` | |
| Kill word | `Ctrl + w` | Delete word backward |

---

## TMUX Layer (Prefix: Ctrl+A)

| Action | Keys |
|:-------|:-----|
| Split vertical | `Ctrl+A` then `\` |
| Split horizontal | `Ctrl+A` then `-` |
| Navigate panes | `Ctrl+A` then `h/j/k/l` |
| Resize panes | `Ctrl+A` then `H/J/K/L` |
| New window | `Ctrl+A` then `c` |
| Window 1-5 | `Ctrl+A` then `1-5` |
| Reload config | `Ctrl+A` then `r` |
| Detach | `Ctrl+A` then `d` |

---

## Bunches (Environment Presets)

| Key | Name | Apps | Focus WS |
|:----|:-----|:-----|:---------|
| `Mod+Ctrl + 1` | study | Obsidian, Brave, WezTerm, Preview | 2 |
| `Mod+Ctrl + 2` | guitar | Spotify, Brave | 7 |
| `Mod+Ctrl + 3` | coding | WezTerm, Code, Brave | 3 |
| `Mod+Ctrl + 4` | email | Mail, Slack, Brave | 9 |
| `Mod+Ctrl + 5` | reading | Preview, Obsidian | 5 |

---

## Quick App Launchers

| App | macOS | Linux |
|:----|:------|:------|
| Brave | `Cmd+Alt + b` | `Alt+Super + b` |
| Obsidian | `Cmd+Alt + o` | `Alt+Super + o` |
| VS Code | `Cmd+Alt + c` | `Alt+Super + c` |
| Raindrop | `Cmd+Alt + r` | `Alt+Super + r` |
| Spotify | `Cmd+Alt + m` | `Alt+Super + m` |
| Terminal | `Cmd+Alt + t` | `Alt+Super + t` |
| Finder/Files | `Cmd+Alt + f` | `Alt+Super + f` |

---

## UKE CLI Commands

```bash
# Scripts
uke-gather          # Organize windows to workspaces
uke-bunch <name>    # Launch environment preset
uke-bunch list      # List available bunches
uke-doctor          # Health check
uke-sticky toggle   # Toggle sticky window
uke-sticky list     # List sticky windows
uke-scratchpad <n>  # Toggle scratchpad (terminal/notes/music)

# Service management (macOS)
yabai --restart-service
skhd --restart-service
skhd --reload

# Service management (Linux)
hyprctl reload
sudo systemctl restart keyd
```

---

## Quick Reference Card

| I want to... | macOS | Linux |
|:-------------|:------|:------|
| Focus different window | `Cmd + hjkl` | `Alt + hjkl` |
| Focus different pane | `Alt + hjkl` | `Super + hjkl` |
| Switch workspace | `Cmd + 1-9` | `Alt + 1-9` |
| Switch terminal tab | `Alt + 1-9` | `Super + 1-9` |
| New terminal tab | `Alt + t` | `Super + t` |
| Split terminal | `Alt + \ or -` | `Super + \ or -` |
| Resize window | `Alt+Shift + hjkl` | `Super+Shift + hjkl` |
| Launch terminal | `Cmd + Return` | `Alt + Return` |
| Kill process | `Ctrl + c` | `Ctrl + c` |

---

## Conflict Resolution

**The Problem (Solved)**:
`Cmd + hjkl` was bound to both window focus AND terminal pane navigation.

**The Solution**:
- **PRIMARY** (Cmd/Alt) = Global window management
- **SECONDARY** (Alt/Super) = App-internal navigation
- **QUATERNARY** (Ctrl) = Shell commands (never intercepted)

**Why it works**:
- skhd/Hyprland intercept PRIMARY before apps see it
- SECONDARY passes through to WezTerm
- QUATERNARY is sacred for shell signals

---

## Philosophy

- **PRIMARY** = Operating system level (window manager)
- **SECONDARY** = Application level (terminal UI)
- **TERTIARY** = Dimensional changes (resizing)
- **QUATERNARY** = Process control (shell signals)
- **No conflicts** = Each layer has exclusive control
- **Cross-platform** = Same logical keys, different physical modifiers
