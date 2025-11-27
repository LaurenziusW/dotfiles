#!/usr/bin/env bash
set -euo pipefail

# ═══════════════════════════════════════════════════════════
# REPOSITORY SYNC
# Push local changes and sync across machines
# ═══════════════════════════════════════════════════════════

readonly REPO_ROOT="${DOTFILES_ROOT:-$HOME/dotfiles}"

cd "$REPO_ROOT" || { echo "ERROR: $REPO_ROOT not found"; exit 1; }

# ───────────────────────────────────────────────────────────
# Status Check
# ───────────────────────────────────────────────────────────

if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "ERROR: Not a git repository"
    exit 1
fi

if [[ -z $(git status --porcelain) ]]; then
    echo "No changes to commit"
    exit 0
fi

# ───────────────────────────────────────────────────────────
# Commit and Push
# ───────────────────────────────────────────────────────────

git status --short
echo ""

read -rp "Commit message: " msg
[[ -z "$msg" ]] && msg="Update dotfiles $(date +%Y-%m-%d)"

git add -A
git commit -m "$msg"
git push

echo ""
echo "✓ Changes synced to remote"
echo "Run './scripts/install.sh' on other machines to pull updates"
