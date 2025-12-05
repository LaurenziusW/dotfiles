# UKE v8.1 - Post-Migration Roadmap

**Current Status:** ✅ Migration Complete
The `newuke` directory now contains the fully consolidated v8.1 configuration, separated into `arch/`, `mac/`, and `shared/` components. All legacy scripts and configs have been merged or superseded.

---

## 1. Immediate Verification (QA Phase)

Before performing a destructive installation (`wipe`), run these non-destructive checks to ensure integrity.

### A. File Permissions
Scripts in the repository should be executable to ensure they work immediately after cloning/stowing.
- [ ] Run: `chmod +x newuke/installation_manager.sh newuke/collect-for-ai.sh`
- [ ] Run: `chmod +x newuke/shared/.local/bin/uke-*`
- [ ] Verify: `ls -l newuke/shared/.local/bin/` (Look for 'x' permission)

### B. Static Analysis "Health Check"
Run this command block in your terminal to scan for common migration errors (legacy paths, broken links).

```bash
echo "=== UKE v8.1 Static Analysis ==="
echo "[1] Checking for hardcoded legacy paths..."
grep -r "/Users/laurenz" newuke --exclude-dir=.git || echo "✅ No hardcoded user paths found."

echo "[2] Checking for internal references to 'oldbin'..."
grep -r "oldbin" newuke --exclude-dir=.git || echo "✅ No references to 'oldbin' found."

echo "[3] Checking Shebangs..."
head -n 1 newuke/shared/.local/bin/uke-* | grep "==>" || echo "✅ Shebang check complete (review output above)."

echo "[4] Checking ZSH sourcing..."
grep "source" newuke/shared/.zshrc | grep -v "#"
```

### C. Installation Manager Logic
- [ ] Run `./newuke/installation_manager.sh status`
    - **Expected:** correctly identifies your OS, missing tools (like `stow`), and existing conflict files.
- [ ] Test **Dry Run** (Manual verification):
    - Ensure `do_backup` function logic matches your expectations (it copies files to `~/.local/share/uke-backups`).

---

## 2. Known "Ghost" Files
The following files exist in `newuke` but were not explicitly detailed in the migration report. Verify their purpose:
- `newuke/shared/.local/bin/uke-check`: Likely a system health checker?
- `newuke/shared/.local/bin/uke-keyd-setup`: Likely a helper for Keyd on Linux.
- **Action:** If these are valid, ensure they are documented in `newuke/README.md` or `newuke/docs/CHEATSHEET.md`.

---

## 3. Future Improvements

### Automation & CI
- **ShellCheck:** Run `shellcheck` on all scripts in `.local/bin` to catch potential bugs.
- **Pre-commit Hook:** Add a hook to ensure no sensitive data (API keys) is committed.

### Aesthetic Polish
- **Waybar:** Verify `newuke/arch/.config/waybar/style.css` matches the "Nord/Catppuccin" hybrid theme chosen for WezTerm/Tmux.
- **Neovim:** Verify `init.lua` in `shared` correctly bootstraps `lazy.nvim` on a fresh install.

### Documentation
- **User Guide:** Update `newuke/docs/user_manual.md` with the new `uke-*` command list.
- **Migration Guide:** Add a note for existing users on how to use `installation_manager.sh` to upgrade from v7.
