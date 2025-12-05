<!-- AI PROMPT START -->
You are an AI assistant helping to migrate and consolidate a complex dotfiles configuration ("UKE v8/v8.1") into a clean, unified directory structure called `newuke`.

**Context:**
We are manually rebuilding the project from scratch to ensure a clean state.
- Source directories: `uke/` (original v8 structure), `newconfigs/` (v8.1 updates), `currentconfigs/` (active configs), `old configs (reference)/`.
- Target directory: `newuke/` (already created with skeleton).

**Goal:**
Populate every file in `newuke/` with the *best available version* of that file.
- For core configs (`.zshrc`, `wezterm`, `tmux`, `skhd`, `yabai`), prefer `newconfigs/` (v8.1).
- For Arch Linux configs (`hyprland`, `waybar`, etc.), prefer `uke/arch/` (unless a newer one exists).
- For scripts, merge `newconfigs/bin` into `shared/.local/bin`.
- For docs, we have already populated `README.md` and `docs/`.

**Instructions for the AI:**
1.  **Read this TODO list below.**
2.  **Pick the next unchecked item.**
3.  **READ the source file(s)** mentioned in the item. DO NOT assume content. Read the *entire* file to ensure no truncation.
4.  **WRITE the file** to the target path in `newuke/`.
5.  **DO NOT** update this `TODO.md` file yourself. The user will check off items manually.
6.  **Ask for confirmation** before proceeding to the next batch of files.

**Current Status:**
Docs are done. We are about to start with root scripts and dotfiles.
<!-- AI PROMPT END -->

# Project Migration TODO List

## Root Files
- [x] `newuke/installation_manager.sh` (Source: `uke/installation_manager.sh` - check if `currentconfigs` version is newer)
- [x] `newuke/.gitignore` (Source: `uke/.gitignore`)
- [x] `newuke/collect-for-ai.sh` (Source: `uke/collect-for-ai.sh`)

## macOS Configs (Target: `newuke/mac/.config/...`)
- [x] `skhd/skhdrc` (Source: `newconfigs/skhdrc1`)
- [x] `yabai/yabairc` (Source: `newconfigs/yabairc1`)

## Arch Linux Configs (Target: `newuke/arch/.config/...`)
- [X] `hypr/hyprland.conf` (Source: `uke/arch/.config/hypr/hyprland.conf` - check `currentconfigs`)
- [X] `waybar/config` (Source: `uke/arch/.config/waybar/config`)
- [X] `waybar/style.css` (Source: `uke/arch/.config/waybar/style.css`)
- [X] `keyd/default.conf` (Source: `uke/arch/.config/keyd/default.conf`)
- [X] `zathura/zathurarc` (Source: `uke/arch/.config/zathura/zathurarc`)

## Shared Configs (Target: `newuke/shared/...`)
- [X] `.zshrc` (Source: `newconfigs/.zshrc1`)
- [X] `.config/tmux/tmux.conf` (Source: `newconfigs/.tmux1.conf`)
- [X] `.config/wezterm/wezterm.lua` (Source: `newconfigs/wezterm1.lua`)

## Shared Scripts (Target: `newuke/shared/.local/bin/...`)
- [x] `uke-autostart` (Source: `newconfigs/bin/uke-autostart` vs `oldbin/uke-autostart`)
- [x] `uke-bunch` (Source: `newconfigs/bin/uke-bunch` vs `oldbin/uke-bunch`)
- [x] `uke-doctor` (Source: `newconfigs/bin/uke-doctor` vs `oldbin/uke-doctor`)
- [x] `uke-gather` (Source: `newconfigs/bin/uke-gather` vs `oldbin/uke-gather`)
- [x] `uke-launch` (Source: `newconfigs/bin/uke-launch` vs `oldbin/uke-launch`)
- [x] `uke-scratchpad` (Source: `newconfigs/bin/uke-scratchpad` vs `oldbin/uke-scratchpad`)
- [x] `uke-session` (Source: `newconfigs/bin/uke-session` vs `oldbin/uke-session`)
- [x] `uke-snapshot` (Source: `newconfigs/bin/uke-snapshot` vs `oldbin/uke-snapshot`)
- [x] `uke-sticky` (Source: `newconfigs/bin/uke-sticky` vs `oldbin/uke-sticky`)
- [x] `uke-fix` (Source: `oldbin/uke-fix` - check if this functionality exists elsewhere)
- [x] `uke-backup` (Source: `oldbin/uke-backup`)
- [x] `uke-debug` (Source: `oldbin/uke-debug`)
- [x] `uke-logs` (Source: `oldbin/uke-logs`)
- [x] `uke-setup` (Source: `oldbin/uke-setup`)
- [x] `uke-services` (Source: `oldbin/uke-services`)
- [x] `uke-update` (Source: `oldbin/uke-update`)
- [x] `gather-current-space.sh` (Source: `oldbin/gather-current-space.sh` - likely merged into `uke-gather`)

## Libraries & Dev (Target: `newuke/...`)
- [x] `shared/.local/lib/lib-os-detect.sh` (Skipped - redundant with `core.sh`)
- [x] `dev/generate_v8_bin.py` (Skipped - obsolete generator)

## Extras
- [x] `newuke/shared/.config/uke/bunches/README.md` (Created)

## Neovim (Target: `newuke/shared/.config/nvim/...`)
*(Source: `uke/shared/.config/nvim` recursively)*
- [x] `init.lua`
- [x] `lazy-lock.json`
- [x] `LICENSE.md`
- [x] `README.md`
- [x] `doc/kickstart.txt`
- [x] `doc/tags`
- [x] `lua/custom/plugins/init.lua`
- [x] `lua/kickstart/health.lua`
- [x] `lua/kickstart/plugins/autopairs.lua`
- [x] `lua/kickstart/plugins/debug.lua`
- [x] `lua/kickstart/plugins/gitsigns.lua`
- [x] `lua/kickstart/plugins/indent_line.lua`
- [x] `lua/kickstart/plugins/lint.lua`
- [x] `lua/kickstart/plugins/neo-tree.lua`
