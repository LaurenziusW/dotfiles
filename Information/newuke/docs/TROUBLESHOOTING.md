# UKE v8 - Troubleshooting Guide

## Quick Diagnostics

```bash
# Run health check
uke-doctor

# macOS: Check services
pgrep -l yabai skhd

# Linux: Check Hyprland
echo $HYPRLAND_INSTANCE_SIGNATURE
```

---

## Common Issues

### Keybindings Not Working

**Symptoms:** Pressing Cmd+h doesn't focus window left

**macOS Solutions:**

1. Check skhd is running:
   ```bash
   pgrep skhd || skhd --start-service
   ```

2. Check config is loaded:
   ```bash
   cat ~/.config/skhd/skhdrc | head -20
   ```

3. Reload skhd:
   ```bash
   skhd --reload
   ```

4. Check skhd logs:
   ```bash
   tail -f /tmp/skhd_*.err.log
   ```

5. Restart service:
   ```bash
   skhd --restart-service
   ```

**Linux Solutions:**

1. Check Hyprland is running:
   ```bash
   echo $HYPRLAND_INSTANCE_SIGNATURE
   ```

2. Reload config:
   ```bash
   hyprctl reload
   ```

3. Check logs:
   ```bash
   cat ~/.local/share/hyprland/hyprland.log | tail -50
   ```

---

### Windows Not Moving to Correct Workspaces

**Symptoms:** New windows don't go to their assigned workspace

**Solutions:**

1. Get exact app name (macOS):
   ```bash
   yabai -m query --windows | jq '.[].app'
   ```

2. Get window class (Linux):
   ```bash
   hyprctl clients -j | jq '.[].class'
   ```

3. Check rule syntax in config matches exactly (case-sensitive)

4. Reload window manager:
   ```bash
   # macOS
   yabai --restart-service
   
   # Linux
   hyprctl reload
   ```

---

### Gather Not Working

**Symptoms:** `uke-gather` doesn't move windows

**Solutions:**

1. Check script is executable:
   ```bash
   ls -la ~/.local/bin/uke-gather
   chmod +x ~/.local/bin/uke-gather
   ```

2. Test manually:
   ```bash
   ~/.local/bin/uke-gather
   ```

3. Check app names match what the WM reports:
   ```bash
   # macOS
   yabai -m query --windows | jq '.[].app'
   
   # Linux
   hyprctl clients -j | jq '.[].class'
   ```

4. Verify jq is installed:
   ```bash
   command -v jq || echo "Install jq!"
   ```

---

### WezTerm Shortcuts Not Working

**Symptoms:** Alt+h doesn't navigate panes in WezTerm

**Solutions:**

1. Check WezTerm config exists:
   ```bash
   ls -la ~/.config/wezterm/wezterm.lua
   ```

2. Reload WezTerm config:
   Press `Alt + r` (macOS) or `Super + r` (Linux)

3. Check for conflicts:
   On macOS, ensure skhd isn't intercepting Alt:
   ```bash
   grep "alt - h" ~/.config/skhd/skhdrc
   ```

4. Verify OS detection:
   The SECONDARY modifier should be:
   - macOS: ALT
   - Linux: SUPER

---

### Yabai Not Tiling (macOS)

**Symptoms:** Windows float instead of tiling

**Solutions:**

1. Check yabai is running:
   ```bash
   pgrep yabai || yabai --start-service
   ```

2. Check SIP status:
   ```bash
   csrutil status
   ```
   For workspace features, SIP must be partially disabled.

3. Load scripting addition:
   ```bash
   sudo yabai --load-sa
   ```

4. Check app isn't in float rules:
   ```bash
   grep "manage=off" ~/.config/yabai/yabairc
   ```

---

### Hyprland Gestures Not Working (Linux)

**Symptoms:** Three-finger swipe doesn't change workspaces

**Solutions:**

1. Verify v0.51+ syntax (NO `gestures {}` block!):
   ```ini
   # WRONG (old syntax)
   gestures {
       workspace_swipe = true
   }
   
   # CORRECT (v0.51+)
   gesture = 3, left, workspace, +1
   gesture = 3, right, workspace, -1
   ```

2. Reload config:
   ```bash
   hyprctl reload
   ```

---

### keyd Not Working (Linux)

**Symptoms:** CapsLock doesn't work as Escape

**Solutions:**

1. Check keyd service:
   ```bash
   sudo systemctl status keyd
   ```

2. Copy config to system location:
   ```bash
   sudo cp ~/.config/keyd/default.conf /etc/keyd/default.conf
   ```

3. Restart service:
   ```bash
   sudo systemctl restart keyd
   ```

4. Test keyd:
   ```bash
   sudo keyd -m  # Monitor mode
   ```

---

## Logging

### View Logs

```bash
# UKE state logs
cat ~/.local/state/uke/uke.log

# skhd logs (macOS)
tail -f /tmp/skhd_*.err.log

# yabai logs (macOS)
tail -f /tmp/yabai_*.err.log

# Hyprland logs (Linux)
cat ~/.local/share/hyprland/hyprland.log
```

### Enable Debug Mode

```bash
# Run scripts with debug output
UKE_DEBUG=1 uke-gather
```

---

## Reset to Defaults

If everything is broken:

### macOS

```bash
# Re-stow configs
cd ~/dotfiles/uke-v8
cd shared && stow -R -t ~ .
cd ../mac && stow -R -t ~ .

# Restart services
yabai --restart-service
skhd --restart-service
```

### Linux

```bash
# Re-stow configs
cd ~/dotfiles/uke-v8
cd shared && stow -R -t ~ .
cd ../arch && stow -R -t ~ .

# Reload
hyprctl reload
sudo systemctl restart keyd
```

---

## Checking Stow Symlinks

```bash
# List what stow created
ls -la ~/.config/wezterm/
ls -la ~/.config/skhd/
ls -la ~/.config/yabai/
ls -la ~/.config/hypr/
ls -la ~/.local/bin/uke-*

# Fix broken symlinks
cd ~/dotfiles/uke-v8/shared
stow -R -t ~ .
```

---

## Getting Help

1. Run `uke-doctor` for automated diagnostics
2. Check the relevant log files
3. Verify file permissions and symlinks
4. Ensure all dependencies are installed:
   - macOS: `brew install yabai skhd jq stow`
   - Linux: `pacman -S hyprland waybar jq stow`
