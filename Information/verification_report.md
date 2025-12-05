# Verification Plan

Since we cannot run a VM or modify the actual filesystem in this environment, we verify by inspecting the file structure and code logic.

## 1. File Structure Consistency

We expect `arch` specific scripts to be in `newuke/arch/.local/bin` and shared scripts in `newuke/shared/.local/bin`.

**Check:**
- [x] `newuke/arch/.local/bin/uke-autostart` (Moved)
- [x] `newuke/arch/.local/bin/uke-services` (Moved)
- [x] `newuke/arch/.local/bin/uke-update` (Moved)
- [x] `newuke/shared/.local/bin/uke-launch` (Retained)
- [x] `newuke/shared/.local/bin/uke-doctor` (Retained)

## 2. Logic Verification

### macOS Installation Logic
In `newuke/installation_manager.sh`:
```bash
case "$(uname -s)" in
    Darwin) OS="macos"; PLATFORM_DIR="mac" ;;
    Linux)  OS="linux"; PLATFORM_DIR="arch" ;;
```

And later:
```bash
    # Install Platform
    if ! run_stow "$PLATFORM_DIR"; then failed=1; fi

    # Platform Specific Setup
    if [[ "$OS" == "linux" ]]; then
        if [[ -f "$UKE_ROOT/arch/setup-keyd.sh" ]]; then
            "$UKE_ROOT/arch/setup-keyd.sh" || failed=1
        fi
    fi
```
**Result:** Correct. On macOS (`Darwin`), `PLATFORM_DIR` is `mac`, so it stows `mac/`. It is NOT `linux`, so it skips `setup-keyd.sh`.

### Keyd Setup Logic
In `newuke/arch/setup-keyd.sh`:
- Checks for `keyd` binary.
- Installs via `pacman` if missing (and confirmed by user).
- Links `~/.config/keyd/default.conf` to `/etc/keyd/default.conf`.
- **New:** Checks for systemd presence before attempting service operations.

**Result:** Robust for Arch Linux (systemd) and safer for containers/non-systemd environments.

### Library Sourcing
In `newuke/arch/.local/bin/*`:
- Checks `../lib/core.sh` (Stowed path).
- Fallback to `../../../shared/.local/lib/core.sh` (Repo path).

**Result:** Correctly handles both states.

## Conclusion
The refactoring is complete and logically verified.
