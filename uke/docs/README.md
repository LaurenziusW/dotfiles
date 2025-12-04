# UKE - Unified Keyboard Environment v7.2

A cross-platform keyboard-driven workflow system with comprehensive Arch Linux management.

## What's New in v7.2

### Core Features
- **`uke-services`** - Service health monitoring (reads from registry.yaml)
- **`uke-update`** - Unified updates with mirror optimization & cache cleaning
- **`uke-fix`** - Quick fixes with auto-detection & cache cleanup
- **`uke-setup`** - First-boot wizard with safe sudo handling
- **`uke-backup`** - Enhanced backup with full restore capability
- **`uke-snapshot`** - System snapshots (btrfs/snapper/timeshift)

### QoL Improvements
- **`uke-launch`** - Smart file type detection (PDFs open in zathura)
- **Mirror optimization** - reflector integration for faster updates
- **Cache cleaning** - paccache & orphan removal built-in
- **fzf integration** - Fuzzy history (Ctrl+R), file search (Ctrl+T)
- **Service definitions in YAML** - Configure services in registry.yaml

### New Stow Packages
- **zathura/** - Vim-like PDF viewer with Nord theme
- Enhanced **.zshrc** with fzf, better aliases, UKE shortcuts

## Quick Start

### Fresh Arch Install
```bash
git clone <repo> ~/dotfiles/uke
cd ~/dotfiles/uke
./bin/uke-setup
# Reboot - done!
```

### Existing System
```bash
cd ~/dotfiles/uke
./scripts/arch-check.sh
./scripts/install.sh
uke profile && uke apply
```

## Daily Commands

```bash
uke-update          # Update system + AUR + UKE + optimize mirrors
uke-update --clean  # Clean cache & orphans
uke-fix             # Auto-detect and fix issues
uke-services        # Check service status
```

## Update Manager

```bash
uke-update --check    # Show pending updates
uke-update --news     # Show Arch news
uke-update --mirrors  # Refresh mirror list
uke-update --clean    # Clean cache & orphans
uke-update --all      # Everything (default)
```

Features:
- Mirror optimization via reflector
- Package cache cleanup (keeps last 2 versions)
- Orphaned package removal
- Kernel update detection (reboot warning)

## Service Manager

Services are defined in `config/registry.yaml`:
```yaml
services:
  system: [keyd, bluetooth, NetworkManager]
  user: [pipewire, pipewire-pulse, wireplumber]
  hyprland: [waybar, dunst, hypridle, hyprpaper]
```

Commands:
```bash
uke-services          # Status
uke-services restart  # Restart all
uke-services logs keyd
```

## Quick Fixes

```bash
uke-fix              # Auto-detect issues
uke-fix --audio      # Restart PipeWire
uke-fix --keys       # Restart keyd
uke-fix --cache      # Clean caches
uke-fix --all        # Fix everything
```

## Smart Launcher

```bash
uke-launch browser              # Open default browser
uke-launch ~/docs/paper.pdf     # Opens in zathura
uke-launch https://arch.org     # Opens URL
```

## Shell Features (fzf)

After installation, your shell has:
- **Ctrl+R** - Fuzzy history search
- **Ctrl+T** - Fuzzy file search
- **Alt+C** - Fuzzy cd
- **fcd** - Fuzzy cd with preview
- **fh** - Fuzzy history
- **fkill** - Fuzzy process kill

## Key Bindings

| Action | macOS | Linux |
|--------|-------|-------|
| Focus window | Cmd+hjkl | Alt+hjkl |
| Move window | Cmd+Shift+hjkl | Alt+Shift+hjkl |
| Resize | Alt+Shift+hjkl | Super+Shift+hjkl |
| Switch workspace | Cmd+1-0 | Alt+1-0 |
| Terminal | Cmd+Return | Alt+Return |
| Launcher | Cmd+Space | Alt+Space |

## Directory Structure

```
uke/
├── bin/                    # CLI tools
│   ├── uke-services        # Service manager
│   ├── uke-update          # Update manager
│   ├── uke-fix             # Quick fixes
│   ├── uke-setup           # First-boot wizard
│   ├── uke-launch          # Smart launcher
│   └── ...
├── config/
│   └── registry.yaml       # Single source of truth
├── stow/
│   ├── zathura/            # PDF viewer
│   ├── zsh/                # Shell with fzf
│   └── ...
└── scripts/
    └── arch-check.sh       # Package checker
```

## Troubleshooting

### Low disk space
```bash
uke-update --clean
```

### Slow updates
```bash
uke-update --mirrors
```

### Audio not working
```bash
uke-fix --audio
```

### Check everything
```bash
uke doctor
uke-services
```
