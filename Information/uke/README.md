# UKE v8 - Unified Keyboard Environment

**One muscle memory for macOS & Linux. No generators. No magic. Just configs.**

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  UKE v8 - Hand-crafted dotfiles with GNU Stow                               │
│                                                                              │
│  mac/      → macOS-only configs (yabai, skhd)                               │
│  arch/     → Arch Linux-only configs (hyprland, waybar, keyd, zathura)      │
│  shared/   → Cross-platform configs (wezterm, tmux, zsh, nvim, scripts)     │
│  docs/     → Philosophy, cheatsheet, troubleshooting                        │
└──────────────────────────────────────────────────────────────────────────────┘
```

## Philosophy

- **No auto-generation**: Every config is hand-written and human-readable
- **No helper scripts**: Just edit the configs directly
- **GNU Stow**: Symlink management without complexity
- **Local overrides**: Hardware-specific settings stay out of git

See [docs/PHILOSOPHY.md](docs/PHILOSOPHY.md) for design principles.

## Modifier Hierarchy

| Layer | macOS | Linux | Purpose |
|:------|:------|:------|:--------|
| **PRIMARY** | Cmd ⌘ | Alt | Window manager (focus, workspaces) |
| **PRIMARY+SHIFT** | Cmd+Shift | Alt+Shift | Move windows |
| **SECONDARY** | Alt ⌥ | Super | Terminal (WezTerm panes/tabs) |
| **TERTIARY** | Alt+Shift | Super+Shift | Resize (windows or panes) |
| **QUATERNARY** | Ctrl | Ctrl | Shell (never intercepted) |
| **TMUX** | Ctrl+A | Ctrl+A | Tmux prefix |
| **BUNCH** | Cmd+Ctrl | Alt+Ctrl | Environment presets |
| **LAUNCHER** | Cmd+Alt | Alt+Super | Quick app launch |

## Installation

### Prerequisites

**macOS:**
```bash
brew install stow yabai skhd jq
# Optional: brew install borders
```

**Arch Linux:**
```bash
sudo pacman -S stow hyprland waybar wofi wezterm zathura jq
yay -S keyd  # AUR
```

### Setup

```bash
# Clone to ~/dotfiles/uke-v8
git clone <repo> ~/dotfiles/uke-v8
cd ~/dotfiles/uke-v8

# Stow shared configs (both platforms)
cd shared && stow -t ~ . && cd ..

# Stow platform-specific configs
cd mac && stow -t ~ . && cd ..   # macOS
# OR
cd arch && stow -t ~ . && cd ..  # Linux

# Verify installation
uke-doctor
```

### macOS Post-Install

```bash
# Start services
yabai --start-service
skhd --start-service

# For full features, partially disable SIP
sudo yabai --load-sa
```

### Arch Post-Install

```bash
# Enable keyd for CapsLock → Escape with nav layer
sudo cp ~/.config/keyd/default.conf /etc/keyd/default.conf
sudo systemctl enable --now keyd

# Hyprland starts automatically when you log in
```

## Directory Structure

```
uke-v8/
├── mac/                          # macOS only (stow package)
│   └── .config/
│       ├── yabai/yabairc         # Window manager rules
│       └── skhd/skhdrc           # Hotkeys
│
├── arch/                         # Arch Linux only (stow package)
│   └── .config/
│       ├── hypr/hyprland.conf    # Wayland compositor (v0.51+)
│       ├── waybar/               # Status bar
│       ├── keyd/default.conf     # CapsLock nav layer
│       └── zathura/zathurarc     # PDF viewer (Nord theme)
│
├── shared/                       # Both platforms (stow package)
│   ├── .config/
│   │   ├── wezterm/wezterm.lua   # Terminal (OS-aware)
│   │   ├── tmux/tmux.conf        # Multiplexer
│   │   └── nvim/init.lua         # Editor
│   ├── .local/bin/
│   │   ├── uke-gather            # Organize windows
│   │   ├── uke-bunch             # Environment presets
│   │   ├── uke-doctor            # Health check
│   │   ├── uke-sticky            # Floating pinned windows
│   │   └── uke-scratchpad        # Dropdown windows
│   └── .zshrc                    # Shell (OS-aware)
│
├── docs/
│   ├── PHILOSOPHY.md             # Design principles
│   ├── CHEATSHEET.md             # Quick reference
│   └── TROUBLESHOOTING.md        # Problem solving
│
├── .gitignore
├── install.sh
└── README.md
```

## Quick Reference

### Window Management

| Action | macOS | Linux |
|:-------|:------|:------|
| Focus hjkl | `Cmd + hjkl` | `Alt + hjkl` |
| Move window | `Cmd+Shift + hjkl` | `Alt+Shift + hjkl` |
| Resize | `Alt+Shift + hjkl` | `Super+Shift + hjkl` |
| Workspace 1-9 | `Cmd + 1-9` | `Alt + 1-9` |
| Move to WS | `Cmd+Shift + 1-9` | `Alt+Shift + 1-9` |
| Terminal | `Cmd + Return` | `Alt + Return` |
| Fullscreen | `Cmd+Shift + f` | `Alt+Shift + f` |
| Gather | `Cmd + \`` | `Alt + \`` |

### WezTerm

| Action | macOS | Linux |
|:-------|:------|:------|
| New tab | `Alt + t` | `Super + t` |
| Split horizontal | `Alt + \` | `Super + \` |
| Split vertical | `Alt + -` | `Super + -` |
| Navigate panes | `Alt + hjkl` | `Super + hjkl` |
| Resize panes | `Alt+Shift + hjkl` | `Super+Shift + hjkl` |

### Bunches

| Key | Name | Apps | Workspace |
|:----|:-----|:-----|:----------|
| `Mod+Ctrl+1` | study | Obsidian, Brave, WezTerm | 2 |
| `Mod+Ctrl+2` | guitar | Spotify, Brave | 7 |
| `Mod+Ctrl+3` | coding | WezTerm, Code, Brave | 3 |
| `Mod+Ctrl+4` | email | Mail, Slack, Brave | 9 |
| `Mod+Ctrl+5` | reading | Preview, Obsidian | 5 |

## Workspaces

| # | Purpose | Apps |
|:--|:--------|:-----|
| 1 | Browser | Safari, Brave, Firefox |
| 2 | Notes | Obsidian |
| 3 | Code | WezTerm, VSCode, Xcode |
| 4 | Catch-all | Everything else |
| 5 | Documents | Preview, PDF Expert |
| 6 | Raindrop | Raindrop.io |
| 7 | Media | Spotify |
| 8 | Office | Word, Excel, PowerPoint |
| 9 | Comms | Slack, Discord, Mail |
| 10 | AI | Claude, Perplexity |

## UKE Commands

```bash
# Window organization
uke-gather              # Move windows to assigned workspaces

# Environment presets
uke-bunch study         # Launch study environment
uke-bunch coding        # Launch coding environment
uke-bunch list          # List available bunches

# Sticky windows (floating + pinned + always-on-top)
uke-sticky toggle       # Toggle sticky mode for focused window
uke-sticky list         # List all sticky windows

# Scratchpads (dropdown windows)
uke-scratchpad terminal # Toggle terminal dropdown
uke-scratchpad notes    # Toggle Obsidian
uke-scratchpad music    # Toggle Spotify

# Health check
uke-doctor              # Run diagnostics
```

## Special Features

### Sticky Windows
Make any window float, stay on all workspaces, and remain on top:
- **macOS**: `Cmd+Shift+S`
- **Linux**: `Alt+Shift+S`

### CapsLock Nav Layer (Linux keyd)
CapsLock becomes a navigation layer:
- `CapsLock + hjkl` → Arrow keys
- `CapsLock + yuio` → Home/PageUp/PageDown/End
- `CapsLock + bw` → Word-wise movement
- Tap CapsLock → Escape

## Local Overrides

Each config sources a local override file (gitignored) for hardware-specific settings:

| Config | Override File |
|:-------|:--------------|
| WezTerm | `~/.config/wezterm/local.lua` |
| Hyprland | `~/.config/hypr/local.conf` |
| Yabai | `~/.config/yabai/local_rules` |
| Zsh | `~/.zshrc.local` |
| Nvim | `~/.config/nvim/local.lua` |
| Tmux | `~/.config/tmux/local.conf` |

Example `~/.config/hypr/local.conf` for HiDPI:
```ini
monitor = eDP-1, 2560x1600@60, 0x0, 1.5
```

Example `~/.config/wezterm/local.lua` for larger font:
```lua
return {
    font_size = 16,
}
```

## Customization

Just edit the files. No generators, no rebuilding.

- Add a keybinding? Edit `skhdrc` or `hyprland.conf`
- Change workspace assignment? Edit `yabairc` or window rules in `hyprland.conf`
- Add a bunch? Edit `uke-bunch` script
- Change terminal colors? Edit `wezterm.lua`

After editing, reload:
- **skhd**: `skhd --reload` or `Cmd+Alt+s`
- **yabai**: `yabai --restart-service` or `Cmd+Alt+y`
- **Hyprland**: Auto-reloads, or `hyprctl reload`
- **WezTerm**: `Alt+r` / `Super+r`

## Troubleshooting

### macOS

```bash
# Check services
pgrep -l yabai skhd

# View logs
tail -f /tmp/yabai_*.err.log
tail -f /tmp/skhd_*.err.log

# Restart
yabai --restart-service
skhd --restart-service
```

### Arch Linux

```bash
# Check Hyprland
echo $HYPRLAND_INSTANCE_SIGNATURE

# View logs
cat ~/.local/share/hyprland/hyprland.log

# Reload
hyprctl reload
```

## License

MIT - Do what you want.
