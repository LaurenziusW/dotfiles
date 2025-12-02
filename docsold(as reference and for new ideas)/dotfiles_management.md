# Dotfiles Management Guide - Stow Setup

## 📋 Was wir gemacht haben

Du hast deine Configs (nvim, wezterm, tmux, skhd, yabai) in ein Git-Repository verschoben und mit **GNU Stow** verwaltet, sodass du sie:

- ✅ Version-controlen kannst
- ✅ Einfach auf neue Maschinen deployen kannst
- ✅ Zentral an einem Ort managen kannst

---

## 🏗️ Die Stow-Struktur

### Grundprinzip

Stow erstellt **Symlinks** von deinem Dotfiles-Repo zu deinem Home-Directory.

### Kritische Regel

**Die Verzeichnisstruktur im Repo MUSS den VOLLEN Pfad ab Home replizieren!**

```
Beispiel für ~/.config/nvim/init.lua:

✅ RICHTIG:
~/dotfiles/nvim/.config/nvim/init.lua
           └─┬─┘ └────┬────┘
             │        └─ Voller Pfad ab Home
             └─ Package-Name

❌ FALSCH:
~/dotfiles/nvim/.config/     # Fehlt nvim/ am Ende!
~/dotfiles/nvim/init.lua     # Fehlt .config/nvim/
```

---

## 📂 Deine aktuelle Struktur

```
~/dotfiles/
├── nvim/.config/nvim/         # ~/.config/nvim → symlink
│   ├── init.lua
│   ├── lua/
│   └── ...
├── wezterm/                   # ~/.wezterm.lua → symlink
│   └── .wezterm.lua
├── tmux/                      # ~/.tmux.conf → symlink
│   └── .tmux.conf
├── skhd/.config/skhd/         # ~/.config/skhd → symlink
│   └── skhdrc
└── yabai/.config/yabai/       # ~/.config/yabai → symlink
    └── yabairc
```

### Symlinks die erstellt wurden:

```
~/.config/nvim    → ../dotfiles/nvim/.config/nvim
~/.config/skhd    → ../dotfiles/skhd/.config/skhd
~/.config/yabai   → ../dotfiles/yabai/.config/yabai
~/.tmux.conf      → dotfiles/tmux/.tmux.conf
~/.wezterm.lua    → dotfiles/wezterm/.wezterm.lua
```

---

## 🚀 Neue Config hinzufügen

### Für Configs in `~/.config/APP/`:

```bash
cd ~/dotfiles

# 1. Erstelle Struktur (VOLLER Pfad!)
mkdir -p APP/.config/APP

# 2. Kopiere Config
cp -r ~/.config/APP/* APP/.config/APP/

# 3. Lösche Original
rm -rf ~/.config/APP

# 4. Stow
stow APP

# 5. Verify
ls -la ~/.config/APP

# 6. Git
git add APP
git commit -m "Add APP config"
git push
```

**Beispiel für Helix:**

```bash
cd ~/dotfiles
mkdir -p helix/.config/helix
cp -r ~/.config/helix/* helix/.config/helix/
rm -rf ~/.config/helix
stow helix
ls -la ~/.config/helix
git add helix && git commit -m "Add helix config" && git push
```

### Für Configs direkt in Home (`~/.apprc`):

```bash
cd ~/dotfiles

# 1. Erstelle Package-Ordner
mkdir -p APP

# 2. Kopiere Config
cp ~/.apprc APP/.apprc

# 3. Lösche Original
rm ~/.apprc

# 4. Stow
stow APP

# 5. Verify
ls -la ~/.apprc

# 6. Git
git add APP
git commit -m "Add APP config"
git push
```

**Beispiel für zsh:**

```bash
cd ~/dotfiles
mkdir -p zsh
cp ~/.zshrc zsh/.zshrc
rm ~/.zshrc
stow zsh
ls -la ~/.zshrc
git add zsh && git commit -m "Add zsh config" && git push
```

---

## 🔄 Bestehende Config aktualisieren

Wenn du eine Config änderst, ist sie **automatisch im Repo** (wegen Symlink)!

```bash
# 1. Ändere Config wie gewohnt
nvim ~/.config/nvim/init.lua

# 2. Die Datei ist eigentlich hier (wegen Symlink):
# ~/dotfiles/nvim/.config/nvim/init.lua

# 3. Git commit
cd ~/dotfiles
git add nvim
git commit -m "Update nvim config"
git push
```

---

## 🆕 Neue Maschine Setup

### 1. Repository clonen

```bash
git clone https://github.com/LaurenziusW/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Stow alle Configs

```bash
# Einzeln
stow nvim
stow wezterm
stow tmux
stow skhd
stow yabai

# Oder alle auf einmal
stow */
```

### 3. Verify

```bash
ls -la ~/.config/nvim
ls -la ~/.wezterm.lua
ls -la ~/.tmux.conf
ls -la ~/.config/skhd
ls -la ~/.config/yabai
```

### 4. Services starten (wenn nötig)

```bash
brew services start skhd
brew services start yabai
```

---

## 🔧 Wichtige Stow Commands

### Basis Commands

```bash
# Stow (erstellt Symlinks)
stow APP

# Unstow (entfernt Symlinks)
stow -D APP

# Restow (remove + add wieder, nützlich nach Änderungen)
stow -R APP

# Dry-run (zeigt was passieren würde, ohne es zu tun)
stow -n -v APP

# Verbose (zeigt Details)
stow -v APP
```

### Alle Packages auf einmal

```bash
# Stow alle
cd ~/dotfiles
stow */

# Unstow alle
stow -D */
```

---

## 🐛 Troubleshooting

### "WARNING! stowing APP would cause conflicts"

**Problem:** Datei/Ordner existiert bereits

**Lösung 1 - Backup:**

```bash
mv ~/.config/APP ~/.config/APP.backup
stow APP
```

**Lösung 2 - Adopt (übernimmt existierende Files):**

```bash
stow --adopt APP
```

### Symlink zeigt auf falschen Ort

```bash
# Unstow
stow -D APP

# Lösche falschen Symlink
rm ~/.config/APP

# Stow nochmal
stow APP
```

### Struktur im Repo ist falsch

```bash
# Check aktuelle Struktur
find APP -type f

# Sollte sein: APP/.config/APP/...
# Falls falsch, neu strukturieren:

cd ~/dotfiles
mkdir -p APP-new/.config/APP
cp -r APP/* APP-new/.config/APP/
rm -rf APP
mv APP-new APP
stow -R APP
```

---

## ✅ Verification Checklist

Nach jedem Stow, verifiziere:

```bash
# 1. Symlink existiert
ls -la ~/.config/APP

# 2. Zeigt auf richtigen Ort
# Sollte zeigen: ~/.config/APP -> ../dotfiles/APP/.config/APP

# 3. Config funktioniert
# Teste die App!

# 4. Im Repo
cd ~/dotfiles
find APP -type f
```

---

## 📝 Best Practices

### 1. Immer die richtige Struktur verwenden

```bash
# Für ~/.config/APP/ immer:
mkdir -p APP/.config/APP

# Für ~/.apprc immer:
mkdir -p APP
```

### 2. Teste vor Git Commit

```bash
# Nach stow:
ls -la ~/.config/APP  # Check Symlink
APP --version         # Teste ob App noch funktioniert
```

### 3. Sinnvolle Commit Messages

```bash
git commit -m "Add helix config"
git commit -m "Update nvim: add telescope plugin"
git commit -m "Fix skhd: correct alt keybindings"
```

### 4. Regelmäßig pushen

```bash
# Nach jeder wichtigen Änderung
cd ~/dotfiles
git add .
git commit -m "Update configs"
git push
```

### 5. Dokumentiere besondere Setups

Wenn eine Config spezielle Installation braucht (z.B. yabai SIP disable), dokumentiere es:

```bash
# In ~/dotfiles/README.md
## yabai
Requires SIP to be partially disabled:
- Reboot in Recovery Mode
- csrutil enable --without debug --without fs
```

---

## 🎯 Quick Reference

### Neue Config hinzufügen

```bash
cd ~/dotfiles
mkdir -p APP/.config/APP        # Für .config Apps
cp -r ~/.config/APP/* APP/.config/APP/
rm -rf ~/.config/APP
stow APP
git add APP && git commit -m "Add APP" && git push
```

### Config ändern

```bash
nvim ~/.config/APP/config        # Editiere wie normal
cd ~/dotfiles
git add APP && git commit -m "Update APP" && git push
```

### Neue Maschine

```bash
git clone https://github.com/LaurenziusW/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow */
```

### Verification

```bash
cd ~/dotfiles
find . -type f -not -path "./.git/*" | sort
ls -la ~/.config/nvim ~/.config/skhd ~/.config/yabai ~/.tmux.conf ~/.wezterm.lua
```

---

## 🔑 Die wichtigste Regel

**Stow braucht die VOLLE Pfad-Struktur ab Home im Repo!**

```
Wenn deine Config hier ist:    Dann muss die Repo-Struktur sein:
~/.config/nvim/init.lua    →   ~/dotfiles/nvim/.config/nvim/init.lua
~/.zshrc                   →   ~/dotfiles/zsh/.zshrc
~/.config/kitty/kitty.conf →   ~/dotfiles/kitty/.config/kitty/kitty.conf
```

---

## 📚 Nützliche Links

- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/stow.html)
- [Dein Dotfiles Repo](https://github.com/LaurenziusW/dotfiles)
- [Awesome Dotfiles (Inspiration)](https://github.com/webpro/awesome-dotfiles)

---

## 🎉 Done!

Du hast jetzt:

- ✅ Alle Configs in Git
- ✅ Symlinks mit Stow
- ✅ Einfaches Deployment auf neue Maschinen
- ✅ Zentrale Config-Verwaltung

**Happy Hacking! 🚀**