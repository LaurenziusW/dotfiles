# Unified Keyboard Environment

A cross-platform, keyboard-driven workflow system that provides consistent window management, terminal multiplexing, and environment orchestration across macOS and Linux.

## 🎯 What Is This?

This repository contains a complete dotfiles setup that implements a **hierarchical keyboard modifier system** to eliminate conflicts between system-level window management and terminal operations. Everything is managed from `~/dotfiles` and deployed using GNU Stow.

### Key Features

- **🎹 Zero Conflicts**: Strict modifier hierarchy prevents key collision
- **🔄 Cross-Platform**: Works on macOS (Yabai) and Linux (Hyprland)
- **📦 Single Source**: All configs in `~/dotfiles`, managed with Stow
- **🚀 Environment Bunches**: Context-based workspace orchestration
- **⚡ Drift Protection**: Automatic backup of local modifications

## 🏗️ Architecture Overview

```
~/dotfiles/                    # Repository root (your single source of truth)
├── hyprland/                  # Linux window manager config
│   └── .config/hypr/
├── yabai/                     # macOS window manager config
│   └── .config/yabai/
├── skhd/                      # macOS hotkey daemon
│   └── .config/skhd/
├── wezterm/                   # Terminal emulator
│   └── .wezterm.lua
├── nvim/                      # Neovim editor
│   └── .config/nvim/
├── tmux/                      # Terminal multiplexer
│   └── .tmux.conf
├── zsh/                       # Shell configuration
│   └── .zshrc
├── keyd/                      # Linux system-wide key remapping
│   └── default.conf
├── local-bin/                 # Custom scripts in PATH
│   └── .local/bin/
│       ├── gather-current-space
│       ├── bunch-manager
│       └── lib-os-detect
├── workflow/                  # Environment orchestration
│   └── bunches/
│       ├── study-math.sh
│       ├── coding-project.sh
│       └── templates/
├── scripts/                   # Management utilities
│   ├── install.sh
│   ├── detect_install.sh
│   └── maintenance/
└── docs/                      # Documentation
    ├── PHILOSOPHY.md
    ├── CHEAT-SHEET.md
    └── ARCHITECTURE.md
```

## 🚀 Quick Start

### Prerequisites

**Common (Both Platforms):**
- Git
- GNU Stow
- Neovim (0.10+)
- WezTerm
- Zsh
- Tmux

**macOS Specific:**
- [Yabai](https://github.com/koekeishiya/yabai)
- [skhd](https://github.com/koekeishiya/skhd)
- [Karabiner-Elements](https://karabiner-elements.pqrs.org/) (optional, for Caps Lock → Esc)

**Linux Specific:**
- [Hyprland](https://hyprland.org/)
- [keyd](https://github.com/rvaiya/keyd)

### Installation

```bash
# 1. Clone to ~/dotfiles
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Check for conflicts (optional but recommended)
./scripts/detect_install.sh

# 3. Install all configurations
./scripts/install.sh

# 4. Reload your shell
source ~/.zshrc
```

The install script will:
- Detect your OS automatically
- Back up any conflicting local files
- Create symlinks using GNU Stow
- Install the correct configs for your platform

## 🎹 Modifier Philosophy

This system uses a **strict three-tier hierarchy** to prevent conflicts:

| Layer | Modifier | Purpose | Examples |
|-------|----------|---------|----------|
| **PRIMARY** | Alt (Linux)<br>Cmd (macOS) | Window Management | Focus, move, resize windows<br>Switch workspaces |
| **SECONDARY** | Ctrl | Terminal & Apps | Tmux prefix, Nvim commands<br>Shell shortcuts |
| **TERTIARY** | Super (Linux)<br>Cmd+Alt (macOS) | Launchers & System | App launchers<br>Bunches (environments) |

**The Golden Rule**: Each layer never invades another. Ctrl is sacred for terminals, Alt/Cmd handles windows, Super launches things.

## 📋 Essential Keybindings

### Window Management (PRIMARY Layer)

**Focus Navigation (Vim-style):**
- `Alt/Cmd + H/J/K/L` - Focus window left/down/up/right

**Window Movement:**
- `Alt/Cmd + Shift + H/J/K/L` - Move window in direction

**Workspace Switching:**
- `Alt/Cmd + 1-9, 0` - Switch to workspace 1-10
- `Alt/Cmd + Shift + 1-9, 0` - Move window to workspace
- **Cmd + Tab - Switch to last used workspace (macOS)**

**Window Controls:**
- `Alt/Cmd + F` - Toggle fullscreen
- `Alt/Cmd + T` - Toggle floating
- `Alt/Cmd + S` - Toggle split direction

### Terminal (SECONDARY Layer)

**Tmux (when inside tmux):**
- `Ctrl + A` then `|` - Split horizontal
- `Ctrl + A` then `-` - Split vertical  
- `Ctrl + A` then `H/J/K/L` - Navigate panes

**WezTerm (direct control):**
- `Alt + T` - New tab
- `Alt + H/J/K/L` - Navigate panes
- `Alt + 1-9` - Switch to tab

### System Launchers (TERTIARY Layer)

**Quick App Launch (macOS):**
- `Cmd + Alt + B` - Browser
- `Cmd + Alt + T` - Terminal
- `Cmd + Alt + O` - Obsidian
- `Cmd + Alt + C` - Code

**Bunches (Environment Orchestration):**
- `Cmd + Ctrl + 1` - Study Math environment
- `Cmd + Ctrl + 2` - Guitar Practice
- `Cmd + Ctrl + 3` - Coding Project

## 🏢 Workspace Organization

Workspaces are pre-assigned by application type:

| # | Purpose | Apps |
|---|---------|------|
| 1 | Browser | Safari, Brave, Arc |
| 2 | Notes | Obsidian |
| 3 | Code | WezTerm, VS Code, Xcode |
| 4 | Files | Finder, ForkLift |
| 5 | Documents | Preview, PDF Expert |
| 6 | **Catch-All** | Everything else |
| 7 | Media | Spotify |
| 8 | Communication | Slack, Discord, Mail |
| 9 | Office | Microsoft Office |
| 10 | AI | Claude, Perplexity |

**Pro Tip**: Use `Cmd/Alt + \`` (backtick) to run `gather-current-space` and automatically organize windows in the current workspace.

## 🎯 Environment Bunches

Bunches are pre-configured environment setups that launch and organize apps for specific tasks.

```bash
# List available bunches
bunch-manager list

# Run a bunch
bunch-manager run study-math

# Create a new bunch
bunch-manager create my-workflow

# Edit an existing bunch
bunch-manager edit study-math
```

**Example Workflow:**
1. Press `Cmd + Ctrl + 1` (or run `study-math.sh`)
2. Automatically opens: Obsidian (notes), browser (research), terminal (calculations), PDF reader (textbooks)
3. Everything organized in the correct workspaces
4. Ready to work!

## 🛠️ Customization

### Adding Your Own Keybindings

**macOS (skhd):**
```bash
nvim ~/.config/skhd/skhdrc
# Add your bindings, then:
skhd --restart-service
```

**Linux (Hyprland):**
```bash
nvim ~/.config/hypr/hyprland.conf
# Add your bindings, then:
hyprctl reload
```

### Creating Custom Bunches

```bash
# Create from template
bunch-manager create my-deep-work

# Edit the generated script
nvim ~/dotfiles/workflow/bunches/my-deep-work.sh

# Add your apps and workspace logic
# See templates/bunch-template.sh for structure
```

### Modifying Workspace Assignments

Edit `~/dotfiles/yabai/.config/yabai/yabairc` (macOS) or `~/dotfiles/hyprland/.config/hypr/hyprland.conf` (Linux) to change which apps go to which workspaces.

## 📚 Documentation

- **[PHILOSOPHY.md](docs/PHILOSOPHY.md)** - Design principles and the "why" behind decisions
- **[CHEAT-SHEET.md](docs/CHEAT-SHEET.md)** - Complete keybinding reference
- **[ARCHITECTURE.md](docs/ARCHITECTURE.md)** - Technical deep-dive

## 🔧 Maintenance

### Updating Configurations

```bash
cd ~/dotfiles

# Pull latest changes
git pull

# Re-stow to update symlinks
./scripts/install.sh

# Or update specific package
cd ~/dotfiles
stow -R nvim  # Re-stow just Neovim config
```

### Checking System State

```bash
# Generate full system report
~/dotfiles/scripts/maintenance/fulldump.sh

# Output saved to ~/full-system-dump.txt
cat ~/full-system-dump.txt
```

### Collecting Context for AI

```bash
# Create archive of repo for AI assistance
~/dotfiles/scripts/maintenance/collect-for-ai.sh

# Upload the generated .tar.gz to your AI assistant
```

## 🐛 Troubleshooting

### Symlinks Not Working

```bash
# Check what Stow would do (dry run)
cd ~/dotfiles
stow -n -v nvim  # Replace 'nvim' with problematic package

# If you see "existing target" errors, backup and re-run:
./scripts/detect_install.sh  # Will offer to backup conflicts
./scripts/install.sh
```

### Window Manager Not Working

**macOS:**
```bash
# Check Yabai status
yabai --check-sa  # Should show "Scripting Addition loaded successfully"

# View logs
tail -f /tmp/yabai_*.err.log
tail -f /tmp/skhd_*.err.log

# Restart services
yabai --restart-service
skhd --restart-service
```

**Linux:**
```bash
# Check Hyprland is running
hyprctl version

# View logs  
cat ~/.hyprland.log

# Reload config
hyprctl reload
```

### Keybindings Not Responding

1. **Check modifier conflicts**: Ensure no other app is capturing the same keys
2. **Verify config syntax**: Check for typos in `skhdrc` or `hyprland.conf`
3. **Restart the hotkey daemon**: `skhd --restart-service` or `hyprctl reload`
4. **Test in isolation**: Try the binding in an empty workspace

## 🤝 Contributing

This is a personal dotfiles repository, but feel free to:
- Fork it for your own use
- Submit issues for bugs
- Share improvements via pull requests
- Use it as inspiration for your setup

## 📝 License

MIT License - Feel free to use, modify, and distribute.

## 🙏 Acknowledgments

- [Yabai](https://github.com/koekeishiya/yabai) & [skhd](https://github.com/koekeishiya/skhd) - macOS tiling
- [Hyprland](https://hyprland.org/) - Linux compositor
- [GNU Stow](https://www.gnu.org/software/stow/) - Symlink management
- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) - Neovim config base

---

**Status**: ✅ Actively maintained | **Platform**: macOS 14+ & Arch Linux | **Author**: Laurenz (@LaurenziusW)
