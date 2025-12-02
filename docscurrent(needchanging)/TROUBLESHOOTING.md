# UKE Troubleshooting

## Diagnostics

```bash
uke-doctor          # Health check
uke-debug dump      # System report
uke-debug trace h   # Trace keybinding
uke validate        # Config validation
uke log tail        # Recent logs
```

## Common Issues

### Keybinding Not Working

1. Check registry:
```bash
yq '.keys[] | select(.key == "h")' config/registry.yaml
```

2. Verify generation:
```bash
uke gen && grep "h" gen/skhd/skhdrc
```

3. Check WM running:
```bash
uke status
```

4. Trace full path:
```bash
uke-debug trace h
```

### Generated Configs Not Applied

```bash
# Verify symlinks
ls -l ~/.config/skhd/skhdrc
ls -l ~/.config/yabai/yabairc

# Regenerate and reload
uke gen && uke reload

# Check WM logs
tail -f /tmp/yabai_*.log   # macOS
journalctl -f -u hyprland  # Linux
```

### Stow Package Not Linked

```bash
# Check package exists
ls -la stow/wezterm/

# Restow
cd stow && stow -R wezterm -t $HOME

# Verify
ls -l ~/.wezterm.lua
```

### Bunch Not Launching Apps

```bash
# Check bunch definition
yq '.bunches.coding' config/registry.yaml

# Test app launch manually
open -b com.github.wez.wezterm  # macOS
wezterm &                       # Linux

# Check bundle ID correct
yq '.apps.wezterm' config/registry.yaml
```

### yq/jq Not Found

```bash
# macOS
brew install yq jq

# Ubuntu/Debian
sudo apt install yq jq

# Arch
sudo pacman -S yq jq

# Verify
uke-doctor
```

### Permission Denied on Binaries

```bash
chmod +x bin/*
chmod +x scripts/install.sh
chmod +x scripts/ai/*.sh
```

## Platform-Specific

### macOS: SIP Restrictions

Some apps can't be controlled by yabai due to System Integrity Protection:
- System Preferences
- System Settings
- Some Apple apps

These are marked `manage=off` in yabairc.

### macOS: Scripting Addition

```bash
# Check SA loaded
yabai --check-sa

# Install SA (requires SIP config)
sudo yabai --install-sa
yabai --load-sa
```

### Linux: Hyprland Not Starting

```bash
# Check Hyprland installed
command -v Hyprland

# Check config syntax
hyprctl reload

# View errors
journalctl -xe | grep hypr
```

### Linux: keyd Not Working

```bash
# keyd requires root
sudo systemctl enable keyd
sudo systemctl start keyd

# Copy config
sudo cp stow/keyd/default.conf /etc/keyd/

# Reload
sudo keyd reload
```

## Reset to Clean State

```bash
# Backup first
uke-backup create

# Remove generated configs
rm -rf gen/*

# Regenerate
uke gen

# Reload
uke reload
```

## Getting Help

1. Run diagnostics: `uke-debug dump > debug.txt`
2. Check logs: `uke log tail`
3. Verify registry: `uke validate`
4. Create issue with debug output
