# Future Improvements & Ideas

## 1. Installer Enhancements
- [ ] **Interactive Tool Selection**: Update `installation_manager.sh` or create a new `uke-install-extras` script that iterates through the "Extended Arsenal" in `UKE_TOOLCHAIN.md` and asks the user (Yes/No) to install each category (e.g., "Install Rust Tools?", "Install AI Tools?").
- [ ] **Theme Selector**: Add a way to switch themes (Nord, Catppuccin, Dracula) across all configs (WezTerm, Neovim, Hyprland/Yabai) with a single command.

## 2. Shell & Workflow
- [ ] **Full `thefuck` Integration**: Ensure `thefuck` is aliased to `fuck` or `f` and works seamlessly in `.zshrc`.
- [ ] **Zoxide Expansion**: Verify `zoxide` is fully replacing `cd` habits. Add aliases like `zi` (interactive selection).
- [ ] **Lazygit Integration**: Create a `uke-git` wrapper or alias `lg` that launches `lazygit` but falls back to standard git status if not installed.

## 3. AI Evolution
- [ ] **Model Switching**: Add a flag to `uke-ai` (e.g., `--model codellama`) to switch models on the fly without editing the script.
- [ ] **Context Expansion**: Allow `uke-ai` to ingest other config files (like `.zshrc` or `init.lua`) for more specific answers about code/aliases.

## 4. System Monitoring
- [ ] **Dashboard**: Create a custom `btop` theme or layout that matches the UKE aesthetic.
- [ ] **Hyprland/Waybar**: Polish the Waybar CSS to fully match the WezTerm theme (colors, rounding, fonts).

## 5. Neovim
- [ ] **Lazy.nvim Bootstrap**: Double-check that the shared `init.lua` correctly bootstraps `lazy.nvim` on a completely fresh machine without manual intervention.
- [ ] **LSP Config**: Ensure the LSP setup in Neovim is robust for the core languages used (Python, Bash, Lua, Rust).

## 6. Testing & CI
- [ ] **ShellCheck**: Run `shellcheck` on all `uke-*` scripts to ensure POSIX compliance and catch hidden bugs.
- [ ] **Pre-commit Hooks**: Implement hooks to prevent committing secrets or large files.