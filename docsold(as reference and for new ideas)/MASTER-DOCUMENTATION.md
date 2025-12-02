
# Unified Keyboard Environment - Master Documentation

**Complete Cross-Platform Setup Guide** *macOS (Yabai) & Linux (Hyprland)*

---

## Table of Contents

1.  [System Architecture](#system-architecture)
2.  [Design Philosophy](#design-philosophy)
3.  [Current Features](#current-features)
4.  [Configuration Reference](#configuration-reference)
5.  [Complete Keybinding Reference](#complete-keybinding-reference)
6.  [Bunches System](#bunches-system)
7.  [Cross-Platform Notes](#cross-platform-notes)
8.  [Troubleshooting](#troubleshooting)
9.  [Advanced Topics](#advanced-topics)
10. [Appendix: Package Manifest](#appendix-package-manifest)

---

## System Architecture

### Components

**macOS Stack:**
* **Window Manager**: Yabai (BSP tiling)
* **Hotkey Daemon**: skhd (global shortcuts)
* **Terminal**: WezTerm (cross-platform)
* **Multiplexer**: Tmux (optional)
* **Notes**: Obsidian (cross-platform)

**Linux Stack:**
* **Window Manager**: Hyprland (Wayland compositor)
* **Terminal**: WezTerm (cross-platform)
* **Multiplexer**: Tmux (optional)
* **Notes**: Obsidian (cross-platform)

### Modifier Hierarchy

┌─────────────────────────────────────────────────────────────┐
│ Layer │ macOS Key │ Linux Key │ Scope │
├─────────────────────────────────────────────────────────────┤
│ PRIMARY │ Cmd (⌘) │ Alt │ Window Manager & GUI │
│ SECONDARY │ Ctrl │ Ctrl │ Terminal & Applications │
│ TERTIARY │ Alt (⌥) │ Super │ Window Resizing │
│ Tmux │ Ctrl+A │ Ctrl+A │ Terminal Multiplexing │
└─────────────────────────────────────────────────────────────┘

**Key Principle**: Same physical finger position $\rightarrow$ Same function
* Cmd and Alt are both thumb keys
* Ctrl is always pinky (same on both systems)
* Same muscle memory transfers perfectly

---

## Design Philosophy

### Core Principles

#### 1. Clean Layer Separation

**PRIMARY Layer (Cmd/Alt)**
* Intercepted by window manager BEFORE reaching applications
* Never conflicts with terminal or app shortcuts
* Used for: Window management, terminal tabs/panes, workspace switching

**SECONDARY Layer (Ctrl)**
* Always passes through to applications
* Sacred for terminal operations (Ctrl+C, Ctrl+Z, Ctrl+R, etc.)
* Used for: Shell commands, Obsidian shortcuts, Tmux prefix

**TERTIARY Layer (Alt/Super)**
* Dedicated to window resizing
* Also used for text editing helpers (word movement)

#### 2. Ergonomic Consistency

macOS: Thumb on Cmd $\rightarrow$ Primary actions (window management)
Pinky on Ctrl $\rightarrow$ Terminal operations

Linux: Thumb on Alt $\rightarrow$ Primary actions (window management)
Pinky on Ctrl $\rightarrow$ Terminal operations

RESULT: Same finger, same function, different key label!

#### 3. Terminal Preservation

The terminal layer (Ctrl) is **non-negotiable**:
* Ctrl+C always interrupts processes
* Ctrl+Z always suspends
* Ctrl+R always searches history
* Ctrl+P/N always navigate history
* **Zero conflicts with GUI operations**

#### 4. Cross-Platform by Design

* WezTerm auto-detects OS and adapts
* Tmux config identical on both systems
* Obsidian uses Ctrl on both (manually remapped)
* Bunches system uses OS detection for seamless portability

---

## Current Features

### ✅ Implemented Features

#### Window Management
* **10 organized workspaces** with quick switching
* **BSP tiling** (Binary Space Partitioning)
* **Vim-style navigation** (H/J/K/L everywhere)
* **Floating window support**
* **Fullscreen toggle**
* **Window stacking** (advanced layouts)
* **Automatic balancing**
* **"Follow Focus"** for all app assignments

#### Application Management
* **Smart app assignments** (apps open in designated workspaces)
* **Quick app launchers** (one-key app opening)
* **"Gather" hotkey** to clean up windows on current space
* **Catch-all space** for unassigned apps

#### Terminal Environment
* **WezTerm** with cross-platform config
* **Tmux integration** (Ctrl+A prefix)
* **Split panes** (vertical and horizontal)
* **Tab management**
* All standard terminal shortcuts preserved

#### Productivity Tools
* **Obsidian** remapped to Ctrl (consistent cross-platform)
* **Bunches system** (environment presets)
* **Cross-platform file sync** (via OneDrive)

### 📋 Workspace Organization

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

## Configuration Reference

### macOS Configuration Files

#### ~/.config/yabai/yabairc

```bash
#!/usr/bin/env sh
sudo yabai --load-sa
# ═══════════════════════════════════════════════════════════
# UNIFIED KEYBOARD ENVIRONMENT - Yabai Configuration
# (Using your layout, with "follow focus" and corrected rule order)
# ═══════════════════════════════════════════════════════════

# ───────────────────────────────────────────────────────────
# Layout Configuration
# ───────────────────────────────────────────────────────────
yabai -m config layout bsp
yabai -m config top_padding 4
yabai -m config bottom_padding 4
yabai -m config left_padding 4
yabai -m config right_padding 4
yabai -m config window_gap 4

# ───────────────────────────────────────────────────────────
# Mouse Configuration
# ───────────────────────────────────────────────────────────
yabai -m config mouse_follows_focus off
yabai -m config focus_follows_mouse off
yabai -m config mouse_modifier alt
yabai -m config mouse_action1 move
yabai -m config mouse_action2 resize

# ───────────────────────────────────────────────────────────
# Window Behavior
# ───────────────────────────────────────────────────────────
yabai -m config split_ratio 0.50
yabai -m config auto_balance off
yabai -m config window_placement second_child

# ───────────────────────────────────────────────────────────
# Exclusions - Apps That Should Float
# ───────────────────────────────────────────────────────────
yabai -m rule --add app="^System Settings$" manage=off
yabai -m rule --add app="^Calculator$" manage=off
yabai -m rule --add app="^Finder$" manage=off
yabai -m rule --add app="^App Store$" manage=off

# ═══════════════════════════════════════════════════════════
# WORKSPACE (SPACE) APP ASSIGNMENTS
# ═══════════════════════════════════════════════════════════

# ───────────────────────────────────────────────────────────
# Space 1: Browser & Web
# ───────────────────────────────────────────────────────────
yabai -m rule --add app="^Safari$" space=^1
yabai -m rule --add app="^Brave Browser$" space=^1

# ───────────────────────────────────────────────────────────
# Space 2: Notes & Writing
# ───────────────────────────────────────────────────────────
yabai -m rule --add app="^Obsidian$" space=^2

# ───────────────────────────────────────────────────────────
# Space 3: Terminal & Code Editors
# ───────────────────────────────────────────────────────────
yabai -m rule --add app="^WezTerm$" space=^3
yabai -m rule --add app="^Code$" space=^3
yabai -m rule --add app="^Xcode$" space=^3

# ───────────────────────────────────────────────────────────
# Space 5: PDF & Reading
# ───────────────────────────────────────────────────────────
yabai -m rule --add app="^Preview$" space=^5
yabai -m rule --add app="^PDF Expert$" space=^5

# ───────────────────────────────────────────────────────────
# Space 6: Raindrop
# ───────────────────────────────────────────────────────────
yabai -m rule --add app="^Raindrop.io$" space=^6

# ───────────────────────────────────────────────────────────
# Space 7: Media & Music
# ───────────────────────────────────────────────────────────
yabai -m rule --add app="^Spotify$" space=^7

# ───────────────────────────────────────────────────────────
# Space 8: Office & Documents
# ───────────────────────────────────────────────────────────
yabai -m rule --add app="^Microsoft Word$" space=^8
yabai -m rule --add app="^Microsoft Excel$" space=^8
yabai -m rule --add app="^Microsoft PowerPoint$" space=^8

# ───────────────────────────────────────────────────────────
# Space 9: Communication
# ───────────────────────────────────────────────────────────
yabai -m rule --add app="^Slack$" space=^9
yabai -m rule --add app="^Discord$" space=^9
yabai -m rule --add app="^Mail$" space=^9


# ───────────────────────────────────────────────────────────
# Space 4: Everything else (Catch-all)
# (Spaces 6 & 10 are now free/flexible)
# ───────────────────────────────────────────────────────────
# This rule MUST be last.
It catches all apps that
# did not match any rule above. '^' for focus.
yabai -m rule --add app!="^(Safari|Brave Browser|Obsidian|WezTerm|Code|Xcode|Preview|PDF Expert|Raindrop.io|Spotify|Microsoft Word|Microsoft Excel|Microsoft PowerPoint|Slack|Discord|Mail)$" space=^4

# ───────────────────────────────────────────────────────────
# Space 10: free Space2
# ───────────────────────────────────────────────────────────

echo "yabai: Configuration loaded with workspace assignments"


#### \~/.config/skhd/skhdrc

```bash
# ═══════════════════════════════════════════════════════════
# UNIFIED KEYBOARD ENVIRONMENT - skhd Configuration
# PRIMARY Layer: Cmd (⌘) for Window Management
# ═══════════════════════════════════════════════════════════

# ───────────────────────────────────────────────────────────
# Window Focus Navigation (Vim-Style)
# ───────────────────────────────────────────────────────────
cmd - h : yabai -m window --focus west
cmd - j : yabai -m window --focus south
cmd - k : yabai -m window --focus north
cmd - l : yabai -m window --focus east

# ───────────────────────────────────────────────────────────
# Window Movement (Move windows in direction)
# ───────────────────────────────────────────────────────────
cmd + shift - h : yabai -m window --warp west
cmd + shift - j : yabai -m window --warp south
cmd + shift - k : yabai -m window --warp north
cmd + shift - l : yabai -m window --warp east

# ───────────────────────────────────────────────────────────
# Launch Terminal
# ───────────────────────────────────────────────────────────
cmd - return : open -a WezTerm

# ───────────────────────────────────────────────────────────
# Window Resizing (Alt/Option Layer)
# ───────────────────────────────────────────────────────────
alt + shift - h : yabai -m window --resize left:-50:0
alt + shift - l : yabai -m window --resize right:50:0
alt + shift - k : yabai -m window --resize top:0:-50
alt + shift - j : yabai -m window --resize bottom:0:50

# ───────────────────────────────────────────────────────────
# Window Controls
# ───────────────────────────────────────────────────────────

# Toggle split direction
cmd + shift - 0x2A : yabai -m window --toggle split  # Cmd+Shift+\

# Toggle float/tile
cmd + shift - space : yabai -m window --toggle float

# Fullscreen toggle
cmd + shift - f : yabai -m window --toggle zoom-fullscreen

# ───────────────────────────────────────────────────────────
# Gather (Cleanup) Current Workspace
# ───────────────────────────────────────────────────────────
cmd - 0x32 : ~/OneDrive/workflow/bunches/gather-current-space.sh # Cmd + `

# ───────────────────────────────────────────────────────────
# Advanced Window Layout Controls
# ───────────────────────────────────────────────────────────

# Stack windows (create vertical stack)
cmd + ctrl - s : yabai -m window --insert stack

# Rotate tree 90° clockwise
cmd + shift - r : yabai -m space --rotate 90

# Mirror tree horizontally
cmd + shift - x : yabai -m space --mirror x-axis

# Mirror tree vertically
cmd + shift - y : yabai -m space --mirror y-axis

# Balance space (equalize all window sizes)
cmd + shift - b : yabai -m space --balance

# Toggle layout between BSP and stack
cmd + ctrl - t : yabai -m space --layout $(yabai -m query --spaces --space | jq -r 'if .type == "bsp" then "stack" else "bsp" end')

# ───────────────────────────────────────────────────────────
# Workspace (Space) Navigation - Cmd + Number
# ───────────────────────────────────────────────────────────
cmd - 1 : yabai -m space --focus 1
cmd - 2 : yabai -m space --focus 2
cmd - 3 : yabai -m space --focus 3
cmd - 4 : yabai -m space --focus 4
cmd - 5 : yabai -m space --focus 5
cmd - 6 : yabai -m space --focus 6
cmd - 7 : yabai -m space --focus 7
cmd - 8 : yabai -m space --focus 8
cmd - 9 : yabai -m space --focus 9
cmd - 0x1D : yabai -m space --focus 10 # Cmd + 0
# Previous/Next space
cmd - 0x21 : yabai -m space --focus prev  # Cmd+[
cmd - 0x1E : yabai -m space --focus next  # Cmd+]

# ───────────────────────────────────────────────────────────
# Move Window to Workspace - Cmd + Shift + Number
# (Moves window and follows it)
# ───────────────────────────────────────────────────────────
cmd + shift - 1 : yabai -m window --space 1; yabai -m space --focus 1
cmd + shift - 2 : yabai -m window --space 2; yabai -m space --focus 2
cmd + shift - 3 : yabai -m window --space 3; yabai -m space --focus 3
cmd + shift - 4 : yabai -m window --space 4; yabai -m space --focus 4
cmd + shift - 5 : yabai -m window --space 5; yabai -m space --focus 5
cmd + shift - 6 : yabai -m window --space 6; yabai -m space --focus 6
cmd + shift - 7 : yabai -m window --space 7; yabai -m space --focus 7
cmd + shift - 8 : yabai -m window --space 8; yabai -m space --focus 8
cmd + shift - 9 : yabai -m window --space 9; yabai -m space --focus 9
cmd + shift - 0x1D : yabai -m window --space 10; yabai -m space --focus 10 # Cmd + Shift + 0

# ───────────────────────────────────────────────────────────
# Quick App Launchers - Cmd + Alt + Letter
# ───────────────────────────────────────────────────────────
cmd + alt - b : open -a "Brave"              # Browser
cmd + alt - o : open -a "Obsidian"            # Obsidian (notes)
cmd + alt - c : open -a "Code"  # Code editor
cmd + alt - r : open -a "Raindrop.io"               # Raindrop
cmd + alt - m : open -a "Spotify"             # Music
cmd + alt - t : open -a "WezTerm"             # Terminal

# ───────────────────────────────────────────────────────────
# Bunches - Environment Switching - Cmd + Ctrl + Number
# (Paths updated to new workflow directory)
# ───────────────────────────────────────────────────────────
cmd + ctrl - 1 : ~/OneDrive/workflow/bunches/study-math.sh
cmd + ctrl - 2 : ~/OneDrive/workflow/bunches/guitar-practice.sh
cmd + ctrl - 3 : ~/OneDrive/workflow/bunches/coding-project.sh
cmd + ctrl - 4 : ~/OneDrive/workflow/bunches/email-admin.sh
cmd + ctrl - 5 : ~/OneDrive/workflow/bunches/reading.sh
```

### Linux Configuration

#### \~/.config/hypr/hyprland.conf

```bash
# ═══════════════════════════════════════════════════
# UNIFIED KEYBOARD ENVIRONMENT - Hyprland Config
# ═══════════════════════════════════════════════════

# Define Primary modifier as ALT (ergonomically matches Cmd)
$mainMod = ALT

# ─── Application Launching ───
bind = $mainMod, RETURN, exec, wezterm

# ─── Window Focus (vim-style) ───
bind = $mainMod, H, movefocus, l
bind = $mainMod, J, movefocus, d
bind = $mainMod, K, movefocus, u
bind = $mainMod, L, movefocus, r

# ─── Window Movement ───
bind = $mainMod SHIFT, H, movewindow, l
bind = $mainMod SHIFT, J, movewindow, d
bind = $mainMod SHIFT, K, movewindow, u
bind = $mainMod SHIFT, L, movewindow, r

# ─── Window Resizing (Super for Tertiary layer) ───
bind = SUPER SHIFT, H, resizeactive, -50 0
bind = SUPER SHIFT, L, resizeactive, 50 0
bind = SUPER SHIFT, K, resizeactive, 0 -50
bind = SUPER SHIFT, J, resizeactive, 0 50

# ─── Window Layout ───
bind = $mainMod SHIFT, SPACE, togglefloating
bind = $mainMod, F, fullscreen, 0 # Note: this is a Hyprland fullscreen

# ─── Gather (Cleanup) Current Workspace ───
bind = $mainMod, grave, exec, ~/OneDrive/workflow/bunches/gather-current-space.sh # Alt + `

# ─── Workspace Navigation ───
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# ─── Move Window to Workspace ───
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# ─── Quick App Launchers ───
bind = $mainMod ALT, B, exec, brave
bind = $mainMod ALT, O, exec, obsidian
bind = $mainMod ALT, C, exec, code
bind = $mainMod ALT, R, exec, raindrop
bind = $mainMod ALT, M, exec, spotify
bind = $mainMod ALT, T, exec, wezterm

# ─── Bunches (Environment Switching) ───
bind = $mainMod CTRL, 1, exec, ~/OneDrive/workflow/bunches/study-math.sh
bind = $mainMod CTRL, 2, exec, ~/OneDrive/workflow/bunches/guitar-practice.sh
bind = $mainMod CTRL, 3, exec, ~/OneDrive/workflow/bunches/coding-project.sh
bind = $mainMod CTRL, 4, exec, ~/OneDrive/workflow/bunches/email-admin.sh
bind = $mainMod CTRL, 5, exec, ~/OneDrive/workflow/bunches/reading.sh

# ─── Window Rules (App Assignments) ───
# (These must match the yabai config logic)
windowrulev2 = workspace 1, class:^(Brave-browser|Safari)$
windowrulev2 = workspace 2, class:^(Obsidian)$
windowrulev2 = workspace 3, class:^(WezTerm|Code|Xcode)$
windowrulev2 = workspace 5, class:^(Preview|PDF Expert)$
windowrulev2 = workspace 6, class:^(Raindrop.io)$
windowrulev2 = workspace 7, class:^(Spotify)$
windowrulev2 = workspace 8, class:^(Microsoft Word|Microsoft Excel|Microsoft PowerPoint)$
windowrulev2 = workspace 9, class:^(Slack|Discord|Mail)$

# Catch-all for space 4 (This is harder in Hyprland, often managed by setting default)
# For now, we just leave 4 and 10 flexible.
```

### Cross-Platform Configurations

#### \~/.wezterm.lua (Works on Both Systems)

```lua
-- Unified Cross-Platform Terminal Config
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- OS detection
local function is_darwin()
    return wezterm.target_triple:find("darwin") ~= nil
end

-- PRIMARY modifier: Cmd on macOS, Alt on Linux
local primary_mod = (is_darwin()) and "CMD" or "ALT"

-- All WezTerm hotkeys use the PRIMARY layer
config.keys = {
    -- Tab Management
    { key = "t", mods = primary_mod, action = wezterm.action.SpawnTab("CurrentPaneDomain") },
    { key = "w", mods = primary_mod, action = wezterm.action.CloseCurrentPane({ confirm = true }) },
    
    -- Pane Splitting
    { key = "\\", mods = primary_mod, action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "-", mods = primary_mod, action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    
    -- Pane Navigation (vim-style)
    { key = "h", mods = primary_mod, action = wezterm.action.ActivatePaneDirection("Left") },
    { key = "j", mods = primary_mod, action = wezterm.action.ActivatePaneDirection("Down") },
    { key = "k", mods = primary_mod, action = wezterm.action.ActivatePaneDirection("Up") },
    { key = "l", mods = primary_mod, action = wezterm.action.ActivatePaneDirection("Right") },
}

config.disable_default_key_bindings = false

return config
```

#### \~/.tmux.conf (Identical on Both Systems)

```bash
# Prefix key: Ctrl+A
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# Pane splitting (matches WezTerm!)
bind '\' split-window -h  # vertical split
bind '-' split-window -v  # horizontal split

# Pane navigation (vim-style)
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Enable mouse
set -g mouse on

# Reload config
bind r source-file ~/.tmux.conf \; display "Config reloaded"
```

-----

## Complete Keybinding Reference

### PRIMARY LAYER: Window Manager & GUI

**macOS (Cmd) / Linux (Alt)**

#### Window Navigation

```
H           Focus left window
J           Focus down window
K           Focus up window
L           Focus right window
```

#### Window Movement

```
Shift + H   Move window left
Shift + J   Move window down
Shift + K   Move window up
Shift + L   Move window right
```

#### Window Control

```
Return      Launch terminal (WezTerm)
Shift + F   Toggle fullscreen (Yabai zoom)
Shift + Space    Toggle float/tile
` (Backtick) Gather windows on current space
Shift + \   Toggle split direction (macOS only)
Shift + B   Balance windows (macOS only)
Shift + R   Rotate layout 90° (macOS only)
Shift + X   Mirror horizontally (macOS only)
Shift + Y   Mirror vertically (macOS only)
```

#### Workspace Management

```
1-9, 0      Switch to workspace 1-10
Shift + 1-9, 0 Move window to workspace (and follow)
[           Previous workspace (macOS)
]           Next workspace (macOS)
```

#### Quick App Launchers

```
Alt + B     Browser (Brave)
Alt + O     Obsidian
Alt + C     Code editor (Code)
Alt + R     Raindrop.io
Alt + M     Music (Spotify)
Alt + T     Terminal (WezTerm)
```

#### Bunches (Environment Presets)

```
Ctrl + 1    Study Math
Ctrl + 2    Guitar Practice
Ctrl + 3    Coding Project
Ctrl + 4    Email & Admin
Ctrl + 5    Reading
```

### SECONDARY LAYER: Terminal & Applications (Ctrl)

#### Process Control

```
Ctrl + C    Interrupt/kill process
Ctrl + Z    Suspend process
Ctrl + D    EOF / Exit shell
```

#### Line Navigation

```
Ctrl + A    Move to line start
Ctrl + E    Move to line end
Ctrl + B    Move backward one character
Ctrl + F    Move forward one character
```

#### Line Editing

```
Ctrl + U    Delete from cursor to line start
Ctrl + K    Delete from cursor to line end
Ctrl + W    Delete word backward
Ctrl + Y    Paste deleted text
Ctrl + T    Transpose characters
```

#### History

```
Ctrl + R    Reverse history search
Ctrl + P    Previous command
Ctrl + N    Next command
```

#### Display

```
Ctrl + L    Clear screen
```

#### Obsidian (After Remap)

```
Ctrl + P    Command palette
Ctrl + O    Quick switcher
Ctrl + N    New note
Ctrl + W    Close pane
Ctrl + E    Toggle edit/preview
Ctrl + H    Toggle highlight
Ctrl + L    Inline math (LaTeX)
Ctrl + R    Search/replace
Ctrl + Shift + F    Global search
```

### TMUX LAYER: Ctrl+A Prefix

```
Ctrl + A, Ctrl + A    Send literal Ctrl+A
Ctrl + A, \           Split vertical
Ctrl + A, -           Split horizontal
Ctrl + A, H/J/K/L     Navigate panes
Ctrl + A, C           New window
Ctrl + A, N           Next window
Ctrl + A, P           Previous window
Ctrl + A, R           Reload config
```

### TERTIARY LAYER: Window Resizing

**macOS (Alt+Shift) / Linux (Super+Shift)**

```
H           Resize left
J           Resize down
K           Resize up
L           Resize right
```

-----

## Bunches System

### What Are Bunches?

Bunches are **context-based environment presets** that automatically:

  * Switch to relevant workspaces
  * Launch specific applications
  * Open project directories
  * Start tmux sessions
  * Configure your complete working environment

### Architecture

```
~/OneDrive/workflow/bunches/
├── lib-os-detect.sh          # OS detection library
├── bunch-manager.sh          # Management CLI
├── gather-current-space.sh   # Window cleanup script
├── templates/
│   └── bunch-template.sh     # Template for new bunches
├── study-math.sh             # Example bunches
├── guitar-practice.sh
├── coding-project.sh
├── email-admin.sh
└── reading.sh
```

### Cross-Platform Design

Bunches automatically detect the OS and use appropriate commands:

```bash
#!/usr/bin/env bash
source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

# These functions work on both macOS and Linux:
launch_app "browser"      # Brave on macOS, brave on Linux
launch_app "notes"        # Obsidian on both
$WM_FOCUS_SPACE 2         # yabai on macOS, hyprctl on Linux
```

### Available Helper Functions

```bash
# Launch applications
launch_app "app_key"           # Cross-platform app launcher

# Window manager commands
$WM_FOCUS_SPACE <number>       # Switch workspace
$WM_SEND_WINDOW <number>       # Move window to workspace

# OS detection
detect_os                      # Returns "macos" or "linux"
get_app_command "app_key"      # Get OS-specific app name
```

### App Keys

```
browser      → Brave (macOS) / brave (Linux)
notes        → Obsidian (both)
terminal     → WezTerm (both)
code         → Code (both)
music        → Spotify (both)
pdf          → Preview (macOS) / Evince (Linux)
office-word  → MS Word (macOS) / LibreOffice (Linux)
```

### Creating Custom Bunches

```bash
# Using bunch manager
~/OneDrive/workflow/bunches/bunch-manager.sh create my-context

# Edit the new bunch
$EDITOR ~/OneDrive/workflow/bunches/my-context.sh

# Test it
~/OneDrive/workflow/bunches/my-context.sh

# Add keyboard shortcut (in skhd/hyprland config)
```

### Example Bunch Structure

```bash
#!/usr/bin/env bash
source "$(dirname "$0")/lib-os-detect.sh"
setup_os_commands

echo "🚀 Starting: My Custom Environment"

# Switch to workspace and launch apps
$WM_FOCUS_SPACE 2
launch_app "notes"
sleep 1

$WM_FOCUS_SPACE 3
launch_app "terminal"
sleep 1

# Optional: cd to project, start tmux
cd ~/Projects/my-project
tmux new-session -d -s my-work

echo "✅ Environment ready!"
```

-----

## Cross-Platform Notes

### File Portability

**Same on Both Systems:**

  * `~/.wezterm.lua` - Auto-detects OS
  * `~/.tmux.conf` - Identical
  * `~/OneDrive/workflow/bunches/*` - OS detection built-in
  * Obsidian `hotkeys.json` - Uses Ctrl on both

**Platform-Specific:**

  * macOS: `~/.config/yabai/yabairc`, `~/.config/skhd/skhdrc`
  * Linux: `~/.config/hypr/hyprland.conf`

### Modifier Key Translation

```
┌──────────────────────────────────────────────────┐
│ Function        │ macOS    │ Linux               │
├──────────────────────────────────────────────────┤
│ Window Manager  │ Cmd      │ Alt                 │
│ Terminal/Apps   │ Ctrl     │ Ctrl                │
│ Resizing        │ Alt      │ Super               │
│ Physical Pos.   │ Thumb    │ Thumb (for primary) │
└──────────────────────────────────────────────────┘

Result: Same finger → Same function → Different key label
```

### Migration Checklist

Moving from macOS to Linux (or vice versa):

**Step 1: Sync Common Configs**

```bash
# These work on both systems without modification:
~/.wezterm.lua
~/.tmux.conf
~/OneDrive/workflow/bunches/
~/.obsidian/hotkeys.json  # (if using Ctrl remap)
```

**Step 2: Install Platform Tools**

```bash
# macOS
brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd

# Linux
sudo pacman -S hyprland
```

**Step 3: Install Platform Config**

```bash
# macOS
~/.config/yabai/yabairc
~/.config/skhd/skhdrc

# Linux
~/.config/hypr/hyprland.conf
```

**Step 4: Test Everything**

  * Window navigation (H/J/K/L)
  * Workspace switching (1-9, 0)
  * Terminal operations (Ctrl+C, Ctrl+R, etc.)
  * App launches
  * Bunches

-----

## Troubleshooting

### macOS Specific

#### Services Not Running

```bash
# Check if running
pgrep -fl yabai
pgrep -fl skhd

# View logs
tail -20 /tmp/yabai_*.err.log
tail -20 /tmp/skhd_*.err.log

# Restart services
yabai --restart-service
skhd --restart-service
```

#### Permissions Issues

```bash
# Open accessibility settings
open "x-apple.systemsettings:com.apple.preference.security?Privacy_Accessibility"

# Ensure these are enabled:
# - /opt/homebrew/bin/yabai
# - /opt/homebrew/bin/skhd
# - WezTerm.app
```

#### Hotkeys Not Working

```bash
# Test if skhd sees keypresses
skhd --observe

# Manually test yabai command
yabai -m window --focus west
```

#### Windows Not Tiling

```bash
# Check BSP mode
yabai -m query --spaces --display | grep '"type"'

# Check if window is managed
yabai -m query --windows --window | grep managed
```

### Linux Specific

#### Hyprland Not Starting

```bash
# Check logs
journalctl --user -u hyprland

# Or if starting from TTY
cat /tmp/hypr/$(ls -t /tmp/hypr/ | head -n 1)/hyprland.log
```

#### Window Rules Not Working

```bash
# Get window class
hyprctl clients | grep class

# Test rule manually
hyprctl dispatch movetoworkspace 2
```

### Universal Issues

#### Terminal Shortcuts Not Working

```bash
# Verify Ctrl is not intercepted
# In terminal: Ctrl+C should always work
# If not, check WM config for Ctrl conflicts
```

#### Bunches Not Starting

```bash
# Test manually
bash ~/OneDrive/workflow/bunches/study-math.sh

# Enable debug mode
bash -x ~/OneDrive/workflow/bunches/study-math.sh

# Common fixes:
# 1. Add longer sleep delays between app launches
# 2. Verify app names are correct
# 3. Check OneDrive folder path
```

#### Obsidian Shortcuts Wrong Key

```bash
# Verify remap was applied
grep -c '"Mod"' ~/.obsidian/hotkeys.json  # Should be 0
grep -c '"Ctrl"' ~/.obsidian/hotkeys.json # Should be positive

# Re-run remap script if needed
```

-----

## Advanced Topics

### Neovim Integration

Use Ctrl for window navigation to match the system:

```lua
-- ~/.config/nvim/init.lua
vim.g.mapleader = " "

-- Window navigation (matches WM keybinds)
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
```

### VS Code Integration

Remap shortcuts to match Obsidian (Ctrl-based):

```json
// ~/.config/Code/User/keybindings.json
[
  { "key": "ctrl+p", "command": "workbench.action.quickOpen" },
  { "key": "ctrl+shift+p", "command": "workbench.action.showCommands" },
  { "key": "ctrl+w", "command": "workbench.action.closeActiveEditor" }
]
```

### Status Bar (macOS)

SketchyBar for workspace indicators:

```bash
brew install sketchybar
# Configure in ~/.config/sketchybar/
```

### Status Bar (Linux)

Waybar for Hyprland:

```bash
sudo pacman -S waybar
# Configure in ~/.config/waybar/
```

### Application Launcher (Linux)

Wofi as dmenu replacement:

```bash
sudo pacman -S wofi

# Add to hyprland.conf:
bind = $mainMod, D, exec, wofi --show drun
```

### Dotfiles Management

Use GNU Stow for symlink management:

```bash
# Structure:
~/dotfiles/
├── wezterm/.wezterm.lua
├── tmux/.tmux.conf
├── yabai/.config/yabai/yabairc
├── skhd/.config/skhd/skhdrc
└── hyprland/.config/hypr/hyprland.conf

# Deploy:
cd ~/dotfiles
stow wezterm tmux
# On macOS: stow yabai skhd
# On Linux: stow hyprland
```

### Remote SSH Sessions

The system works perfectly over SSH:

  * Ctrl layer passes through
  * Tmux prefix (Ctrl+A) works in remote sessions
  * Use `Ctrl+A, A` to send prefix to nested tmux

-----

## Philosophy & Vision

### Why This Matters

The keyboard is your **primary interface**. It should be:

1.  **Consistent** - Same action $\rightarrow$ Same keys $\rightarrow$ Same result
2.  **Conflict-Free** - No layer collisions
3.  **Ergonomic** - Common actions on easy-to-reach keys
4.  **Portable** - Works identically across platforms

### The Terminal is Sacred

Terminal shortcuts have existed for **40+ years** across Unix systems:

  * Ctrl+C, Ctrl+Z, Ctrl+R, Ctrl+P are **non-negotiable**
  * Any "unified" system that breaks these is fundamentally broken
  * Our approach: PRIMARY layer (Cmd/Alt) **never** conflicts with SECONDARY (Ctrl)

### Ergonomics Over Conventions

We prioritize **physical comfort** and **muscle memory**:

  * Cmd (macOS) and Alt (Linux) are both **thumb keys**
  * Same finger position = Same function
  * Conventions can be adapted; ergonomics shouldn't be compromised

### Zero Compromise

  * ✅ Full window management power
  * ✅ Terminal operations always work
  * ✅ Cross-platform portability
  * ✅ Professional-grade tools
  * ✅ No features sacrificed

-----

## Quick Reference

### Most Common Shortcuts

**Workflow:**

```
PRIMARY + Return     Launch terminal
PRIMARY + `          Gather windows
PRIMARY + T          New terminal tab
PRIMARY + \ or -     Split terminal
PRIMARY + H/J/K/L    Navigate everything
PRIMARY + Shift + F  Fullscreen
PRIMARY + 1-9, 0     Switch workspace
```

**Terminal:**

```
Ctrl + C             Kill process
Ctrl + L             Clear screen
Ctrl + R             Search history
Ctrl + A/E           Line start/end
```

**Bunches:**

```
PRIMARY + Ctrl + 1   Study environment
PRIMARY + Ctrl + 2   Guitar practice
PRIMARY + Ctrl + 3   Coding environment
```

*(PRIMARY = Cmd on macOS, Alt on Linux)*

-----

## Version History

**v2.1** - Refinement (2025-11-14)

  * Expanded to **10-workspace system**
  * Fixed catch-all rule and implemented "follow focus"
  * Added `gather-current-space.sh` script and hotkey
  * Consolidated app assignments (e.g., Code + Terminal on Space 3)
  * Migrated bunches to `~/OneDrive/workflow/`

**v2.0** - Enhanced Edition (2025-11-14)

  * Added 9-workspace system
  * Implemented bunches for context switching
  * Added fullscreen toggle and advanced tiling
  * Smart app-to-workspace assignments
  * Cross-platform bunches system

**v1.0** - Initial Release (2025-11-13)

  * Yabai/skhd setup for macOS
  * WezTerm cross-platform config
  * Tmux integration
  * Obsidian Ctrl remap
  * Clean modifier layer separation

-----

## Appendix: Package Manifest

This section, adapted from `PACKAGE-MANIFEST.md`, details all the files that make up the Unified Keyboard Environment package.

### 📦 Package Structure

#### 🔧 **Installation Scripts**

```
install-enhancements.sh    - Automated macOS installer
setup-bunches.sh           - Bunches system setup
collect-for-ai.sh          - Config collector for AI handoff
```

#### ⚙️ **Configuration Files**

```
yabairc                   - Yabai window manager (macOS)
skhdrc                    - skhd hotkey daemon (macOS)
wezterm.lua               - WezTerm terminal (cross-platform)
tmux.conf                 - Tmux multiplexer (cross-platform)
```

#### 📚 **Core Documentation (The Essential 4)**

```
MASTER-DOCUMENTATION.md     - Complete technical reference (This file)
COMPLETE-CHEATSHEET.md      - All shortcuts, both systems
UNIFIED-SETUP-GUIDE.md      - Installation instructions
AI-HANDOFF-GUIDE.md         - AI assistance guide
```

-----

### 🎯 What Each File Does

#### Installation & Setup

|**File**|**Purpose**|**When to Use**|
|---|---|---|
|**install-enhancements.sh**|Automated installer for macOS|First-time setup on macOS|
|**setup-bunches.sh**|Creates bunches system|Both macOS and Linux setup|
|**collect-for-ai.sh**|Gathers configs for AI help|When you need AI assistance|

#### Configuration Files

|**File**|**Purpose**|**Platform**|
|---|---|---|
|**yabairc**|Window manager config|macOS only|
|**skhdrc**|Keyboard shortcuts|macOS only|
|**wezterm.lua**|Terminal emulator|Both (auto-detects)|
|**tmux.conf**|Terminal multiplexer|Both (identical)|

#### Documentation Files

|**File**|**Purpose**|**Read When**|
|---|---|---|
|**UNIFIED-SETUP-GUIDE.md**|Step-by-step installation|**Start here\!**|
|**COMPLETE-CHEATSHEET.md**|All shortcuts for both systems|Print & keep visible\!|
|**MASTER-DOCUMENTATION.md**|Complete technical reference|Deep dive / customization|
|**AI-HANDOFF-GUIDE.md**|How to get AI help|When you need assistance|

-----

### 🗂️ File Organization Tips

#### Recommended Directory Structure

```
~/keyboard-env-installation/
├── configs/
│   ├── yabairc
│   ├── skhdrc
│   ├── wezterm.lua
│   └── tmux.conf
├── scripts/
│   ├── install-enhancements.sh
│   ├── setup-bunches.sh
│   └── collect-for-ai.sh
├── docs/
│   ├── UNIFIED-SETUP-GUIDE.md        ← Read first!
│   ├── COMPLETE-CHEATSHEET.md        ← Print this!
│   ├── MASTER-DOCUMENTATION.md
│   └── AI-HANDOFF-GUIDE.md
└── (Other supporting docs)
```

-----

*Last Updated: November 14, 2025*
*Systems: macOS (Yabai) & Linux (Hyprland)*
*Philosophy: Same muscle memory, everywhere*

