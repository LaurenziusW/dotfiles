# macOS SIP Configuration for Yabai

## Overview

System Integrity Protection (SIP) restricts certain operations on macOS. Yabai requires partial SIP modification for full functionality.

## Feature Comparison

| Feature | SIP Enabled | SIP Partial |
|:--------|:------------|:------------|
| Window focus | ✓ | ✓ |
| Window resize | ✓ | ✓ |
| Window move | ✓ | ✓ |
| Space switching | ✗ | ✓ |
| Space creation | ✗ | ✓ |
| Move to space | ✗ | ✓ |

**Bottom line:** For UKE's workspace management features, you need partial SIP.

## Checking SIP Status

```bash
csrutil status
```

## Modifying SIP (Apple Silicon)

1. **Shut down** your Mac completely

2. **Boot to Recovery:**
   - Hold power button until "Loading startup options" appears
   - Select "Options" → Continue

3. **Open Terminal** from Utilities menu

4. **Run command:**
   ```bash
   csrutil enable --without fs --without debug --without nvram
   ```

5. **Reboot**

6. **Enable ARM64E ABI:**
   ```bash
   sudo nvram boot-args=-arm64e_preview_abi
   ```

7. **Reboot again**

## Modifying SIP (Intel Mac)

1. **Shut down** your Mac completely

2. **Boot to Recovery:**
   - Hold Cmd+R during startup

3. **Open Terminal** from Utilities menu

4. **Run command:**
   ```bash
   csrutil enable --without fs --without debug --without nvram
   ```

5. **Reboot**

## Loading the Scripting Addition

After SIP modification, yabai's scripting addition must be loaded:

```bash
# Add to sudoers for password-less loading
echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai

# Load the scripting addition
sudo yabai --load-sa
```

The yabairc config already includes `sudo yabai --load-sa`.

## Verifying

```bash
# Check SIP status
csrutil status

# Test space switching
yabai -m space --focus 2
```

## Reverting

To restore full SIP:

1. Boot to Recovery
2. Run: `csrutil enable`
3. Reboot

## Security Considerations

Partially disabling SIP reduces system protections. The specific flags disabled:

- `fs`: Filesystem protections (needed for yabai injection)
- `debug`: Debugging restrictions
- `nvram`: Boot argument modifications

This is a trade-off between functionality and security. Consider your threat model.

## References

- [Yabai Wiki: Disabling SIP](https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection)
- [Apple: About SIP](https://support.apple.com/en-us/HT204899)
