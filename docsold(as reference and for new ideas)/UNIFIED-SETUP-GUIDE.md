# Unified Keyboard Environment - Complete Setup Guide v2.0

**Modern cross-platform keyboard workflow with GNU Stow dotfiles management**

---

## 📚 Documentation Overview

This package contains comprehensive documentation for the Unified Keyboard Environment:

### 1. 🚀 UNIFIED-SETUP-GUIDE.md (This File)
**Quick Start & Overview**

Use this to:
* Understand the system philosophy
* Get platform-specific setup guides
* Learn the dotfiles management workflow

### 2. 📱 Platform-Specific Guides

**ARCH-LINUX-WAYLAND-SETUP.md** - Complete Arch Linux installation with Hyprland
* Full step-by-step setup (45 minutes)
* Includes Hyprland, WezTerm, Tmux, Neovim
* Integrated dotfiles with GNU Stow

**macOS-YABAI-SETUP.md** - macOS installation with Yabai/skhd
* Step-by-step macOS setup
* SIP configuration guide
* Homebrew integration

### 3. 📖 Reference Documentation

**MASTER-DOCUMENTATION.md** - Complete technical reference
* System architecture
* Design philosophy
* Configuration deep-dives

**COMPLETE-CHEATSHEET.md** - Quick reference for all shortcuts
* Printable cheatsheet
* Side-by-side macOS vs Linux comparison

**dotfiles_management.md** - GNU Stow workflow guide
* How to add new configs
* Stow best practices
* Git workflow

### 4. 🤖 AI-HANDOFF-GUIDE.md
**Getting AI Assistance**
* How to package your setup
* What information to provide
* Troubleshooting with AI

---

## 🎯 Quick Start by Platform

### Fresh Installation

**Arch Linux users:**
→ Follow **ARCH-LINUX-WAYLAND-SETUP.md** (45 min complete setup)

**macOS users:**
→ Follow **macOS-YABAI-SETUP.md** (30 min complete setup)

### Existing Setup Migration

**Already have configs?**
→ Jump to "Migrating to Dotfiles Management" below

---

## 🌟 What Makes This System Unique

### Strict Modifier Layer Separation

The **core innovation** that makes this workflow superior:

```
┌─────────────────────────────────────────────────────┐
│ PRIMARY LAYER (Cmd/Alt)                             │
│ • All window management                             │
│ • Workspace switching                               │
│ • GUI shortcuts                                     │
│ • WezTerm/terminal app shortcuts                    │
└─────────────────────────────────────────────────────┘
                      ↑
                      │ COMPLETE SEPARATION
                      ↓
┌─────────────────────────────────────────────────────┐
│ SECONDARY LAYER (Ctrl)                              │
│ • Terminal shortcuts (Ctrl+C, Ctrl+V, etc.)         │
│ • Tmux prefix (Ctrl+A)                              │
│ • Application shortcuts (Ctrl+F, etc.)              │
│ • NEVER touched by window manager                   │
└─────────────────────────────────────────────────────┘
                      ↑
                      │
                      ↓
┌─────────────────────────────────────────────────────┐
│ TERTIARY LAYER (Super/Win)                          │
│ • Application launchers                             │
│ • System shortcuts                                  │
│ • Optional utilities                                │
└─────────────────────────────────────────────────────┘
```

**Why this matters:**
- ✅ **Zero conflicts** between window manager and terminal
- ✅ **Consistent muscle memory** across all contexts
- ✅ **Cross-platform compatibility** (Cmd→Alt translation)
- ✅ **Predictable behavior** - modifiers never overlap

### 10-Workspace System

```
Workspace 1: Terminal/General     Alt+1
Workspace 2: Web Browser          Alt+2
Workspace 3: Code Editor          Alt+3
Workspace 4: Communication        Alt+4
Workspace 5: Music                Alt+5
Workspace 6: Notes/Obsidian       Alt+6
Workspace 7: Documents            Alt+7
Workspace 8: Media                Alt+8
Workspace 9: Admin                Alt+9
Workspace 10: Utilities           Alt+0
```

Each workspace auto-routes apps and maintains persistent context.

### Bunches (Context Switching)

Pre-configured "environments" that set up multiple workspaces:

```bash
# Activate coding environment
bunch-manager.sh coding-project
→ Opens: Terminal + VS Code + Browser + Documentation

# Activate study environment
bunch-manager.sh study-math
→ Opens: Obsidian + Terminal with nvim + Reference browser

# Custom bunches for your workflows
bunch-manager.sh guitar-practice
bunch-manager.sh email-admin
```

### Unified Cross-Platform Configs

**Same configs work on macOS and Linux!**

The system uses OS detection to automatically adapt:

```lua
-- Example from .wezterm.lua
local primary_mod = is_darwin() and "CMD" or "ALT"

-- This single line makes ALL shortcuts work cross-platform!
```

---

## 📦 Dotfiles Management with GNU Stow

### What is Stow?

GNU Stow creates symlinks from a central repository to your home directory:

```
~/dotfiles/                     ~/
├── nvim/                       ├── .config/
│   └── .config/                │   └── nvim/ → ../dotfiles/nvim/.config/nvim
│       └── nvim/               │
│           ├── init.lua        ├── .wezterm.lua → dotfiles/wezterm/.wezterm.lua
│           └── lua/            └── .tmux.conf → dotfiles/tmux/.tmux.conf
├── wezterm/
│   └── .wezterm.lua
└── tmux/
    └── .tmux.conf
```

**Benefits:**
- ✅ All configs in Git
- ✅ Deploy to new machine in 3 minutes
- ✅ Easy to track changes
- ✅ Share configs safely

### Stow Quick Reference

```bash
# Install all configs
cd ~/dotfiles
stow */

# Install specific config
stow nvim

# Remove config symlinks
stow -D nvim

# Update config (remove + add)
stow -R nvim

# See what would happen (dry run)
stow -n -v nvim
```

**For complete Stow guide:** See `dotfiles_management.md`

---

## 🚀 Platform Setup Guides

### Arch Linux with Hyprland

**Complete guide:** `ARCH-LINUX-WAYLAND-SETUP.md`

**Quick overview:**
1. Install base system + development tools
2. Install Hyprland + Wayland components
3. Setup dotfiles repository with Git
4. Install & configure: WezTerm, Tmux, Neovim
5. Use Stow to symlink all configs
6. Setup bunches system
7. Reboot into Hyprland

**Time:** 45 minutes
**Result:** Fully functional keyboard-driven environment

### macOS with Yabai

**Complete guide:** `macOS-YABAI-SETUP.md`

**Quick overview:**
1. Install Homebrew
2. Disable SIP partially
3. Install Yabai + skhd
4. Setup dotfiles repository
5. Install WezTerm, Tmux, Neovim
6. Use Stow to symlink configs
7. Setup bunches system
8. Start Yabai + skhd services

**Time:** 30 minutes
**Result:** Full keyboard workflow on macOS

---

## 🔄 Migrating Existing Setup to Dotfiles

If you already have configs and want to use Stow:

### Step 1: Create Dotfiles Repo

```bash
mkdir ~/dotfiles
cd ~/dotfiles
git init
```

### Step 2: Move Existing Configs

**For configs in `~/.config/APP/`:**

```bash
# Example: Neovim
cd ~/dotfiles
mkdir -p nvim/.config/nvim
cp -r ~/.config/nvim/* nvim/.config/nvim/
rm -rf ~/.config/nvim
stow nvim
```

**For configs in home directory:**

```bash
# Example: Tmux
cd ~/dotfiles
mkdir -p tmux
cp ~/.tmux.conf tmux/.tmux.conf
rm ~/.tmux.conf
stow tmux
```

### Step 3: Verify Symlinks

```bash
ls -la ~/.config/nvim    # Should show symlink
ls -la ~/.tmux.conf      # Should show symlink
```

### Step 4: Commit to Git

```bash
cd ~/dotfiles
git add .
git commit -m "Initial dotfiles with nvim, tmux"
git remote add origin <your-repo-url>
git push -u origin main
```

**Detailed guide:** See `dotfiles_management.md`

---

## 🎓 Learning Path

### Week 1: Basics

**Days 1-2: Installation**
- [ ] Follow platform-specific setup guide
- [ ] Install all base components
- [ ] Verify each component works

**Days 3-4: Basic Navigation**
- [ ] Learn workspace switching (Alt+1-0)
- [ ] Practice window navigation (Alt+H/J/K/L)
- [ ] Get comfortable with modifier layers

**Days 5-7: Terminal Workflow**
- [ ] Learn WezTerm shortcuts
- [ ] Practice Tmux basics
- [ ] Basic Neovim navigation

### Week 2: Productivity

**Week 2 Focus:**
- [ ] Create your first bunch
- [ ] Customize app assignments
- [ ] Learn advanced window management
- [ ] Explore Neovim plugins

### Week 3: Mastery

**Week 3 Focus:**
- [ ] Achieve 80%+ keyboard usage
- [ ] Create bunches for all your contexts
- [ ] Customize configs to your needs
- [ ] Deploy to second machine

---

## 📋 Essential Shortcuts Cheat Sheet

### Window Management (PRIMARY - Alt)

```
Alt + 1-0              → Switch to workspace 1-10
Alt + H/J/K/L          → Navigate windows (Vim-style)
Alt + Shift + H/J/K/L  → Move windows
Alt + Arrows           → Resize windows
Alt + F                → Fullscreen
Alt + T                → Toggle floating
```

### Terminal (PRIMARY - Alt)

```
Alt + T                → New tab
Alt + W                → Close tab
Alt + \                → Split vertical
Alt + -                → Split horizontal
Alt + H/J/K/L          → Navigate panes
```

### Tmux (SECONDARY - Ctrl+A prefix)

```
Ctrl + A, then:
  \                    → Split vertical
  -                    → Split horizontal
  1-9                  → Switch window
  c                    → New window
  x                    → Close pane

Alt + H/J/K/L          → Navigate panes (no prefix!)
```

### Neovim (Leader = Space)

```
Space + e              → File explorer
Space + ff             → Find files
Space + fg             → Live grep
Ctrl + H/J/K/L         → Navigate splits
```

**Full reference:** See `COMPLETE-CHEATSHEET.md`

---

## 🔧 Common Tasks

### Adding a New Config to Dotfiles

```bash
cd ~/dotfiles

# 1. Create package structure
mkdir -p APP/.config/APP

# 2. Move config
cp -r ~/.config/APP/* APP/.config/APP/
rm -rf ~/.config/APP

# 3. Stow it
stow APP

# 4. Commit
git add APP
git commit -m "Add APP config"
git push
```

### Deploying to New Machine

```bash
# 1. Clone dotfiles
git clone <your-repo> ~/dotfiles

# 2. Install all configs
cd ~/dotfiles
stow */

# 3. Install applications
# Follow platform setup guide for app installation

# Done! Your environment is ready in ~3 minutes
```

### Updating a Config

```bash
# 1. Edit config as normal (it's a symlink)
nvim ~/.config/nvim/init.lua

# 2. The file is actually here:
# ~/dotfiles/nvim/.config/nvim/init.lua

# 3. Commit changes
cd ~/dotfiles
git add nvim
git commit -m "Update nvim config"
git push
```

### Creating a New Bunch

```bash
cd ~/workflow/bunches

# Copy template
cp templates/basic-bunch.sh my-new-bunch.sh

# Edit to your needs
nvim my-new-bunch.sh

# Make executable
chmod +x my-new-bunch.sh

# Test it
./my-new-bunch.sh
```

---

## 🐛 Troubleshooting

### Symlinks Not Working

```bash
# Check if stow is installed
stow --version

# Re-stow with verbose output
cd ~/dotfiles
stow -v APP

# Check for conflicts
stow -n -v APP
```

### Config Not Loading

```bash
# Verify symlink
ls -la ~/.config/APP

# Should show: APP -> ../../dotfiles/APP/.config/APP

# If broken, remove and re-stow
rm ~/.config/APP
cd ~/dotfiles
stow APP
```

### Window Manager Not Starting

**Hyprland:**
```bash
cat ~/.hyprland.log
hyprctl version
```

**Yabai:**
```bash
cat /tmp/yabai_*.err.log
yabai --version
```

### Neovim Plugins Not Loading

```bash
nvim
:Lazy sync
:checkhealth
```

---

## 📚 Next Steps

1. **Follow your platform guide:**
   - Linux: `ARCH-LINUX-WAYLAND-SETUP.md`
   - macOS: `macOS-YABAI-SETUP.md`

2. **Print the cheatsheet:**
   - `COMPLETE-CHEATSHEET.md`
   - Keep it on your desk during first week

3. **Read the philosophy:**
   - `MASTER-DOCUMENTATION.md`
   - Understand why things work this way

4. **Setup dotfiles:**
   - `dotfiles_management.md`
   - Get your configs in Git

5. **Get help if stuck:**
   - `AI-HANDOFF-GUIDE.md`
   - Package your setup for AI assistance

---

## 🎉 What You'll Have

After completing setup:

✅ **10-workspace keyboard workflow**
- Navigate entire system without mouse
- Vim-style everything
- Workspace-based context switching

✅ **Zero-conflict modifier layers**
- Window manager never breaks terminal
- Consistent muscle memory
- Predictable behavior everywhere

✅ **Git-managed dotfiles**
- All configs version controlled
- Deploy to new machine in 3 minutes
- Safe to experiment (just git revert!)

✅ **Cross-platform compatibility**
- Same configs on macOS and Linux
- Switch systems without relearning
- Bunches work everywhere

✅ **Extensible bunches system**
- Pre-configure workflows
- One command context switches
- Easy to create new bunches

✅ **Modern, fast tools**
- Hyprland/Yabai (fast tiling WM)
- WezTerm (GPU-accelerated terminal)
- Neovim (powerful editor)
- Tmux (session management)

---

## 🚀 Ready to Begin?

1. Choose your platform
2. Follow the setup guide
3. Print the cheatsheet
4. Start building muscle memory

**The first week is the hardest** - but after that, you'll never want to go back to a mouse-driven workflow!

Happy hacking! ⌨️🚀
