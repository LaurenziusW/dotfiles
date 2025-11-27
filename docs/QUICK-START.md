# Quick Start: New Maintenance Suite

## ⚡ 5-Minute Setup

### 1. Download Scripts to Your Dotfiles

```bash
cd ~/dotfiles/scripts/maintenance

# Copy each script (get them from Claude/outputs)
# Then make executable:
chmod +x collect-context.sh system-health.sh cleanup-artifacts.sh fulldump.sh
```

### 2. Test They Work

```bash
# Quick test - should show help text
./system-health.sh --help
./collect-context.sh --help
./cleanup-artifacts.sh --help
./fulldump.sh --help
```

### 3. Run Health Check

```bash
# See if your system is healthy
./system-health.sh

# Expected output: All green ✓ checkmarks
# If you see ✗ or ⚠, the script will tell you how to fix it
```

### 4. Clean Up Old Artifacts (Safe)

```bash
# First, preview what would be deleted (SAFE - doesn't delete anything)
./cleanup-artifacts.sh --dry-run

# If it looks good, run with backup
./cleanup-artifacts.sh --backup

# This removes duplicate scripts and temp files
# Backup saved to: ~/dotfiles/.cleanup-backup-TIMESTAMP/
```

### 5. Verify Everything Still Works

```bash
# Run health check again
./system-health.sh --verbose

# Should still be all green ✓
```

---

## 🎯 Daily Usage

### Quick Health Check (30 seconds)

```bash
cd ~/dotfiles/scripts/maintenance
./system-health.sh
```

If all green ✓ → You're good!  
If yellow ⚠ or red ✗ → Script tells you how to fix

### Before Asking AI for Help

```bash
# Generate context files
./collect-context.sh --tarball

# Upload the .tar.gz file to Claude/ChatGPT
# Or upload individual .md files from ~/ai-context-TIMESTAMP/
```

### Before Making Big Changes

```bash
# Create system snapshot
./fulldump.sh

# Save it for comparison later
cp ~/system-state-*.txt ~/safe-backup/
```

### After Updates

```bash
# Verify everything works
./system-health.sh --verbose

# Clean up any mess
./cleanup-artifacts.sh --dry-run
./cleanup-artifacts.sh --backup
```

---

## 📝 What Each Script Does

| Script | When to Use | Takes |
|--------|-------------|-------|
| **system-health.sh** | Daily check, after changes | 30 sec |
| **collect-context.sh** | Before asking AI for help | 1 min |
| **cleanup-artifacts.sh** | Monthly, after major updates | 30 sec |
| **fulldump.sh** | Before risky changes, debugging | 1 min |

---

## 🔥 Most Important Commands

```bash
# The one command you'll use every day:
./system-health.sh

# The one command for AI help:
./collect-context.sh --tarball

# The one command for safety:
./fulldump.sh
```

---

## 🆘 Troubleshooting

### "Permission denied"
```bash
chmod +x ~/dotfiles/scripts/maintenance/*.sh
```

### "No such file or directory"
```bash
# You're in the wrong directory
cd ~/dotfiles/scripts/maintenance
```

### "System health shows errors"
```bash
# Run with verbose flag to see details
./system-health.sh --verbose

# It will tell you exactly what's wrong and how to fix it
```

### "I want to undo cleanup"
```bash
# If you used --backup, restore from:
cp -a ~/dotfiles/.cleanup-backup-TIMESTAMP/* ~/dotfiles/
```

---

## ✅ Success Checklist

After setup, verify:

- [ ] Scripts are in `~/dotfiles/scripts/maintenance/`
- [ ] Scripts are executable (`ls -l` shows `-rwxr-xr-x`)
- [ ] `./system-health.sh` shows all green ✓
- [ ] `./collect-context.sh` creates files in `~/ai-context-*/`
- [ ] `./cleanup-artifacts.sh --dry-run` shows what would be deleted
- [ ] `./fulldump.sh` creates `~/system-state-*.txt`

If all checked ✓ → **You're done! 🎉**

---

## 💡 Pro Tips

1. **Add alias to your shell**:
   ```bash
   echo 'alias health="~/dotfiles/scripts/maintenance/system-health.sh"' >> ~/.zshrc
   source ~/.zshrc
   
   # Now just type: health
   ```

2. **Create git hook for automatic health check**:
   ```bash
   # Before each push, check health
   echo '#!/bin/bash' > ~/dotfiles/.git/hooks/pre-push
   echo '~/dotfiles/scripts/maintenance/system-health.sh' >> ~/dotfiles/.git/hooks/pre-push
   chmod +x ~/dotfiles/.git/hooks/pre-push
   ```

3. **Monthly cleanup routine**:
   ```bash
   # First day of month
   cd ~/dotfiles/scripts/maintenance
   ./cleanup-artifacts.sh --dry-run
   ./cleanup-artifacts.sh --backup
   ./system-health.sh --verbose
   ```

4. **Before asking for help**:
   ```bash
   # Always provide fresh context
   cd ~/dotfiles/scripts/maintenance
   ./collect-context.sh --tarball
   # Upload the .tar.gz to AI
   ```

---

## 📚 Full Documentation

For detailed information, see:
- **[MAINTENANCE-SUITE-GUIDE.md](computer:///mnt/user-data/outputs/MAINTENANCE-SUITE-GUIDE.md)** - Complete guide with all features
- **[README.md](computer:///mnt/user-data/outputs/README.md)** - Main project documentation
- **[PHILOSOPHY.md](computer:///mnt/user-data/outputs/PHILOSOPHY.md)** - Design principles

---

## 🚀 Advanced Usage

### Automated Daily Check

```bash
# Add to your shell startup (~/.zshrc)
if [ -f ~/dotfiles/scripts/maintenance/system-health.sh ]; then
    ~/dotfiles/scripts/maintenance/system-health.sh 2>/dev/null || true
fi
```

### Cron Job for Weekly Reports

```bash
# Add to crontab (crontab -e)
0 9 * * 1 ~/dotfiles/scripts/maintenance/fulldump.sh --output ~/weekly-reports/report-$(date +\%Y\%m\%d).txt
```

### CI/CD Integration

```yaml
# .github/workflows/health-check.yml
name: System Health Check
on: [push]
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run Health Check
        run: ./scripts/maintenance/system-health.sh
```

---

**Remember**: These scripts are tools to help you. Use them when needed, not obsessively. A daily health check is usually enough.

**Status**: Ready to Use ✅  
**Last Updated**: 2024-11-27  
**Maintained By**: @LaurenziusW
