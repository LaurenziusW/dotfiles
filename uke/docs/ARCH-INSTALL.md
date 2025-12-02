# UKE v6.3 - Arch Linux Installation Guide

This guide covers setting up UKE (Unified Keyboard Environment) on Arch Linux with Hyprland.

## Prerequisites

### Required Packages

```bash
# Window Manager & Core
sudo pacman -S hyprland hyprpaper

# UKE Dependencies
sudo pacman -S stow jq git neovim

# Terminal & Shell
sudo pacman -S wezterm zsh tmux

# Hyprland Ecosystem (highly recommended)
sudo pacman -S waybar dunst wofi
sudo pacman -S grim slurp wl-clipboard cliphist
sudo pacman -S polkit-kde-agent

# keyd (for Caps Lock → Hyper Key remapping)
sudo pacman -S keyd

# Optional but recommended
sudo pacman -S ripgrep fd eza bat
```

### AUR Packages (optional)

```bash
# Using yay or paru
yay -S brave-bin obsidian-bin spotify
```

## Installation

### 1. Clone UKE

```bash
# Clone to your dotfiles directory
git clone https://github.com/YOUR_USERNAME/uke.git ~/dotfiles/uke
cd ~/dotfiles/uke
```

### 2. Run the Installer

```bash
./scripts/install.sh
```

This will:
- Check dependencies
- Generate Hyprland config
- Link binaries to `~/.local/bin`
- Stow dotfiles (wezterm, tmux, zsh, nvim)
- Set up keyd (with sudo prompt)

### 3. Set Up keyd (if not done automatically)

keyd requires root access to write to `/etc/keyd/`:

```bash
# Run the keyd setup script
./scripts/keyd-setup.sh

# Or manually:
sudo mkdir -p /etc/keyd
sudo ln -sf ~/dotfiles/uke/stow/keyd/.config/keyd/default.conf /etc/keyd/default.conf
sudo systemctl enable --now keyd
```

### 4. Add User to Input Group

For keyd to work properly:

```bash
sudo usermod -aG input $USER
# Log out and back in for this to take effect
```

### 5. Verify Installation

```bash
uke-doctor
```

## Configuration

### Modifier Hierarchy on Linux

| Layer | Modifier | Scope |
|:------|:---------|:------|
| PRIMARY | Alt | Window Manager (Hyprland) |
| SECONDARY | Super | Terminal UI (WezTerm) |
| TERTIARY | Super+Shift | Window Resizing |
| QUATERNARY | Ctrl | Shell (never intercepted) |

### Key Bindings

| Action | Keybinding |
|:-------|:-----------|
| Focus window | Alt + hjkl |
| Move window | Alt+Shift + hjkl |
| Resize window | Super+Shift + hjkl |
| Switch workspace | Alt + 1-9, 0 |
| Move to workspace | Alt+Shift + 1-9, 0 |
| Launch terminal | Alt + Return |
| Toggle fullscreen | Alt+Shift + f |
| Toggle float | Alt+Shift + Space |
| Kill window | Alt + q |
| App launcher | Alt+Super + Space |
| Gather windows | Alt + ` |
| Scratchpad terminal | Alt+Shift + ` |

### Caps Lock (via keyd)

| Action | Keybinding |
|:-------|:-----------|
| Escape | Caps (tap) |
| Arrow keys | Caps + hjkl |
| Page Up/Down | Caps + i/u |
| Home/End | Caps + y/o |
| Select | Caps + wasd |
| Word jump | Caps + fg |
| Word select | Caps + qe |
| Toggle Caps Lock | Caps + ' |

## Directory Structure

```
~/dotfiles/uke/
├── config/registry.yaml     # Source of truth (edit this)
├── gen/hyprland/           # Generated config (don't edit)
├── stow/
│   ├── keyd/               # Caps Lock config
│   ├── nvim/               # Neovim config
│   ├── wezterm/            # Terminal config
│   ├── tmux/               # tmux config
│   └── zsh/                # Shell config
├── bin/                    # UKE commands
├── bunches/                # Environment presets
└── scripts/
    ├── install.sh          # Main installer
    └── keyd-setup.sh       # keyd setup helper
```

## Customization

### Edit Hyprland Config

The generated config is at `gen/hyprland/hyprland.conf`. To customize:

1. **For persistent changes**: Edit the generator in `lib/gen.sh`
2. **For quick tests**: Edit the generated file directly (will be overwritten by `uke gen`)

### Custom Autostart

Add your autostart commands to the Hyprland config:

```bash
exec-once = nm-applet
exec-once = blueman-applet
exec-once = /path/to/your/script
```

### Custom Window Rules

Add rules for your applications:

```bash
windowrulev2 = workspace 4, class:^(steam)$
windowrulev2 = float, class:^(mpv)$
```

### Custom Keybindings

```bash
bind = ALT SUPER, p, exec, pavucontrol
bind = ALT SUPER, e, exec, thunar
```

## Troubleshooting

### keyd Not Working

```bash
# Check service status
systemctl status keyd

# Check if user is in input group
groups | grep input

# Reload keyd
sudo keyd reload

# View keyd logs
journalctl -u keyd -f
```

### Hyprland Not Loading Config

```bash
# Check if config is linked correctly
ls -la ~/.config/hypr/hyprland.conf

# Should point to:
# ~/dotfiles/uke/gen/hyprland/hyprland.conf

# Regenerate config
uke gen

# Reload Hyprland
hyprctl reload
```

### Window Rules Not Working

Check the window class name:

```bash
# In Hyprland, open the window then:
hyprctl clients | grep -i class
```

Use the exact class name (case-sensitive) in rules.

### Binaries Not Found

Ensure `~/.local/bin` is in your PATH:

```bash
# Add to ~/.zshrc if not present:
export PATH="$HOME/.local/bin:$PATH"
```

## Updating

```bash
cd ~/dotfiles/uke
git pull
uke gen
uke reload
```

## Uninstalling

```bash
cd ~/dotfiles/uke
./scripts/uke-wipe.sh
```

## Support

- Run `uke-doctor` for diagnostics
- Check `uke-debug dump` for detailed info
- See `docs/TROUBLESHOOTING.md` for common issues
