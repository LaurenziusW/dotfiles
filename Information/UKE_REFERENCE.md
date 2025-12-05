# UKE v8 Reference Guide

This document provides a comprehensive reference for all scripts and configurations included in UKE v8.

---

## 1. Setup & Installation Scripts

These scripts are used to bootstrap and maintain the dotfiles installation.

### `installation_manager.sh`
**Location:** `newuke/installation_manager.sh`
**Purpose:** The primary entry point for installing, checking, and wiping UKE configurations. It handles symlinking via GNU Stow and detects the operating system.

| Command | Description |
|:--------|:------------|
| `status` | (Default) Checks system health, installed tools, and detects conflicting config files. |
| `install` | Symlinks all configurations using `stow`. Runs post-install hooks (like `setup-keyd.sh` on Linux). |
| `wipe` | **Destructive.** Backs up and then deletes existing config files in `~` to prepare for a clean install. |
| `backup` | Creates a timestamped backup of current configurations in `~/.local/share/uke-backups/`. |

### `bootstrap.sh`
**Location:** `newuke/arch/bootstrap.sh`
**Purpose:** **Arch Linux only.** A "Day 0" script to run on a fresh Arch install. It installs essential packages (git, stow, hyprland, keyd, etc.) and sets up a minimal recovery environment so you can boot into a GUI to clone the repo.

**Actions:**
1. Updates system (`pacman -Syu`).
2. Installs base packages (hyprland, waybar, wezterm, keyd, etc.).
3. Creates directory structure (`~/.config/...`).
4. Generates a minimal recovery `hyprland.conf`.
5. Creates dummy local override files to prevent Stow errors.

### `uke-keyd-setup`
**Location:** `~/.local/bin/` (stowed from `newuke/arch/.local/bin`)
**Purpose:** **Linux only.** Handles the privileged (root) setup required for the `keyd` keyboard remapping daemon.

**Actions:**
1. Checks if `keyd` is installed (offers to install via pacman).
2. Symlinks `~/.config/keyd/default.conf` to `/etc/keyd/default.conf` (requires sudo).
3. Enables and reloads the `keyd` systemd service (requires sudo).

---

## 2. Shared CLI Tools
**Location:** `~/.local/bin/` (stowed from `newuke/shared/.local/bin`)
**Compatibility:** Works on **macOS** and **Linux**.

### `uke-launch`
Smart launcher for apps, files, and URLs. Used by the window manager config.

| Usage | Description |
|:------|:------------|
| `uke-launch browser` | Opens default browser (Safari/Brave). |
| `uke-launch terminal` | Opens terminal (WezTerm). |
| `uke-launch <file>` | Opens file with appropriate default app (PDF->Preview/Zathura, etc.). |
| `uke-launch <url>` | Opens URL in default browser. |

### `uke-sticky`
Toggles "sticky" mode for the focused window: floating, always-on-top, and pinned to all workspaces.

| Usage | Description |
|:------|:------------|
| `uke-sticky toggle` | (Default) Toggles sticky state for current window. |
| `uke-sticky list` | Lists currently sticky windows. |
| `uke-sticky clear` | Resets all sticky windows to normal. |

### `uke-scratchpad`
Manages dropdown/toggle windows (scratchpads).

| Usage | Description |
|:------|:------------|
| `uke-scratchpad terminal` | Toggles the terminal scratchpad. |
| `uke-scratchpad notes` | Toggles Obsidian. |
| `uke-scratchpad music` | Toggles Spotify. |
| `uke-scratchpad calc` | Toggles Calculator. |

### `uke-gather`
Organizes open windows by moving them to their assigned workspaces based on application type (e.g., Browser -> WS1, Code -> WS3).

| Usage | Description |
|:------|:------------|
| `uke-gather` | Runs the gather logic for the *current* workspace. |

### `uke-session`
Saves and restores window layouts (experimental).

| Usage | Description |
|:------|:------------|
| `uke-session save <name>` | Saves current open windows and their positions to a JSON file. |
| `uke-session restore <name>` | Attempts to move windows back to saved positions. |
| `uke-session list` | Lists saved sessions. |

### `uke-bunch`
Environment preset runner. Launches groups of apps defined in `~/.config/uke/bunches/`.

| Usage | Description |
|:------|:------------|
| `uke-bunch <name>` | Executes the bunch script (e.g., `coding`, `study`). |
| `uke-bunch list` | Lists available bunches. |

### `uke-doctor`
Health check utility.

| Usage | Description |
|:------|:------------|
| `uke-doctor` | Runs diagnostics on dependencies, configs, and services. |

### `uke-logs`
Live log viewer for debugging.

| Usage | Description |
|:------|:------------|
| `uke-logs uke` | Tails UKE internal logs. |
| `uke-logs yabai` | Tails Yabai logs (macOS). |
| `uke-logs skhd` | Tails SKHD logs (macOS). |
| `uke-logs hyprland` | Tails Hyprland logs (Linux). |

### `uke-backup`
Creates manual backups of the UKE configuration state.

| Usage | Description |
|:------|:------------|
| `uke-backup create` | Creates a full backup in `~/.local/share/uke/backups`. |
| `uke-backup list` | Lists available backups. |

### `uke-debug`
System diagnostics helper.

| Usage | Description |
|:------|:------------|
| `uke-debug dump` | Prints system info and tool versions. |
| `uke-debug trace <key>` | Searches for a keybinding in config files. |

### `uke-lookup`
Deterministic fuzzy finder for configuration details.

| Usage | Description |
|:------|:------------|
| `uke-lookup` | Interactive menu to select category. |
| `uke-lookup aliases` | FZF search through `.zshrc` aliases. |
| `uke-lookup keys` | FZF search through `skhdrc` (macOS) or `hyprland.conf` (Linux). |
| `uke-lookup docs` | FZF search through headers in `UKE_REFERENCE.md`. |

### `uke-ai`
Local AI assistant (via Ollama) aware of the UKE documentation.

| Usage | Description |
|:------|:------------|
| `uke-ai "question"` | Ask the AI a question. It uses `UKE_REFERENCE.md` as context. |

---

## 3. Arch Linux Specific Tools
**Location:** `~/.local/bin/` (stowed from `newuke/arch/.local/bin`)
**Compatibility:** **Arch Linux Only**.

### `uke-autostart`
Robust Hyprland launcher. Handles crash detection and loop prevention. Called from `.zprofile`.

| Flags | Description |
|:------|:------------|
| `--debug` | Starts Hyprland with output logged to console/file. |
| `--skip` | Skips starting Hyprland (drops to TTY). |

### `uke-update`
Unified system updater wrapper.

| Flags | Description |
|:------|:------------|
| `--system` | Updates official packages (`pacman -Syu`). |
| `--aur` | Updates AUR packages (`yay` or `paru`). |
| `--uke` | Pulls latest changes from dotfiles repo. |
| `--all` | (Default) Runs all of the above. |

### `uke-services`
Checks status of systemd services.

| Usage | Description |
|:------|:------------|
| `uke-services status` | Lists status of key services (keyd, bluetooth, pipewire, etc.). |

### `uke-check`
Audits installed packages against the "UKE Standard" list.

| Usage | Description |
|:------|:------------|
| `uke-check` | Interactive mode: verify and install missing packages. |
| `uke-check --check` | Non-interactive: just print missing packages. |

### `uke-fix`
Quick-fix utility for common runtime issues.

| Flags | Description |
|:------|:------------|
| (no args) | Auto-detects and fixes broken audio/keys/bar. |
| `--audio` | Restarts PipeWire stack. |
| `--display` | Reloads Hyprland config. |
| `--keys` | Restarts keyd service. |
| `--waybar` | Restart Waybar. |
| `--clipboard` | Clears clipboard history (fix for stuck paste). |

### `uke-snapshot`
Wrapper for system snapshots (TimeShift or Snapper).

| Usage | Description |
|:------|:------------|
| `uke-snapshot create [desc]` | Creates a manual snapshot. |
| `uke-snapshot list` | Lists snapshots. |

---

## 4. Configuration Files

### Shared Configurations
**Location:** `newuke/shared/`
These apply to both macOS and Linux.

*   **`.config/nvim/`**: Neovim configuration (Kickstart-based).
*   **`.config/wezterm/`**: WezTerm configuration.
    *   `wezterm.lua`: Main config. Detects OS for font size/key modifications.
    *   `local.lua`: (Ignored) For hardware-specific overrides.
*   **`.config/tmux/`**: Tmux configuration.
*   **`.zshrc`**: Zsh shell configuration. Sources `.zshrc.local` if present.

### Arch Linux Configurations
**Location:** `newuke/arch/`
These are only stowed on Linux.

*   **`.config/hypr/`**: Hyprland configuration.
    *   `hyprland.conf`: Main compositor config.
    *   `local.conf`: (Ignored) Monitor/hardware overrides.
*   **`.config/waybar/`**: Status bar configuration (style & layout).
*   **`.config/keyd/`**: System-level keyboard remapping (CapsLock -> Nav Layer).
*   **`.config/zathura/`**: PDF viewer configuration (Nord theme).

### macOS Configurations
**Location:** `newuke/mac/`
These are only stowed on macOS.

*   **`.config/yabai/`**: Tiling window manager rules.
*   **`.config/skhd/`**: Hotkey daemon configuration.
