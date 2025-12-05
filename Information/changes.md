# Changelog & Roadmap

## Recent Changes (v8.0 Refactoring)

### 1. Keyd Integration (Linux/Arch)
- **New Script**: Created `newuke/arch/setup-keyd.sh`.
  - Handles installation checks (pacman).
  - Manages sudo-privileged linking of `~/.config/keyd/default.conf` to `/etc/keyd/default.conf`.
  - Manages systemd service (enable/start/reload).
- **Bootstrap Update**: Added `keyd` to the package list in `newuke/arch/bootstrap.sh`.
- **Installation Manager**: Updated `newuke/installation_manager.sh` to automatically run `setup-keyd.sh` on Linux systems after stowing dotfiles.
- **Cleanup**: Removed the redundant/outdated `uke-keyd-setup` from `shared/.local/bin`.

### 2. Script Reorganization
Separated platform-specific binaries from shared binaries to keep the `shared` stow package clean and OS-agnostic.
- **Created**: `newuke/arch/.local/bin`.
- **Moved**:
  - `uke-autostart` (Hyprland-specific) -> `newuke/arch/.local/bin/`.
  - `uke-services` (systemd-specific) -> `newuke/arch/.local/bin/`.
  - `uke-update` (pacman/AUR-specific) -> `newuke/arch/.local/bin/`.
- **Retained in Shared**: `uke-launch`, `uke-sticky`, `uke-scratchpad`, `uke-logs`, `uke-doctor`, `uke-bunch` (these contain cross-platform logic for both macOS and Linux).

---

## Roadmap to Production Readiness

### 1. Critical: Fix Library Sourcing
**Issue**: Scripts moved to `newuke/arch/.local/bin` currently attempt to source `../lib/core.sh`.
- **Problem**: `lib` resides in `newuke/shared/.local/lib`. In the git repository structure, `arch/.local/bin/../lib` does not exist.
- **Solution**: Update the sourcing logic in the moved scripts (`uke-autostart`, `uke-services`, `uke-update`) to support the repository structure:
  ```bash
  # Example Fix Logic
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  # Try standard relative path (installed/stowed state)
  if [[ -f "$SCRIPT_DIR/../lib/core.sh" ]]; then
      source "$SCRIPT_DIR/../lib/core.sh"
  # Try repo sibling path (development/repo state)
  elif [[ -f "$SCRIPT_DIR/../../../shared/.local/lib/core.sh" ]]; then
      source "$SCRIPT_DIR/../../../shared/.local/lib/core.sh"
  fi
  ```

### 2. Documentation
- **README.md**: Update the root and `newuke/README.md` to reflect the new directory structure (`arch/.local/bin`).
- **Install Guide**: Explicitly mention that `keyd` setup requires sudo password entry during the install phase.

### 3. Verification
- **Fresh Install Test**: Run `bootstrap.sh` and `installation_manager.sh` on a clean Arch VM.
- **MacOS Test**: Verify that `installation_manager.sh` on macOS ignores the `arch` folder and `setup-keyd.sh`.
- **Stow Verification**: Ensure `stow` correctly merges `arch/.local/bin` and `shared/.local/bin` into `~/.local/bin` without conflicts.

### 4. Polish
- **Error Handling**: Add a check in `setup-keyd.sh` to ensure it doesn't run if `systemd` is not present (e.g. inside a Docker container or chroot), though less critical for a personal dotfile setup.
