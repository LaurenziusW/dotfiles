# Unified Keyboard Environment - Complete Cheatsheet

**One Reference for macOS (Yabai) & Linux (Hyprland) - CONFLICT-FREE**

---

## 1. Modifier Hierarchy (Updated)

| Layer | macOS Key | Linux Key | Scope |
| :--- | :--- | :--- | :--- |
| **PRIMARY** | **Cmd (⌘)** | **Alt** | Window Manager (yabai/Hyprland), Workspaces |
| **SECONDARY** | **Alt (⌥)** | **Super** | Terminal UI (WezTerm), App Navigation |
| **TERTIARY** | **Alt (⌥) + Shift** | **Super + Shift** | Window Resizing (yabai/Hyprland) |
| **QUATERNARY** | **Ctrl** | **Ctrl** | Shell Commands, Terminal Process Control |
| **TMUX** | **Ctrl + A** | **Ctrl + A** | Terminal Multiplexing |

---

## 2. Workspace Layout (App Assignments)

| Space | Purpose | Applications |
| :--- | :--- | :--- |
| **1** | Browser | Safari, Brave Browser |
| **2** | Notes | Obsidian |
| **3** | Terminal & Code | WezTerm, Code, Xcode |
| **4** | Catch-all | All unassigned apps |
| **5** | PDF & Reading | Preview, PDF Expert |
| **6** | Bookmarks | Raindrop.io |
| **7** | Media | Spotify |
| **8** | Office | Word, Excel, PowerPoint |
| **9** | Comms | Slack, Discord, Mail |
| **10** | Flexible | (No assignments) |

---

## 3. PRIMARY Layer: Window Manager & Workspaces (Cmd / Alt)

### Window Focus (Vim-Style) - **Global Window Navigation**
* `PRIMARY + h` : Focus window left (macOS: yabai)
* `PRIMARY + j` : Focus window down (macOS: yabai)
* `PRIMARY + k` : Focus window up (macOS: yabai)
* `PRIMARY + l` : Focus window right (macOS: yabai)

### Window Movement - **Global Window Rearrangement**
* `PRIMARY + Shift + h` : Move window left
* `PRIMARY + Shift + j` : Move window down
* `PRIMARY + Shift + k` : Move window up
* `PRIMARY + Shift + l` : Move window right

### Window Control
* `PRIMARY + Return` : Launch Terminal (WezTerm)
* `PRIMARY + Shift + f` : Toggle fullscreen
* `PRIMARY + Shift + Space` : Toggle window float/tile
* `PRIMARY +` `  : Gather windows on current space
* `PRIMARY + Shift + \` : Toggle split direction (macOS)
* `PRIMARY + Shift + b` : Balance windows (macOS)
* `PRIMARY + Shift + r` : Rotate layout 90° (macOS)
* `PRIMARY + Escape` : Focus window under mouse (macOS)

### Workspace Navigation
* `PRIMARY + 1-9` : Switch to Workspace 1-9
* `PRIMARY + 0` : Switch to Workspace 10
* `PRIMARY + [` : Previous Workspace (macOS)
* `PRIMARY + ]` : Next Workspace (macOS)

### Move Window to Workspace
* `PRIMARY + Shift + 1-9` : Move window to Workspace 1-9 (and follow)
* `PRIMARY + Shift + 0` : Move window to Workspace 10 (and follow)

---

## 4. SECONDARY Layer: Terminal UI & Apps (Alt / Super)

### WezTerm Terminal UI - **Internal Pane & Tab Management**

**Tab Management:**
* `SECONDARY + t` : New WezTerm Tab
* `SECONDARY + w` : Close WezTerm Pane/Tab (with confirmation)
* `SECONDARY + 1-9` : Switch to WezTerm Tab 1-9

**Pane Splitting:**
* `SECONDARY + \` : Split WezTerm Pane Vertically
* `SECONDARY + -` : Split WezTerm Pane Horizontally

**Pane Navigation (Vim-Style):**
* `SECONDARY + h` : Navigate to WezTerm Pane Left
* `SECONDARY + j` : Navigate to WezTerm Pane Down
* `SECONDARY + k` : Navigate to WezTerm Pane Up
* `SECONDARY + l` : Navigate to WezTerm Pane Right

**Pane Resizing:**
* `SECONDARY + Shift + h` : Resize WezTerm Pane Left
* `SECONDARY + Shift + j` : Resize WezTerm Pane Down
* `SECONDARY + Shift + k` : Resize WezTerm Pane Up
* `SECONDARY + Shift + l` : Resize WezTerm Pane Right

### Obsidian (Remapped to QUATERNARY)
* `QUATERNARY + p` : Open command palette
* `QUATERNARY + o` : Open quick switcher
* `QUATERNARY + w` : Close current pane
* `QUATERNARY + Shift + f` : Global search
* `QUATERNARY + Shift + e` : Toggle source/live preview
* `QUATERNARY + h` : Toggle highlight
* `QUATERNARY + r` : Open search/replace in file

---

## 5. QUATERNARY Layer: Shell & Terminal Control (Ctrl)

### Terminal Process Control - **Shell Commands**
* `QUATERNARY + c` : Interrupt (Kill) process
* `QUATERNARY + z` : Suspend process
* `QUATERNARY + d` : Logout (End of File)
* `QUATERNARY + l` : Clear screen
* `QUATERNARY + r` : Search command history

---

## 6. TERTIARY Layer: Window Resizing (Alt + Shift / Super + Shift)

**macOS (yabai) - Note: This conflicts with WezTerm pane resizing:**
* `TERTIARY + h` : Resize window left (-50px) OR resize WezTerm pane left
* `TERTIARY + l` : Resize window right (+50px) OR resize WezTerm pane right
* `TERTIARY + k` : Resize window up (-50px) OR resize WezTerm pane up
* `TERTIARY + j` : Resize window down (+50px) OR resize WezTerm pane down

> **Note:** When WezTerm has focus, `TERTIARY` (Alt + Shift / Super + Shift) resizes terminal panes. When other apps have focus, it resizes application windows via yabai.

**Linux (Hyprland):**
* `TERTIARY + h/j/k/l` : Resize windows

---

## 7. TMUX Layer (Prefix: QUATERNARY + A)

* `QUATERNARY + A` then `\` : Split pane vertically
* `QUATERNARY + A` then `-` : Split pane horizontally
* `QUATERNARY + A` then `h/j/k/l` : Navigate panes
* `QUATERNARY + A` then `r` : Reload config
* `QUATERNARY + A` then `d` : Detach session

---

## 8. App Launchers & Bunches

### Quick App Launchers (PRIMARY + SECONDARY + Key)
* `PRIMARY + SECONDARY + b` : Launch Brave
* `PRIMARY + SECONDARY + o` : Launch Obsidian
* `PRIMARY + SECONDARY + c` : Launch Code
* `PRIMARY + SECONDARY + r` : Launch Raindrop.io
* `PRIMARY + SECONDARY + m` : Launch Spotify
* `PRIMARY + SECONDARY + t` : Launch Terminal (WezTerm)

### Bunches (PRIMARY + QUATERNARY + Key)
* `PRIMARY + QUATERNARY + 1` : Run `study-math.sh`
* `PRIMARY + QUATERNARY + 2` : Run `guitar-practice.sh`
* `PRIMARY + QUATERNARY + 3` : Run `coding-project.sh`
* `PRIMARY + QUATERNARY + 4` : Run `email-admin.sh`
* `PRIMARY + QUATERNARY + 5` : Run `reading.sh`

---

## 9. Key Conflict Resolution

### The Problem (SOLVED)
Previously, `PRIMARY + h/j/k/l` was bound to **both**:
1. **Global window focus** (yabai via skhd) - switches between application windows
2. **WezTerm pane navigation** - switches between terminal panes

This caused the global binding to override the terminal binding, making terminal navigation impossible.

### The Solution
**Separation of Concerns by Layer:**
* **PRIMARY** = Global window management across all applications (yabai)
* **SECONDARY** = Application-internal navigation (WezTerm panes)
* **QUATERNARY** = Shell commands and process control

**Why SECONDARY Works:**
* skhd only uses `TERTIARY` (Alt + Shift / Super + Shift) for window resizing
* `SECONDARY` alone (Alt / Super without Shift) is completely free for WezTerm
* When WezTerm has focus: `TERTIARY` resizes panes (WezTerm)
* When other apps have focus: `TERTIARY` resizes windows (yabai)

**Example Workflow:**
1. Press `PRIMARY + h` → Switches focus from WezTerm to your browser (global)
2. Inside WezTerm, press `SECONDARY + h` → Switches to the left pane (internal)
3. Inside shell, press `QUATERNARY + c` → Interrupts running process

---

## 10. Mental Model

```
┌─────────────────────────────────────────────────────────────┐
│  LAYER          MODIFIER       SCOPE                        │
├─────────────────────────────────────────────────────────────┤
│  PRIMARY        Cmd/Alt        Operating System Level       │
│                                (Window Manager, Workspaces) │
├─────────────────────────────────────────────────────────────┤
│  SECONDARY      Alt/Super      Application Level            │
│                                (Terminal UI, Pane Nav)      │
├─────────────────────────────────────────────────────────────┤
│  TERTIARY       Alt+Shift      Window/Pane Dimensions       │
│                 Super+Shift    (Resizing - context aware)   │
├─────────────────────────────────────────────────────────────┤
│  QUATERNARY     Ctrl           Shell Process Control        │
│                                (Interrupt, Suspend, etc.)   │
├─────────────────────────────────────────────────────────────┤
│  TMUX           Ctrl+A         Session Multiplexing         │
│                                (Terminal Sessions)          │
└─────────────────────────────────────────────────────────────┘
```

---

## 11. Quick Reference Card

| Action | macOS | Linux |
| :--- | :--- | :--- |
| Focus different app window | `PRIMARY + hjkl` | `PRIMARY + hjkl` |
| Focus different terminal pane | `SECONDARY + hjkl` | `SECONDARY + hjkl` |
| Switch workspace | `PRIMARY + 1-9` | `PRIMARY + 1-9` |
| Switch terminal tab | `SECONDARY + 1-9` | `SECONDARY + 1-9` |
| New terminal tab | `SECONDARY + t` | `SECONDARY + t` |
| Split terminal pane | `SECONDARY + \ or -` | `SECONDARY + \ or -` |
| Resize window/pane | `TERTIARY + hjkl` | `TERTIARY + hjkl` |
| Launch terminal | `PRIMARY + Return` | `PRIMARY + Return` |
| Interrupt process | `QUATERNARY + c` | `QUATERNARY + c` |

---

**Philosophy:** 
- **PRIMARY** = Operating system and window management
- **SECONDARY** = Application internals and terminal UI
- **TERTIARY** = Window and pane resizing (context-aware)
- **QUATERNARY** = Shell process control
- **No conflicts** = Each layer has exclusive control of its domain
- **Cross-platform** = Same logical structure, different physical keys
