# UKE Scripts & Tools Guide

This document references all the custom scripts and tools included in the **UKE (Ultimate Keyboard Environment)** dotfiles. These tools are designed to streamline workflows, manage the system, and provide unified behavior across macOS and Linux.

## 📦 Core & Installation

These scripts are the foundation of the UKE setup.

### `installation_manager.sh`
The primary entry point for setting up UKE. It handles:
- **Status Check:** `status` - verifies installed tools and detects config conflicts.
- **Installation:** `install` - Uses GNU Stow to link configurations into your home directory.
- **Clean Slate:** `wipe` - Backs up and removes existing configs to ensure a clean install.
- **Backup:** `backup` - Creates a backup of current configs without deletion.

**Location:** Root (`/`)
**Usage:** `./installation_manager.sh [install|wipe|status|backup]`

### `collect-for-ai.sh`
A utility to aggregate relevant codebase files into a single text output. Useful for feeding context to an LLM (like ChatGPT or Gemini) for debugging or feature requests.
**Location:** Root (`/`)

---

## 🚀 Workflow & Productivity

These tools are bound to hotkeys (via `skhd` on Mac or `hyprland` on Linux) for daily driving.

### `uke-launch`
A smart, cross-platform launcher.
- **Function:** Opens apps, files, or URLs using the appropriate system handler.
- **Fixes:** Handles macOS/Linux differences (e.g., `open` vs `xdg-open`).
- **Shortcuts:** Shortcuts like `uke-launch terminal` or `uke-launch browser` map to your preferred apps (defined in the script).
**Usage:** `uke-launch <app_alias|file_path|url>`

### `uke-bunch`
Context switching automation.
- **Function:** Launches a specific "preset" or "bunch" of applications defined for a task (e.g., "coding", "study").
- **Config:** Looks for bunch definitions in `~/.config/uke/bunches/`.
**Usage:** `uke-bunch [coding|reading|email...]`

### `uke-scratchpad`
Manages floating "scratchpad" windows.
- **Function:** Toggles a specific app (like a terminal, notes, or music player) in a floating window. If the app isn't running, it starts it. If it is hidden, it shows it.
**Usage:** `uke-scratchpad [terminal|notes|music]`

### `uke-session`
Basic window layout persistence.
- **Function:** Saves the current arrangement of windows (or just open apps) and attempts to restore them.
**Usage:** `uke-session [save|restore] <name>`

### `uke-gather`
"Gather windows" utility.
- **Function:** Pulls scattered windows back to the current workspace or organizes them. Useful when monitors are disconnected/reconnected.

### `uke-sticky`
Toggles "sticky" state for a window.
- **Function:** Makes the focused window floating, always-on-top, and visible across all workspaces (Pin/Unpin).

---

## 🧠 AI & Information

### `uke-ai`
A CLI wrapper for local LLMs (via `ollama`).
- **Function:** Allows you to ask questions about your dotfiles or general coding queries from the terminal. It can preload context from `UKE_REFERENCE.md`.
**Usage:** `uke-ai "How do I reload skhd?"`

### `uke-lookup`
Quick reference tool.
- **Function:** Greps through documentation or cheatsheets to find keybindings or commands.

---

## 🛠 System Maintenance & Debugging

### `uke-doctor`
A diagnostic tool.
- **Function:** Checks specifically for issues with the environment (PATH, missing dependencies, broken symlinks). More detailed than the installation manager's status check.

### `uke-debug`
Captures debug info for window managers.
- **Function:** Dumps state from `yabai` (Mac) or `hyprctl` (Linux) to help troubleshoot layout issues.

### `uke-logs`
Unified log viewer.
- **Function:** Tails relevant logs for the current session (e.g., Yabai/SKHD logs or Hyprland logs).

### `uke-backup`
Standalone backup script.
- **Function:** Manually triggers the backup routine used by the installation manager.

### `uke-fix`
Emergency reset.
- **Function:** Restarts the window manager (Yabai/Hyprland) and hotkey daemon (SKHD) to recover from a frozen state.

---

## 🐧 Linux / Arch Specific

These scripts reside in `arch/.local/bin` and are only deployed on Linux systems.

### `uke-keyd-setup`
- **Function:** Automates the installation and configuration of `keyd` (system-level key remapper). Handles sudo permissions to link the config to `/etc/keyd/`.

### `uke-check`
- **Function:** Checks for updates to Arch packages (pacman) and AUR helper (paru/yay) without installing them. Used for status bar indicators.

### `uke-services`
- **Function:** Manages user-level systemd services relevant to the graphical session (e.g., restarting Waybar, SwayNC).

### `uke-snapshot`
- **Function:** Wrapper for system snapshots (using Timeshift or Snapper). Allows creating/restoring checkpoints before dangerous operations.

### `uke-autostart`
- **Function:** Handles the startup sequence for the Hyprland session (launching bar, wallpaper, notification daemon, etc.).
