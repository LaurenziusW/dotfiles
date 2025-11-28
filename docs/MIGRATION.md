# Migration Guide

## v5 → v6

### Changes

1. **New maintenance scripts**
   - `bin/uke-doctor` - health checks
   - `bin/uke-backup` - backup/restore
   - `bin/uke-debug` - diagnostics

2. **Enhanced AI helpers**
   - `scripts/ai/dump-context.sh` - complete project dump

3. **New documentation**
   - `docs/ARCHITECTURE.md`
   - `docs/TROUBLESHOOTING.md`
   - `docs/MIGRATION.md`

4. **Directory structure finalized**
   - `gen/` - generated configs
   - `bunches/` - bunch definitions
   - `templates/` - templates

### Migration Steps

```bash
# Backup
uke-backup create

# Update (if pulling from git)
git pull

# Or extract new archive over existing
tar -xzf uke-v6.tar.gz -C ~/dotfiles --strip-components=1

# Regenerate
uke gen

# Verify
uke-doctor

# Apply
uke reload
```

## v4 → v5/v6

### Breaking Changes

1. **Directory structure changed**
   - Old: `platform/macos/`, `platform/linux/`
   - New: `gen/skhd/`, `gen/yabai/`, `gen/hyprland/`

2. **Binary names unchanged**
   - `uke` still primary CLI
   - `uke-bunch`, `uke-gather` still available

3. **Registry format stable**
   - No changes to registry.yaml schema
   - Existing registries work as-is

### Migration Steps

1. **Backup existing**
```bash
cd ~/dotfiles
tar -czf uke-v4-backup.tar.gz uke/
```

2. **Extract new version**
```bash
rm -rf uke/
tar -xzf uke-v6.tar.gz
mv uke ~/dotfiles/
```

3. **Migrate registry** (if customized)
```bash
# Copy your custom registry
cp ~/uke-v4-backup/config/registry.yaml ~/dotfiles/uke/config/
```

4. **Regenerate and verify**
```bash
cd ~/dotfiles/uke
uke gen
uke-doctor
uke reload
```

### Rollback

```bash
cd ~/dotfiles
rm -rf uke/
tar -xzf uke-v4-backup.tar.gz
uke reload
```

## Fresh Install

```bash
tar -xzf uke-v6.tar.gz
mv uke ~/dotfiles/
cd ~/dotfiles/uke
./scripts/install.sh
uke gen && uke reload
```
