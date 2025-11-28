# macOS Security Configuration

Yabai Scripting Addition setup and SIP management.

## System Integrity Protection (SIP)

Yabai's Scripting Addition injects into Dock.app, requiring partial SIP disable.

### Check Status

```bash
csrutil status
```

### Disable SIP

**Apple Silicon:**
```bash
# Boot to Recovery: Hold power until "Loading startup options"
# Click Options → Continue → Select admin user → enter password
# Utilities → Terminal

csrutil enable --without fs --without debug --without nvram
reboot
```

**Intel:**
```bash
# Boot to Recovery: Hold Cmd+R during boot
# Utilities → Terminal

csrutil disable --with kext --with dtrace --with nvram --with basesystem
reboot
```

### Re-enable (for system updates)

```bash
# In Recovery Mode Terminal:
csrutil enable
reboot
```

## Yabai Scripting Addition

### Install

```bash
sudo yabai --install-sa
sudo yabai --load-sa
```

### Verify

```bash
yabai --check-sa
# Should show: "Scripting addition installed correctly"
```

### Sudoers (passwordless load)

```bash
sudo visudo -f /private/etc/sudoers.d/yabai
```

Add:
```
<user> ALL=(root) NOPASSWD: sha256:<hash> <path> --load-sa
```

Get hash and path:
```bash
shasum -a 256 $(which yabai)
```

Example:
```
laurenz ALL=(root) NOPASSWD: sha256:abc123... /opt/homebrew/bin/yabai --load-sa
```

### ARM64E Preview ABI (Apple Silicon only)

Required for Scripting Addition on Apple Silicon:

```bash
sudo nvram boot-args=-arm64e_preview_abi
sudo reboot
```

Verify:
```bash
nvram boot-args
```

## Accessibility Permissions

System Settings → Privacy & Security → Accessibility:
- [x] yabai
- [x] skhd
- [x] WezTerm

## Troubleshooting

### "Scripting addition not installed"

```bash
sudo yabai --uninstall-sa
sudo yabai --install-sa
sudo yabai --load-sa
yabai --restart-service
```

### "Operation not permitted"

SIP check:
```bash
csrutil status  # Should show disabled features
yabai --check-sa
```

If enabled, redo SIP disable in Recovery.

### After macOS Update

Updates may re-enable SIP:
```bash
# 1. Check
csrutil status

# 2. If enabled, boot to Recovery and disable again
# 3. Re-install SA
sudo yabai --install-sa
sudo yabai --load-sa

# 4. (Apple Silicon) Re-enable ARM64E
sudo nvram boot-args=-arm64e_preview_abi
sudo reboot
```

## Service Management

```bash
# Start on login
brew services start yabai
brew services start skhd

# Manual control
yabai --restart-service
skhd --restart-service

# Status
brew services list | grep -E "yabai|skhd"
```

## Logs

```bash
tail -f /tmp/yabai_*.err.log
tail -f /tmp/skhd_*.err.log
```

## Complete Setup Sequence

```bash
# 1. Install Homebrew packages
brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd

# 2. Boot to Recovery, disable SIP
# (See "Disable SIP" section above)

# 3. (Apple Silicon only)
sudo nvram boot-args=-arm64e_preview_abi
sudo reboot

# 4. Install Scripting Addition
sudo yabai --install-sa
sudo yabai --load-sa

# 5. Configure sudoers
sudo visudo -f /private/etc/sudoers.d/yabai
# Add line with hash from: shasum -a 256 $(which yabai)

# 6. Deploy configs
cd ~/dotfiles
stow yabai skhd

# 7. Start services
brew services start yabai
brew services start skhd

# 8. Grant Accessibility permissions
# System Settings → Privacy & Security → Accessibility

# 9. Verify
yabai --check-sa
csrutil status
```

## Security Notes

- SIP partial disable reduces system security
- Scripting Addition runs with root privileges
- Only disable minimum required SIP features
- FileVault (disk encryption) unaffected
- Firewall can stay enabled
- Gatekeeper unaffected

## Uninstall

```bash
# 1. Stop services
brew services stop yabai
brew services stop skhd

# 2. Remove Scripting Addition
sudo yabai --uninstall-sa

# 3. Remove sudoers
sudo rm /private/etc/sudoers.d/yabai

# 4. Re-enable SIP
# Boot to Recovery:
csrutil enable
reboot

# 5. (Apple Silicon) Remove ARM64E
sudo nvram -d boot-args
sudo reboot

# 6. Remove configs
rm -rf ~/.config/yabai ~/.config/skhd

# 7. Uninstall packages
brew uninstall yabai skhd
```

---

**Last Updated**: 2024-11-27  
**macOS**: 14+ (Sonoma)  
**Architecture**: Intel & Apple Silicon
