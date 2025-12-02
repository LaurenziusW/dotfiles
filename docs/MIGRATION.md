# UKE v6.1 - Migration Guide

## Upgrading from Previous Versions

### From v5.x or Earlier

1. **Backup existing configs:**
   ```bash
   cp -r ~/dotfiles/uke ~/dotfiles/uke-backup
   ```

2. **Extract new version:**
   ```bash
   tar -xzf uke-v6.1-complete.tar.gz -C ~/dotfiles/
   ```

3. **Regenerate configs:**
   ```bash
   cd ~/dotfiles/uke
   ./bin/uke gen
   ```

4. **Re-stow dotfiles:**
   ```bash
   cd ~/dotfiles/uke/stow
   stow -R wezterm tmux zsh nvim
   ```

5. **Reload services:**
   ```bash
   uke reload
   ```

---

## Key Changes in v6.1

### Restored Features

- **4px padding** (was 8px in some versions)
- **Click-to-focus** (mouse_follows_focus OFF)
- **Borders utility** with Nord colors
- **Smart Focus** (Cmd+Escape)
- **Advanced layouts**: Stack, Rotate, Mirror, Balance
- **Layout toggle**: BSP ↔ Stack (Cmd+Ctrl+t)

### New Features

- **Bunches system** with individual scripts
- **lib-os-detect.sh** for cross-platform helpers
- **bunch-manager.sh** CLI
- **Improved uke-gather** with correct app name matching

### Fixed Issues

- **App name matching**: Uses actual names ("Brave Browser") not bundle IDs
- **Numeric workspace keys**: Correctly handled in skhd (0x1D for key 0)
- **Gather script**: Now properly moves windows

---

## File Location Changes

| What | Old Location | New Location |
|:-----|:-------------|:-------------|
| Bunches | `~/workflow/bunches/` | `~/dotfiles/uke/bunches/` |
| WezTerm | `~/.wezterm.lua` | `~/dotfiles/uke/stow/wezterm/.wezterm.lua` |
| tmux | `~/.tmux.conf` | `~/dotfiles/uke/stow/tmux/.tmux.conf` |
| zsh | `~/.zshrc` | `~/dotfiles/uke/stow/zsh/.zshrc` |

---

## Configuration Migration

### If You Have Custom Bunches

Your old bunches in `~/workflow/bunches/` can be moved:

```bash
# Copy old bunches
cp ~/workflow/bunches/*.sh ~/dotfiles/uke/bunches/

# Update the source line in each bunch:
# Old: source "$(dirname "$0")/lib-os-detect.sh"
# New: source "$(dirname "$0")/lib-os-detect.sh"  # Same, should work
```

### If You Have Custom Keybindings

Add them to `config/registry.yaml` or directly edit the generated configs:

```bash
# Edit registry (preferred)
uke edit

# Or edit generated config directly (will be overwritten by uke gen)
uke edit skhd
```

### If You Have Custom App Assignments

Edit the workspaces section in `config/registry.yaml`:

```yaml
workspaces:
  1:  { name: "browser", apps: [safari, brave, firefox] }  # Add firefox
  11: { name: "gaming",  apps: [steam] }  # Add new workspace
```

---

## Verifying Migration

Run the health check:

```bash
uke-doctor
```

Expected output:
```
✓ stow installed
✓ jq installed
✓ yabai installed
✓ skhd installed
✓ registry.yaml exists
✓ skhd config generated
✓ yabai config generated
✓ yabai running
✓ skhd running
```

Test key functions:

```bash
# Test gather
uke-gather

# Test bunches
uke-bunch list
uke-bunch study

# Test generation
uke gen
```

---

## Rolling Back

If something goes wrong:

```bash
# Restore from backup
rm -rf ~/dotfiles/uke
mv ~/dotfiles/uke-backup ~/dotfiles/uke

# Regenerate and reload
cd ~/dotfiles/uke
./bin/uke gen
uke reload
```

---

## Getting Help

1. Check `docs/TROUBLESHOOTING.md` for common issues
2. Run `uke-debug dump` for diagnostics
3. Compare your config with the default `config/registry.yaml`
