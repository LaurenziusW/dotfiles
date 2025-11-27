# Keybinding Cheat Sheet

Complete reference for all keyboard shortcuts in the Unified Keyboard Environment.

**Legend**: 
- `Alt` = Alt/Option key (Linux) or Cmd key (macOS)
- `Ctrl` = Control key (both platforms)
- `Super` = Super/Windows key (Linux) or Cmd+Alt (macOS)

---

## 🎹 Modifier Hierarchy Quick Reference

| Layer | Linux | macOS | Purpose |
|-------|-------|-------|---------|
| **PRIMARY** | `Alt` | `Cmd` | Window Management |
| **SECONDARY** | `Ctrl` | `Ctrl` | Terminal & Apps |
| **TERTIARY** | `Super` | `Cmd+Alt` | Launchers & System |

---

## 🪟 Window Management (PRIMARY Layer)

### Window Focus (Vim-Style)

| Keybinding | Action |
|------------|--------|
| `Alt/Cmd + H` | Focus window LEFT |
| `Alt/Cmd + J` | Focus window DOWN |
| `Alt/Cmd + K` | Focus window UP |
| `Alt/Cmd + L` | Focus window RIGHT |
| `Alt/Cmd + Escape` | Focus window under mouse (macOS only) |

### Window Movement

| Keybinding | Action |
|------------|--------|
| `Alt/Cmd + Shift + H` | Move window LEFT |
| `Alt/Cmd + Shift + J` | Move window DOWN |
| `Alt/Cmd + Shift + K` | Move window UP |
| `Alt/Cmd + Shift + L` | Move window RIGHT |

### Window Resizing

**macOS (skhd):**

| Keybinding | Action |
|------------|--------|
| `Alt + Shift + H` | Shrink window LEFT (-50px) |
| `Alt + Shift + L` | Grow window RIGHT (+50px) |
| `Alt + Shift + K` | Shrink window UP (-50px) |
| `Alt + Shift + J` | Grow window DOWN (+50px) |

**Linux (Hyprland):**

| Keybinding | Action |
|------------|--------|
| `Alt + Left` | Shrink window LEFT (-50px) |
| `Alt + Right` | Grow window RIGHT (+50px) |
| `Alt + Up` | Shrink window UP (-50px) |
| `Alt + Down` | Grow window DOWN (+50px) |

### Window Layout Controls

| Keybinding | Action |
|------------|--------|
| `Alt/Cmd + F` | Toggle FULLSCREEN |
| `Alt/Cmd + T` | Toggle FLOATING |
| `Alt/Cmd + P` | Toggle PSEUDO-TILING |
| `Alt/Cmd + S` | Toggle SPLIT direction |
| `Alt/Cmd + Shift + \` | Toggle split direction (macOS) |

### Advanced Layout (macOS Only)

| Keybinding | Action |
|------------|--------|
| `Cmd + Shift + R` | Rotate tree 90° clockwise |
| `Cmd + Shift + X` | Mirror tree horizontally |
| `Cmd + Shift + Y` | Mirror tree vertically |
| `Cmd + Shift + B` | Balance space (equalize sizes) |
| `Cmd + Ctrl + S` | Stack windows vertically |
| `Cmd + Ctrl + T` | Toggle layout (BSP ↔ Stack) |

---

## 🗂️ Workspace Switching (PRIMARY Layer)

### Direct Navigation

| Keybinding | Action |
|------------|--------|
| `Alt/Cmd + 1` | Switch to workspace 1 (Browser) |
| `Alt/Cmd + 2` | Switch to workspace 2 (Notes) |
| `Alt/Cmd + 3` | Switch to workspace 3 (Code) |
| `Alt/Cmd + 4` | Switch to workspace 4 (Files) |
| `Alt/Cmd + 5` | Switch to workspace 5 (Documents) |
| `Alt/Cmd + 6` | Switch to workspace 6 (Catch-all) |
| `Alt/Cmd + 7` | Switch to workspace 7 (Media) |
| `Alt/Cmd + 8` | Switch to workspace 8 (Communication) |
| `Alt/Cmd + 9` | Switch to workspace 9 (Office) |
| `Alt/Cmd + 0` | Switch to workspace 10 (AI Tools) |

### Relative Navigation (macOS Only)

| Keybinding | Action |
|------------|--------|
| `Cmd + [` | Previous workspace |
| `Cmd + ]` | Next workspace |
| **Cmd + Tab** | **Switch to last used workspace** |

### Move Window to Workspace

| Keybinding | Action |
|------------|--------|
| `Alt/Cmd + Shift + 1` | Move window to workspace 1 (and follow) |
| `Alt/Cmd + Shift + 2` | Move window to workspace 2 (and follow) |
| `Alt/Cmd + Shift + 3` | Move window to workspace 3 (and follow) |
| `Alt/Cmd + Shift + 4` | Move window to workspace 4 (and follow) |
| `Alt/Cmd + Shift + 5` | Move window to workspace 5 (and follow) |
| `Alt/Cmd + Shift + 6` | Move window to workspace 6 (and follow) |
| `Alt/Cmd + Shift + 7` | Move window to workspace 7 (and follow) |
| `Alt/Cmd + Shift + 8` | Move window to workspace 8 (and follow) |
| `Alt/Cmd + Shift + 9` | Move window to workspace 9 (and follow) |
| `Alt/Cmd + Shift + 0` | Move window to workspace 10 (and follow) |

---

## 🖥️ Terminal Operations (SECONDARY Layer)

### Tmux (Prefix: `Ctrl + A`)

**Pane Management:**

| Keybinding | Action |
|------------|--------|
| `Ctrl + A` then `\` | Split horizontal (vertical divider) |
| `Ctrl + A` then `-` | Split vertical (horizontal divider) |
| `Ctrl + A` then `H` | Focus pane LEFT |
| `Ctrl + A` then `J` | Focus pane DOWN |
| `Ctrl + A` then `K` | Focus pane UP |
| `Ctrl + A` then `L` | Focus pane RIGHT |
| `Ctrl + A` then `X` | Close current pane |

**Window Management:**

| Keybinding | Action |
|------------|--------|
| `Ctrl + A` then `C` | Create new window |
| `Ctrl + A` then `N` | Next window |
| `Ctrl + A` then `P` | Previous window |
| `Ctrl + A` then `0-9` | Switch to window 0-9 |
| `Ctrl + A` then `,` | Rename window |

**System:**

| Keybinding | Action |
|------------|--------|
| `Ctrl + A` then `D` | Detach session |
| `Ctrl + A` then `R` | Reload tmux config |
| `Ctrl + A` then `?` | Show all keybindings |

### WezTerm (Direct Control)

**Tab Management:**

| Keybinding | Action |
|------------|--------|
| `Alt + T` | New tab |
| `Alt + W` | Close tab |
| `Alt + 1-9` | Switch to tab 1-9 |

**Pane Management:**

| Keybinding | Action |
|------------|--------|
| `Alt + -` | Split vertical |
| `Alt + \` | Split horizontal |
| `Alt + H` | Focus pane LEFT |
| `Alt + J` | Focus pane DOWN |
| `Alt + K` | Focus pane UP |
| `Alt + L` | Focus pane RIGHT |

**Pane Resizing:**

| Keybinding | Action |
|------------|--------|
| `Alt + Shift + H` | Shrink pane LEFT |
| `Alt + Shift + J` | Shrink pane DOWN |
| `Alt + Shift + K` | Shrink pane UP |
| `Alt + Shift + L` | Shrink pane RIGHT |

### Shell (Zsh)

**Standard Ctrl Commands:**

| Keybinding | Action |
|------------|--------|
| `Ctrl + A` | Jump to beginning of line |
| `Ctrl + E` | Jump to end of line |
| `Ctrl + U` | Delete from cursor to start |
| `Ctrl + K` | Delete from cursor to end |
| `Ctrl + W` | Delete word backward |
| `Ctrl + R` | Reverse history search |
| `Ctrl + L` | Clear screen |
| `Ctrl + C` | Cancel current command |
| `Ctrl + D` | Exit shell / EOF |

**History Navigation:**

| Keybinding | Action |
|------------|--------|
| `↑` / `Ctrl + P` | Previous command |
| `↓` / `Ctrl + N` | Next command |
| `Ctrl + R` | Search history backward |

---

## 📝 Neovim (SECONDARY Layer)

### Normal Mode - Basic Navigation

| Keybinding | Action |
|------------|--------|
| `H` | Move LEFT |
| `J` | Move DOWN |
| `K` | Move UP |
| `L` | Move RIGHT |
| `W` | Next word |
| `B` | Previous word |
| `0` | Start of line |
| `$` | End of line |
| `GG` | Go to top |
| `Shift + G` | Go to bottom |

### Window Management

| Keybinding | Action |
|------------|--------|
| `Ctrl + H` | Focus window LEFT |
| `Ctrl + J` | Focus window DOWN |
| `Ctrl + K` | Focus window UP |
| `Ctrl + L` | Focus window RIGHT |

### Leader Commands (Space)

| Keybinding | Action |
|------------|--------|
| `Space + S + F` | Search files |
| `Space + S + G` | Search with grep |
| `Space + S + H` | Search help |
| `Space + /` | Search in current buffer |
| `Space + Space` | Find buffers |

### LSP (Language Server)

| Keybinding | Action |
|------------|--------|
| `G + R + D` | Go to definition |
| `G + R + R` | Find references |
| `G + R + I` | Go to implementation |
| `G + R + N` | Rename symbol |
| `G + R + A` | Code action |

---

## 🚀 Quick Launch (TERTIARY Layer - macOS)

### Application Launchers

| Keybinding | Application |
|------------|-------------|
| `Cmd + Alt + B` | Brave Browser |
| `Cmd + Alt + O` | Obsidian (Notes) |
| `Cmd + Alt + C` | VS Code |
| `Cmd + Alt + T` | WezTerm (Terminal) |
| `Cmd + Alt + M` | Spotify (Music) |
| `Cmd + Alt + F` | ForkLift (File Manager) |
| `Cmd + Alt + R` | Raindrop (Bookmarks) |

### System Actions

| Keybinding | Action |
|------------|--------|
| `Cmd + Return` | Launch terminal (skhd) |
| `Super + Return` | Launch terminal (Linux) |
| `Super + Space` | App launcher (Wofi/Linux) |
| `Super + Q` | Close window (Linux) |
| `Super + Shift + E` | Exit session (Linux) |

---

## 🎯 Environment Bunches (TERTIARY Layer)

### Predefined Environments (macOS)

| Keybinding | Environment | Contents |
|------------|-------------|----------|
| `Cmd + Ctrl + 1` | Study Math | Obsidian, Browser, Terminal, PDF Reader |
| `Cmd + Ctrl + 2` | Guitar Practice | Spotify, Browser (tabs), Notes |
| `Cmd + Ctrl + 3` | Coding Project | VS Code, Terminal, Browser (docs) |
| `Cmd + Ctrl + 4` | Email & Admin | Mail, Slack, Browser |
| `Cmd + Ctrl + 5` | Reading | PDF Reader, Notes |

### Bunch Management (CLI)

```bash
bunch-manager list              # Show all bunches
bunch-manager run study-math    # Run a bunch
bunch-manager create my-bunch   # Create new bunch
bunch-manager edit my-bunch     # Edit existing bunch
```

---

## 🔧 System Utilities (TERTIARY Layer)

### Workspace Organization (macOS)

| Keybinding | Action |
|------------|--------|
| `Cmd + \`` (backtick) | Run `gather-current-space` |

**What it does**: Automatically moves windows in the current workspace to their designated workspaces based on app type.

### Screenshots (Linux)

| Keybinding | Action |
|------------|--------|
| `Super + S` | Screenshot selection (with Swappy editor) |
| `Super + Shift + S` | Screenshot full screen (with Swappy) |

---

## 🎨 Special Keys (System-Wide via keyd/Karabiner)

### Caps Lock Layer

**When you hold Caps Lock:**

| Key | Action |
|-----|--------|
| `H` | Left Arrow |
| `J` | Down Arrow |
| `K` | Up Arrow |
| `L` | Right Arrow |
| `U` | Page Down |
| `I` | Page Up |
| `Y` | Home |
| `O` | End |
| `F` | Word Left (`Alt+Left`) |
| `G` | Word Right (`Alt+Right`) |

**Selection (with Caps Lock):**

| Key | Action |
|-----|--------|
| `A` | Shift+Left (select left) |
| `S` | Shift+Down (select down) |
| `D` | Shift+Right (select right) |
| `W` | Shift+Up (select up) |
| `Q` | Shift+Alt+Left (select word left) |
| `E` | Shift+Alt+Right (select word right) |

**Tap Caps Lock once**: Acts as Escape

---

## 🎵 Media Keys (Universal)

| Key | Action |
|-----|--------|
| `F7` | Previous track |
| `F8` | Play/Pause |
| `F9` | Next track |
| `F10` | Mute |
| `F11` | Volume down |
| `F12` | Volume up |
| `Brightness Down` | Decrease brightness |
| `Brightness Up` | Increase brightness |

---

## 📋 Common Zsh Aliases

### Navigation

| Alias | Command | Description |
|-------|---------|-------------|
| `..` | `cd ..` | Up one directory |
| `...` | `cd ../..` | Up two directories |
| `....` | `cd ../../..` | Up three directories |

### File Operations

| Alias | Command | Description |
|-------|---------|-------------|
| `ll` | `ls -lh` | List detailed |
| `la` | `ls -lah` | List all (including hidden) |
| `lt` | `eza --tree` | Tree view (if eza installed) |

### Git

| Alias | Command | Description |
|-------|---------|-------------|
| `g` | `git` | Git shorthand |
| `gs` | `git status` | Status |
| `ga` | `git add` | Add files |
| `gc` | `git commit` | Commit |
| `gp` | `git push` | Push |
| `gl` | `git log --oneline --graph` | Pretty log |

### Dotfiles

| Alias | Command | Description |
|-------|---------|-------------|
| `dots` | `cd ~/dotfiles` | Go to dotfiles |
| `reload` | `source ~/.zshrc` | Reload shell config |
| `zshrc` | `nvim ~/.zshrc` | Edit zsh config |
| `vimrc` | `nvim ~/.config/nvim/init.lua` | Edit vim config |

### System (Platform-Specific)

**macOS:**

| Alias | Command | Description |
|-------|---------|-------------|
| `yabai-restart` | `yabai --restart-service` | Restart Yabai |
| `skhd-restart` | `skhd --restart-service` | Restart skhd |

**Linux:**

| Alias | Command | Description |
|-------|---------|-------------|
| `hypr-restart` | `hyprctl reload` | Reload Hyprland config |
| `pacupdate` | `sudo pacman -Syu` | Update packages |

---

## 🔄 Mouse Actions (Optional)

### Window Management

**macOS (Yabai):**

| Action | Keybinding |
|--------|------------|
| Move window | `Alt + Drag` |
| Resize window | `Alt + Right-Click + Drag` |

**Linux (Hyprland):**

| Action | Keybinding |
|--------|------------|
| Move window | `Super + Left-Click + Drag` |
| Resize window | `Super + Right-Click + Drag` |

---

## 🆘 Emergency / Recovery

### If Window Manager Breaks

**macOS:**
```bash
# Restart services
yabai --restart-service
skhd --restart-service

# Or reboot
sudo reboot
```

**Linux:**
```bash
# Exit to TTY: Ctrl+Alt+F2
# Login and restart compositor
pkill Hyprland
Hyprland
```

### If Stuck in Tmux

| Keybinding | Action |
|------------|--------|
| `Ctrl + A` then `D` | Detach from session |
| Type `tmux kill-session` | Kill current session |
| Type `exit` in all panes | Close session |

### If Neovim Freezes

| Keybinding | Action |
|------------|--------|
| `Ctrl + C` | Cancel operation |
| `:qa!` | Force quit all |
| `Ctrl + Z` (from shell) | Suspend nvim, `fg` to resume |

---

## 📝 Quick Reference Card (Print This!)

```
┌─────────────────────────────────────────────────────────────┐
│ UNIFIED KEYBOARD ENVIRONMENT - QUICK REFERENCE              │
├─────────────────────────────────────────────────────────────┤
│ WINDOW FOCUS:     Alt+H/J/K/L                               │
│ WINDOW MOVE:      Alt+Shift+H/J/K/L                         │
│ WORKSPACE SWITCH: Alt+1-9                                   │
│ WORKSPACE MOVE:   Alt+Shift+1-9                             │
│ FULLSCREEN:       Alt+F                                     │
│ FLOAT:            Alt+T                                     │
├─────────────────────────────────────────────────────────────┤
│ TERMINAL (Tmux):  Ctrl+A → prefix for all commands         │
│ SPLIT H/V:        Ctrl+A then \ or -                        │
│ NAV PANES:        Ctrl+A then H/J/K/L                       │
├─────────────────────────────────────────────────────────────┤
│ LAUNCH (macOS):   Cmd+Alt+B/O/C/T/M (Browser/Obs/Code...)  │
│ BUNCHES:          Cmd+Ctrl+1-5 (Environments)               │
│ GATHER SPACE:     Cmd+` (organize current workspace)        │
├─────────────────────────────────────────────────────────────┤
│ CAPS LOCK LAYER:  Hold CapsLock → H/J/K/L = Arrows         │
│                   Tap CapsLock once → Escape                │
└─────────────────────────────────────────────────────────────┘
```

---

**Tips for Learning:**

1. **Start with the basics**: Window focus (Alt+H/J/K/L) and workspace switching (Alt+1-9)
2. **Add one layer at a time**: Master window management before diving into Tmux
3. **Print the quick reference**: Keep it visible until muscle memory kicks in
4. **Use bunches**: They teach you the workspace layout organically
5. **Caps Lock layer**: Enable keyd/Karabiner and practice arrow-key substitution

**Most Used Shortcuts (80/20 Rule):**
- `Alt+H/J/K/L` (window focus)
- `Alt+1-9` (workspace switch)
- `Ctrl+A + \/-` (tmux split)
- `CapsLock+H/J/K/L` (system-wide arrows)

Master these 15 shortcuts and you'll handle 80% of your daily workflow.

---

**Last Updated**: 2024-11-27  
**Platform**: macOS (Yabai/skhd) & Linux (Hyprland)  
**Maintained By**: @LaurenziusW
