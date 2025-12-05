# Changelog

## v8.1 - Refactoring & Intelligence Update

### 1. Architecture & Organization
- **Platform Separation**: 
  - Created `arch/.local/bin` for Linux-specific scripts.
  - Moved `uke-autostart`, `uke-services`, `uke-update`, `uke-check`, `uke-fix`, and `uke-snapshot` to this directory.
  - `shared/.local/bin` now strictly contains OS-agnostic scripts.
- **Keyd Migration**:
  - Migrated `setup-keyd.sh` to `arch/.local/bin/uke-keyd-setup` to follow naming conventions and avoid home directory pollution.
  - Updated `installation_manager.sh` to call the new path.
  - Added `systemd` checks to prevent errors in containers.
- **Library Sourcing**:
  - Fixed sourcing logic in all Arch scripts to support both repository execution (relative paths) and installed execution (`stow` paths).

### 2. New Tools
- **uke-lookup**: A fuzzy-finder tool (`fzf`) to instantly search:
  - Shell Aliases (`.zshrc`)
  - Hotkeys (`skhdrc` / `hyprland.conf`)
  - Documentation (`UKE_REFERENCE.md`)
  - Wiki (`wikiman` integration)
- **uke-ai**: A local LLM wrapper (`ollama`) that injects `UKE_REFERENCE.md` as context, allowing you to ask questions about your specific configuration.
- **Toolchain**: Added `fzf`, `ollama`, and `wikiman` to the recommended/bootstrap packages.

### 3. Bug Fixes
- **macOS Terminal Launch**: Fixed an issue where `Cmd+Return` (via `skhd`) failed to launch WezTerm because of case sensitivity.
- **App Launching**: Updated `uke-launch` with robust case-insensitive mappings for common macOS apps (`WezTerm`, `Brave Browser`, `Obsidian`, etc.).

### 4. Documentation
- **UKE_REFERENCE.md**: Created a comprehensive reference guide for all scripts and configs.
- **AI_AND_LOOKUP.md**: Created a guide for using the new AI and Lookup tools.
- **UKE_TOOLCHAIN.md**: Fully updated with the complete inventory of tools, categorized by priority.
- **README.md**: Updated directory structure and installation instructions.

---

## v8.0 - Initial Migration (Summary)
- Consolidated previous dotfiles into `newuke` structure (`mac`, `arch`, `shared`).
- Created `installation_manager.sh` for unified setup.
- Created `bootstrap.sh` for Arch Linux "Day 0" setup.