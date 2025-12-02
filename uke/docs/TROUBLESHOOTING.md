# UKE v6.1 - Troubleshooting Guide

## Quick Diagnostics

```bash
# Run health check
uke-doctor

# Full debug report
uke-debug dump

# Check if services are running
pgrep -l yabai skhd    # macOS
echo $HYPRLAND_INSTANCE_SIGNATURE  # Linux
```

---

## Common Issues

### Keybindings Not Working

**Symptoms:** Pressing Cmd+h doesn't focus window left

**Solutions:**

1. **Check skhd is running:**
   ```bash
   pgrep skhd || skhd --start-service
   ```

2. **Check config is loaded:**
   ```bash
   cat ~/.config/skhd/skhdrc | head -20
   ```

3. **Regenerate and reload:**
   ```bash
   uke gen && uke reload
   ```

4. **Check skhd logs:**
   ```bash
   tail -f /tmp/skhd_*.err.log
   ```

5. **Verify symlink:**
   ```bash
   ls -la ~/.config/skhd/skhdrc
   # Should point to ~/dotfiles/uke/gen/skhd/skhdrc
   ```

---

### Windows Not Moving to Correct Workspaces

**Symptoms:** New windows don't go to their assigned workspace

**Solutions:**

1. **Check app name is exact:**
   ```bash
   # Get exact app name
   yabai -m query --windows | jq '.[].app'
   ```
   
   Compare with rules in `gen/yabai/yabairc`. Names must match exactly (case-sensitive).

2. **Check rule syntax:**
   ```bash
   # Rules should look like:
   yabai -m rule --add app="^Brave Browser$" space=^1
   ```

3. **Reload yabai:**
   ```bash
   yabai --restart-service
   ```

---

### Gather Not Working (Cmd + `)

**Symptoms:** Pressing Cmd+` doesn't move windows

**Solutions:**

1. **Check uke-gather is executable:**
   ```bash
   ls -la ~/.local/bin/uke-gather
   chmod +x ~/.local/bin/uke-gather
   ```

2. **Test manually:**
   ```bash
   ~/.local/bin/uke-gather
   ```

3. **Check app names match:**
   The app names in `uke-gather` must exactly match what yabai reports:
   ```bash
   yabai -m query --windows | jq '.[].app'
   ```

4. **Check keybinding:**
   ```bash
   grep "0x32" ~/.config/skhd/skhdrc
   # Should show: cmd - 0x32 : $HOME/.local/bin/uke-gather
   ```

---

### WezTerm Shortcuts Not Working

**Symptoms:** Alt+h doesn't navigate panes in WezTerm

**Solutions:**

1. **Check WezTerm config is loaded:**
   ```bash
   ls -la ~/.wezterm.lua
   ```

2. **Reload WezTerm config:**
   Press `Alt + r` (or `Super + r` on Linux)

3. **Check for conflicts:**
   On macOS, ensure skhd isn't intercepting Alt. Check `skhdrc` for:
   ```
   alt - h : ...  # This would conflict!
   ```

4. **Verify OS detection:**
   In WezTerm, the SECONDARY modifier should be:
   - macOS: ALT
   - Linux: SUPER

---

### Bunches Not Launching

**Symptoms:** Cmd+Ctrl+1 doesn't launch study environment

**Solutions:**

1. **Check bunch exists:**
   ```bash
   ls -la ~/dotfiles/uke/bunches/study.sh
   ```

2. **Make executable:**
   ```bash
   chmod +x ~/dotfiles/uke/bunches/*.sh
   ```

3. **Test manually:**
   ```bash
   uke-bunch study
   ```

4. **Check keybinding:**
   ```bash
   grep "cmd + ctrl - 1" ~/.config/skhd/skhdrc
   ```

---

### Yabai Not Tiling

**Symptoms:** Windows float instead of tiling

**Solutions:**

1. **Check yabai is running:**
   ```bash
   pgrep yabai || yabai --start-service
   ```

2. **Check SIP status:**
   ```bash
   csrutil status
   ```
   
   For full functionality, SIP must be partially disabled. See `docs/security/MACOS-SIP.md`.

3. **Load scripting addition:**
   ```bash
   sudo yabai --load-sa
   ```

4. **Check app isn't in float rules:**
   ```bash
   grep "manage=off" ~/.config/yabai/yabairc
   ```

---

### Borders Not Showing

**Symptoms:** No colored border around active window

**Solutions:**

1. **Check borders is installed:**
   ```bash
   which borders || brew install FelixKratz/formulae/borders
   ```

2. **Check it's running:**
   ```bash
   pgrep borders
   ```

3. **Restart manually:**
   ```bash
   pkill borders
   borders width=3 active_color=0xff88c0d0 inactive_color=0xff3b4252 &
   ```

---

### Linux (Hyprland) Issues

**Symptoms:** Keybindings not working on Linux

**Solutions:**

1. **Check Hyprland is running:**
   ```bash
   echo $HYPRLAND_INSTANCE_SIGNATURE
   ```

2. **Check config is loaded:**
   ```bash
   cat ~/.config/hypr/hyprland.conf | head -30
   ```

3. **Reload Hyprland:**
   ```bash
   hyprctl reload
   ```

4. **Check keybinding syntax:**
   ```bash
   # Correct format:
   bind = ALT, H, movefocus, l
   ```

---

## Logging

### View Logs

```bash
# UKE logs
uke log tail
uke log tail 100  # Last 100 lines

# skhd logs (macOS)
tail -f /tmp/skhd_*.err.log

# yabai logs (macOS)
tail -f /tmp/yabai_*.err.log

# Hyprland logs (Linux)
cat ~/.local/share/hyprland/hyprland.log
```

### Clear Logs

```bash
uke log clear
```

---

## Reset to Defaults

If everything is broken:

```bash
# Backup current state
uke-backup

# Regenerate everything
cd ~/dotfiles/uke
./bin/uke gen

# Re-stow dotfiles
cd stow
stow -R wezterm tmux zsh nvim

# Re-link configs
ln -sf ~/dotfiles/uke/gen/skhd/skhdrc ~/.config/skhd/skhdrc
ln -sf ~/dotfiles/uke/gen/yabai/yabairc ~/.config/yabai/yabairc

# Restart services
yabai --restart-service
skhd --restart-service
```

---

## Getting Help

1. Run `uke-doctor` for automated diagnostics
2. Run `uke-debug dump` for full system report
3. Check the logs for error messages
4. Verify file permissions and symlinks
5. Ensure all dependencies are installed
