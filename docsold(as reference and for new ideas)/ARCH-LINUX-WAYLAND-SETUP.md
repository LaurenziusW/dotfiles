# Arch Linux Wayland Setup - Complete Unified Keyboard Environment

**Complete setup guide for Arch Linux with Hyprland, WezTerm, Tmux, Neovim, and GNU Stow dotfiles management**

---

## 📋 What This Guide Covers

This is the **complete** installation guide for setting up the Unified Keyboard Environment on Arch Linux with:

- ✅ Hyprland (Wayland compositor + window manager)
- ✅ WezTerm (GPU-accelerated terminal)
- ✅ Tmux (terminal multiplexer)
- ✅ Neovim (with lazy.nvim plugin manager)
- ✅ GNU Stow (dotfiles management)
- ✅ Bunches system (context switching)
- ✅ 10-workspace keyboard workflow
- ✅ Strict modifier layer separation

**Time required:** ~45 minutes for complete setup

**Prerequisites:**
- Fresh or existing Arch Linux installation
- Internet connection
- Basic terminal knowledge
- ~5GB free disk space

---

## 🎯 Philosophy & Design

### Modifier Key Separation

The entire system is built on **strict separation of modifier keys**:

**Primary Layer (Alt)** - Window Management & GUI
- `Alt + 1-10` → Switch workspaces
- `Alt + H/J/K/L` → Navigate windows (Vim-style)
- `Alt + Shift + ...` → Move windows
- `Alt + ...` → All Hyprland/WezTerm/GUI shortcuts

**Secondary Layer (Ctrl)** - Terminal & Applications
- `Ctrl + C/V/Z/...` → Standard terminal shortcuts
- `Ctrl + A` → Tmux prefix
- **Never** used by window manager
- **Always** available for applications

**Tertiary Layer (Super/Win)** - System & Launchers
- `Super` → Application launcher
- `Super + ...` → Optional system shortcuts

This separation ensures **zero conflicts** and maintains **muscle memory** across all contexts.

---

## Phase 1: Base System Setup

### Step 1.1: Update System

```bash
# Update package database and system
sudo pacman -Syu

# Install base development tools
sudo pacman -S --needed base-devel git wget curl
```

### Step 1.2: Install AUR Helper (yay)

```bash
# Install yay for AUR packages
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Verify installation
yay --version
```

### Step 1.3: Install Core Utilities

```bash
# Install essential tools
sudo pacman -S --needed \
    stow \
    tree \
    ripgrep \
    fd \
    fzf \
    bat \
    neovim \
    tmux \
    zsh \
    zsh-completions \
    zsh-syntax-highlighting \
    zsh-autosuggestions
```

---

## Phase 2: Hyprland & Wayland Setup

### Step 2.1: Install Hyprland and Dependencies

```bash
# Install Hyprland and core Wayland components
sudo pacman -S --needed \
    hyprland \
    xdg-desktop-portal-hyprland \
    qt5-wayland \
    qt6-wayland \
    polkit-kde-agent \
    waybar \
    wofi \
    dunst \
    swaylock \
    swayidle \
    wl-clipboard \
    grim \
    slurp \
    swappy
```

### Step 2.2: Install Additional Wayland Tools

```bash
# Install helpful Wayland utilities
sudo pacman -S --needed \
    brightnessctl \
    playerctl \
    pavucontrol \
    network-manager-applet
```

### Step 2.3: Create Hyprland Config Directory

```bash
mkdir -p ~/.config/hypr
```

---

## Phase 3: Terminal Setup

### Step 3.1: Install WezTerm

```bash
# Install WezTerm
sudo pacman -S wezterm

# Verify installation
wezterm --version
```

### Step 3.2: Install Fonts

```bash
# Install recommended fonts
sudo pacman -S --needed \
    ttf-fira-code \
    ttf-fira-sans \
    ttf-jetbrains-mono \
    noto-fonts \
    noto-fonts-emoji \
    ttf-font-awesome

# Or use Nerd Fonts for better icon support
yay -S ttf-firacode-nerd
```

---

## Phase 4: Dotfiles Repository Setup

### Step 4.1: Create Dotfiles Repository

```bash
# Create dotfiles directory
mkdir ~/dotfiles
cd ~/dotfiles

# Initialize git repository
git init

# Create README
cat > README.md << 'EOF'
# My Dotfiles

Unified Keyboard Environment configuration managed with GNU Stow.

## Packages

- hyprland - Wayland compositor configuration
- wezterm - Terminal emulator
- tmux - Terminal multiplexer
- nvim - Neovim editor
- bunches - Context switching scripts

## Quick Start

```bash
# Clone this repo
git clone <your-repo-url> ~/dotfiles

# Install all configs
cd ~/dotfiles
stow */

# Or install selectively
stow hyprland wezterm tmux nvim
```

## Structure

Each directory is a "package" that stow will symlink to your home directory.
The structure inside each package mirrors the path from ~/ to the config file.
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
# Ignore nvim plugin data
nvim/.local/
nvim/.cache/

# Ignore lazy.nvim plugins (they'll be re-downloaded)
nvim/.local/share/nvim/lazy/

# Ignore sensitive data
**/private/
**/.env

# OS files
.DS_Store
*.swp
EOF

git add README.md .gitignore
git commit -m "Initial commit"
```

### Step 4.2: Connect to GitHub (Optional)

```bash
# Create GitHub repo first, then:
cd ~/dotfiles
git remote add origin git@github.com:YOUR-USERNAME/dotfiles.git
git branch -M main
git push -u origin main
```

---

## Phase 5: Configure Hyprland

### Step 5.1: Create Hyprland Package in Dotfiles

```bash
cd ~/dotfiles
mkdir -p hyprland/.config/hypr
```

### Step 5.2: Create Hyprland Configuration

Create `~/dotfiles/hyprland/.config/hypr/hyprland.conf`:

```bash
cat > ~/dotfiles/hyprland/.config/hypr/hyprland.conf << 'EOF'
# ═══════════════════════════════════════════════════════════
# UNIFIED KEYBOARD ENVIRONMENT - HYPRLAND CONFIG
# Modifier Philosophy:
#   Alt (PRIMARY)   - All window management
#   Ctrl (SECONDARY) - Terminal & apps only (never WM)
#   Super (TERTIARY) - Launchers & system
# ═══════════════════════════════════════════════════════════

# ───────────────────────────────────────────────────────────
# MONITOR CONFIGURATION
# ───────────────────────────────────────────────────────────
monitor=,preferred,auto,1

# ───────────────────────────────────────────────────────────
# AUTOSTART
# ───────────────────────────────────────────────────────────
exec-once = waybar
exec-once = dunst
exec-once = /usr/lib/polkit-kde-authentication-agent-1
exec-once = wl-paste --watch cliphist store

# ───────────────────────────────────────────────────────────
# ENVIRONMENT VARIABLES
# ───────────────────────────────────────────────────────────
env = XCURSOR_SIZE,24
env = QT_QPA_PLATFORMTHEME,qt6ct

# ───────────────────────────────────────────────────────────
# INPUT CONFIGURATION
# ───────────────────────────────────────────────────────────
input {
    kb_layout = us
    follow_mouse = 1
    
    touchpad {
        natural_scroll = true
        tap-to-click = true
    }
    
    sensitivity = 0
}

# ───────────────────────────────────────────────────────────
# GENERAL SETTINGS
# ───────────────────────────────────────────────────────────
general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)
    
    layout = dwindle
    resize_on_border = true
}

# ───────────────────────────────────────────────────────────
# DECORATION
# ───────────────────────────────────────────────────────────
decoration {
    rounding = 8
    
    blur {
        enabled = true
        size = 3
        passes = 1
        new_optimizations = true
    }
    
    drop_shadow = true
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

# ───────────────────────────────────────────────────────────
# ANIMATIONS
# ───────────────────────────────────────────────────────────
animations {
    enabled = true
    
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    
    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

# ───────────────────────────────────────────────────────────
# LAYOUTS
# ───────────────────────────────────────────────────────────
dwindle {
    pseudotile = true
    preserve_split = true
}

master {
    new_is_master = true
}

# ───────────────────────────────────────────────────────────
# WINDOW RULES
# ───────────────────────────────────────────────────────────
windowrulev2 = float, class:^(pavucontrol)$
windowrulev2 = float, class:^(nm-connection-editor)$

# ───────────────────────────────────────────────────────────
# WORKSPACE ASSIGNMENTS
# ───────────────────────────────────────────────────────────
# Workspace 1: Terminal/General
# Workspace 2: Web Browser
windowrulev2 = workspace 2, class:^(firefox)$
windowrulev2 = workspace 2, class:^(chromium)$

# Workspace 3: Code
windowrulev2 = workspace 3, class:^(code)$
windowrulev2 = workspace 3, class:^(Code)$

# Workspace 4: Communication
windowrulev2 = workspace 4, class:^(slack)$
windowrulev2 = workspace 4, class:^(discord)$

# Workspace 5: Music
windowrulev2 = workspace 5, class:^(spotify)$

# Workspace 6: Notes
windowrulev2 = workspace 6, class:^(obsidian)$

# ═══════════════════════════════════════════════════════════
# KEYBINDINGS
# ═══════════════════════════════════════════════════════════

# ───────────────────────────────────────────────────────────
# TERTIARY Layer (Super) - Launchers & System
# ───────────────────────────────────────────────────────────
bind = SUPER, RETURN, exec, wezterm
bind = SUPER, SPACE, exec, wofi --show drun
bind = SUPER, Q, killactive
bind = SUPER SHIFT, E, exit

# Screenshots
bind = SUPER, S, exec, grim -g "$(slurp)" - | swappy -f -
bind = SUPER SHIFT, S, exec, grim - | swappy -f -

# ───────────────────────────────────────────────────────────
# PRIMARY Layer (Alt) - Window Management
# ───────────────────────────────────────────────────────────

# Window Navigation (Vim-style)
bind = ALT, H, movefocus, l
bind = ALT, J, movefocus, d
bind = ALT, K, movefocus, u
bind = ALT, L, movefocus, r

# Window Movement
bind = ALT SHIFT, H, movewindow, l
bind = ALT SHIFT, J, movewindow, d
bind = ALT SHIFT, K, movewindow, u
bind = ALT SHIFT, L, movewindow, r

# Window Resizing (Arrow keys)
bind = ALT, LEFT, resizeactive, -50 0
bind = ALT, RIGHT, resizeactive, 50 0
bind = ALT, UP, resizeactive, 0 -50
bind = ALT, DOWN, resizeactive, 0 50

# Workspace Switching (1-10)
bind = ALT, 1, workspace, 1
bind = ALT, 2, workspace, 2
bind = ALT, 3, workspace, 3
bind = ALT, 4, workspace, 4
bind = ALT, 5, workspace, 5
bind = ALT, 6, workspace, 6
bind = ALT, 7, workspace, 7
bind = ALT, 8, workspace, 8
bind = ALT, 9, workspace, 9
bind = ALT, 0, workspace, 10

# Move Window to Workspace
bind = ALT SHIFT, 1, movetoworkspace, 1
bind = ALT SHIFT, 2, movetoworkspace, 2
bind = ALT SHIFT, 3, movetoworkspace, 3
bind = ALT SHIFT, 4, movetoworkspace, 4
bind = ALT SHIFT, 5, movetoworkspace, 5
bind = ALT SHIFT, 6, movetoworkspace, 6
bind = ALT SHIFT, 7, movetoworkspace, 7
bind = ALT SHIFT, 8, movetoworkspace, 8
bind = ALT SHIFT, 9, movetoworkspace, 9
bind = ALT SHIFT, 0, movetoworkspace, 10

# Layout Controls
bind = ALT, F, fullscreen, 0
bind = ALT, T, togglefloating
bind = ALT, P, pseudo
bind = ALT, S, togglesplit

# ───────────────────────────────────────────────────────────
# Mouse Bindings
# ───────────────────────────────────────────────────────────
bindm = SUPER, mouse:272, movewindow
bindm = SUPER, mouse:273, resizewindow

# ───────────────────────────────────────────────────────────
# Media Keys
# ───────────────────────────────────────────────────────────
bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bind = , XF86AudioPlay, exec, playerctl play-pause
bind = , XF86AudioNext, exec, playerctl next
bind = , XF86AudioPrev, exec, playerctl previous

bind = , XF86MonBrightnessUp, exec, brightnessctl set 5%+
bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
EOF
```

### Step 5.3: Stow Hyprland Config

```bash
cd ~/dotfiles
stow hyprland

# Verify symlink
ls -la ~/.config/hypr/hyprland.conf
# Should show: ~/.config/hypr/hyprland.conf -> ../../dotfiles/hyprland/.config/hypr/hyprland.conf
```

### Step 5.4: Commit to Git

```bash
cd ~/dotfiles
git add hyprland
git commit -m "Add Hyprland configuration"
git push  # if you set up remote
```

---

## Phase 6: Configure WezTerm

### Step 6.1: Create WezTerm Package

```bash
cd ~/dotfiles
mkdir -p wezterm
```

### Step 6.2: Create WezTerm Configuration

Create `~/dotfiles/wezterm/.wezterm.lua`:

```bash
cat > ~/dotfiles/wezterm/.wezterm.lua << 'EOF'
-- ═══════════════════════════════════════════════════════════
-- UNIFIED CROSS-PLATFORM TERMINAL CONFIG
-- Works identically on macOS and Linux
-- PRIMARY modifier: Cmd (macOS) / Alt (Linux)
-- ═══════════════════════════════════════════════════════════

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ───────────────────────────────────────────────────────────
-- OS Detection
-- ───────────────────────────────────────────────────────────
local function is_darwin()
    return wezterm.target_triple:find("darwin") ~= nil
end

local function is_linux()
    return wezterm.target_triple:find("linux") ~= nil
end

-- PRIMARY modifier: Cmd on macOS, Alt on Linux
local primary_mod = is_darwin() and "CMD" or "ALT"

-- ───────────────────────────────────────────────────────────
-- Appearance
-- ───────────────────────────────────────────────────────────
config.color_scheme = "Tokyo Night"
config.font = wezterm.font("FiraCode Nerd Font", { weight = "Regular" })
config.font_size = 12.0

config.window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
}

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true

-- ───────────────────────────────────────────────────────────
-- Keybindings - PRIMARY Layer Only
-- ───────────────────────────────────────────────────────────
config.keys = {
    -- Tab Management
    { key = "t", mods = primary_mod, action = wezterm.action.SpawnTab("CurrentPaneDomain") },
    { key = "w", mods = primary_mod, action = wezterm.action.CloseCurrentPane({ confirm = true }) },
    { key = "1", mods = primary_mod, action = wezterm.action.ActivateTab(0) },
    { key = "2", mods = primary_mod, action = wezterm.action.ActivateTab(1) },
    { key = "3", mods = primary_mod, action = wezterm.action.ActivateTab(2) },
    { key = "4", mods = primary_mod, action = wezterm.action.ActivateTab(3) },
    { key = "5", mods = primary_mod, action = wezterm.action.ActivateTab(4) },
    { key = "6", mods = primary_mod, action = wezterm.action.ActivateTab(5) },
    { key = "7", mods = primary_mod, action = wezterm.action.ActivateTab(6) },
    { key = "8", mods = primary_mod, action = wezterm.action.ActivateTab(7) },
    { key = "9", mods = primary_mod, action = wezterm.action.ActivateTab(8) },
    
    -- Pane Splitting
    { key = "\\", mods = primary_mod, action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "-", mods = primary_mod, action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
    
    -- Pane Navigation (Vim-style)
    { key = "h", mods = primary_mod, action = wezterm.action.ActivatePaneDirection("Left") },
    { key = "j", mods = primary_mod, action = wezterm.action.ActivatePaneDirection("Down") },
    { key = "k", mods = primary_mod, action = wezterm.action.ActivatePaneDirection("Up") },
    { key = "l", mods = primary_mod, action = wezterm.action.ActivatePaneDirection("Right") },
    
    -- Pane Resizing
    { key = "LeftArrow", mods = primary_mod, action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
    { key = "RightArrow", mods = primary_mod, action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
    { key = "UpArrow", mods = primary_mod, action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
    { key = "DownArrow", mods = primary_mod, action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
    
    -- Copy/Paste (PRIMARY modifier)
    { key = "c", mods = primary_mod, action = wezterm.action.CopyTo("Clipboard") },
    { key = "v", mods = primary_mod, action = wezterm.action.PasteFrom("Clipboard") },
    
    -- Font Size
    { key = "=", mods = primary_mod, action = wezterm.action.IncreaseFontSize },
    { key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
    { key = "0", mods = primary_mod, action = wezterm.action.ResetFontSize },
}

-- Disable all Ctrl-based WezTerm shortcuts
-- This keeps Ctrl layer free for terminal applications
config.disable_default_key_bindings = false

return config
EOF
```

### Step 6.3: Stow WezTerm Config

```bash
cd ~/dotfiles
stow wezterm

# Verify
ls -la ~/.wezterm.lua
```

### Step 6.4: Commit to Git

```bash
cd ~/dotfiles
git add wezterm
git commit -m "Add WezTerm configuration"
git push
```

---

## Phase 7: Configure Tmux

### Step 7.1: Create Tmux Package

```bash
cd ~/dotfiles
mkdir -p tmux
```

### Step 7.2: Create Tmux Configuration

Create `~/dotfiles/tmux/.tmux.conf`:

```bash
cat > ~/dotfiles/tmux/.tmux.conf << 'EOF'
# ═══════════════════════════════════════════════════════════
# UNIFIED TMUX CONFIGURATION
# SECONDARY Layer (Ctrl-A prefix)
# ═══════════════════════════════════════════════════════════

# ───────────────────────────────────────────────────────────
# Prefix Key: Ctrl+A (SECONDARY layer)
# ───────────────────────────────────────────────────────────
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# ───────────────────────────────────────────────────────────
# Pane Splitting (matches WezTerm!)
# ───────────────────────────────────────────────────────────
bind '\' split-window -h  # vertical split
bind '-' split-window -v  # horizontal split
unbind '"'
unbind %

# ───────────────────────────────────────────────────────────
# Pane Navigation (Vim-style, without prefix)
# ───────────────────────────────────────────────────────────
bind -n M-h select-pane -L  # Alt+h
bind -n M-j select-pane -D  # Alt+j
bind -n M-k select-pane -U  # Alt+k
bind -n M-l select-pane -R  # Alt+l

# ───────────────────────────────────────────────────────────
# Pane Resizing (Prefix + Arrow keys)
# ───────────────────────────────────────────────────────────
bind Left resize-pane -L 5
bind Right resize-pane -R 5
bind Up resize-pane -U 5
bind Down resize-pane -D 5

# ───────────────────────────────────────────────────────────
# Window Management
# ───────────────────────────────────────────────────────────
bind c new-window
bind x kill-pane
bind & kill-window

# Window Navigation (Prefix + number)
bind 1 select-window -t 1
bind 2 select-window -t 2
bind 3 select-window -t 3
bind 4 select-window -t 4
bind 5 select-window -t 5
bind 6 select-window -t 6
bind 7 select-window -t 7
bind 8 select-window -t 8
bind 9 select-window -t 9

# ───────────────────────────────────────────────────────────
# General Settings
# ───────────────────────────────────────────────────────────
set -g mouse on
set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on

# Enable 256 colors
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",*256col*:Tc"

# Increase scrollback buffer
set -g history-limit 10000

# Reduce escape time for vim
set -sg escape-time 0

# ───────────────────────────────────────────────────────────
# Appearance
# ───────────────────────────────────────────────────────────
set -g status-style bg=black,fg=white
set -g status-left '[#S] '
set -g status-right '%H:%M %d-%b-%y'
set -g window-status-current-style bg=blue,fg=black,bold

# Pane borders
set -g pane-border-style fg=colour240
set -g pane-active-border-style fg=colour33

# ───────────────────────────────────────────────────────────
# Copy Mode (Vim-style)
# ───────────────────────────────────────────────────────────
setw -g mode-keys vi
bind [ copy-mode
bind ] paste-buffer

# Vim-style copy/paste
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi y send -X copy-selection-and-cancel

# ───────────────────────────────────────────────────────────
# Reload Config
# ───────────────────────────────────────────────────────────
bind r source-file ~/.tmux.conf \; display "Config reloaded!"
EOF
```

### Step 7.3: Stow Tmux Config

```bash
cd ~/dotfiles
stow tmux

# Verify
ls -la ~/.tmux.conf
```

### Step 7.4: Commit to Git

```bash
cd ~/dotfiles
git add tmux
git commit -m "Add Tmux configuration"
git push
```

---

## Phase 8: Configure Neovim

### Step 8.1: Create Neovim Package

```bash
cd ~/dotfiles
mkdir -p nvim/.config/nvim
```

### Step 8.2: Copy Your Existing Neovim Config

If you have an existing nvim config:

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup

# Copy to dotfiles
cp -r ~/.config/nvim.backup/* ~/dotfiles/nvim/.config/nvim/

# Or if you have the uploaded nvim config:
# Extract it to ~/dotfiles/nvim/.config/nvim/
```

### Step 8.3: Create Basic init.lua (if starting fresh)

Create `~/dotfiles/nvim/.config/nvim/init.lua`:

```bash
cat > ~/dotfiles/nvim/.config/nvim/init.lua << 'EOF'
-- ═══════════════════════════════════════════════════════════
-- NEOVIM CONFIGURATION
-- Uses lazy.nvim for plugin management
-- ═══════════════════════════════════════════════════════════

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ───────────────────────────────────────────────────────────
-- Basic Settings
-- ───────────────────────────────────────────────────────────
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

-- ───────────────────────────────────────────────────────────
-- Bootstrap lazy.nvim
-- ───────────────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ───────────────────────────────────────────────────────────
-- Plugin Specifications
-- ───────────────────────────────────────────────────────────
require("lazy").setup({
  -- Color scheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "python", "javascript", "bash" },
        highlight = { enable = true },
      })
    end,
  },

  -- LSP Support
  {
    "neovim/nvim-lspconfig",
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
    },
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup()
    end,
  },
})

-- ───────────────────────────────────────────────────────────
-- Key Mappings
-- ───────────────────────────────────────────────────────────

-- File explorer
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })

-- Telescope
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Find buffers' })

-- Window navigation (Ctrl layer - matches Tmux!)
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Better indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Move lines up/down
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==')
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==')
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv")

-- ───────────────────────────────────────────────────────────
-- Autocommands
-- ───────────────────────────────────────────────────────────

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  command = [[%s/\s\+$//e]],
})
EOF
```

### Step 8.4: Stow Neovim Config

```bash
cd ~/dotfiles
stow nvim

# Verify
ls -la ~/.config/nvim
```

### Step 8.5: Install Plugins

```bash
# Start nvim - lazy.nvim will automatically install plugins
nvim

# Wait for all plugins to install, then quit
:q
```

### Step 8.6: Commit to Git

```bash
cd ~/dotfiles
git add nvim
git commit -m "Add Neovim configuration"

# Add lazy-lock.json if it exists
if [ -f ~/.config/nvim/lazy-lock.json ]; then
    cp ~/.config/nvim/lazy-lock.json ~/dotfiles/nvim/.config/nvim/
    git add nvim/.config/nvim/lazy-lock.json
    git commit -m "Add Neovim plugin lockfile"
fi

git push
```

---

## Phase 9: Bunches System (Context Switching)

### Step 9.1: Create Bunches Directory

```bash
mkdir -p ~/workflow/bunches
cd ~/workflow/bunches
```

### Step 9.2: Create OS Detection Library

Create `~/workflow/bunches/lib-os-detect.sh`:

```bash
cat > ~/workflow/bunches/lib-os-detect.sh << 'EOF'
#!/usr/bin/env bash
# OS Detection Library for Bunches

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "unknown"
    fi
}

OS=$(detect_os)
export OS

# Set window manager commands
if [ "$OS" = "macos" ]; then
    WM_FOCUS="yabai -m window --focus"
    WM_SPACE="yabai -m space --focus"
    WM_DISPLAY="yabai -m display --focus"
elif [ "$OS" = "linux" ]; then
    WM_FOCUS="hyprctl dispatch focuswindow"
    WM_SPACE="hyprctl dispatch workspace"
    WM_DISPLAY="hyprctl dispatch focusmonitor"
fi

export WM_FOCUS WM_SPACE WM_DISPLAY
EOF

chmod +x ~/workflow/bunches/lib-os-detect.sh
```

### Step 9.3: Create Example Bunches

**Coding Project Bunch:**

```bash
cat > ~/workflow/bunches/coding-project.sh << 'EOF'
#!/usr/bin/env bash
source "$(dirname "$0")/lib-os-detect.sh"

echo "🚀 Activating Coding Project environment..."

# Switch to workspace 3 (Code)
$WM_SPACE 3

# Open terminal in workspace 1
$WM_SPACE 1
wezterm &

# Open VS Code in workspace 3
$WM_SPACE 3
if [ "$OS" = "linux" ]; then
    code &
fi

# Open browser in workspace 2
$WM_SPACE 2
firefox &

echo "✅ Coding environment ready!"
EOF

chmod +x ~/workflow/bunches/coding-project.sh
```

**Study/Math Bunch:**

```bash
cat > ~/workflow/bunches/study-math.sh << 'EOF'
#!/usr/bin/env bash
source "$(dirname "$0")/lib-os-detect.sh"

echo "📚 Activating Study/Math environment..."

# Obsidian in workspace 6
$WM_SPACE 6
obsidian &

# Terminal in workspace 1
$WM_SPACE 1
wezterm start -- nvim &

# Browser with documentation in workspace 2
$WM_SPACE 2
firefox &

echo "✅ Study environment ready!"
EOF

chmod +x ~/workflow/bunches/study-math.sh
```

### Step 9.4: Create Bunch Manager

```bash
cat > ~/workflow/bunches/bunch-manager.sh << 'EOF'
#!/usr/bin/env bash

BUNCHES_DIR="$(dirname "$0")"

list_bunches() {
    echo "Available bunches:"
    for bunch in "$BUNCHES_DIR"/*.sh; do
        [ "$bunch" = "$BUNCHES_DIR/lib-os-detect.sh" ] && continue
        [ "$bunch" = "$BUNCHES_DIR/bunch-manager.sh" ] && continue
        echo "  - $(basename "$bunch" .sh)"
    done
}

run_bunch() {
    local bunch_name="$1"
    local bunch_file="$BUNCHES_DIR/${bunch_name}.sh"
    
    if [ -f "$bunch_file" ]; then
        echo "Running bunch: $bunch_name"
        bash "$bunch_file"
    else
        echo "Error: Bunch '$bunch_name' not found"
        list_bunches
        exit 1
    fi
}

if [ $# -eq 0 ]; then
    list_bunches
else
    run_bunch "$1"
fi
EOF

chmod +x ~/workflow/bunches/bunch-manager.sh
```

### Step 9.5: Add Bunches to PATH

Add to `~/.zshrc` or `~/.bashrc`:

```bash
echo 'export PATH="$HOME/workflow/bunches:$PATH"' >> ~/.zshrc

# Reload shell
source ~/.zshrc
```

---

## Phase 10: Final Setup & Verification

### Step 10.1: Set Hyprland as Default Session

Edit `/etc/sddm.conf` or your display manager config to use Hyprland.

Or create `~/.xinitrc`:

```bash
echo "exec Hyprland" > ~/.xinitrc
```

### Step 10.2: Reboot into Hyprland

```bash
sudo reboot
```

### Step 10.3: Verification Checklist

After logging into Hyprland:

```bash
# Test workspace switching
# Press Alt+1 through Alt+0

# Test window navigation
# Press Alt+H/J/K/L

# Test terminal
# Press Super+Return (should open WezTerm)

# Test application launcher
# Press Super+Space (should open wofi)

# Test terminal shortcuts
# In WezTerm, press Ctrl+C, Ctrl+V, etc.

# Test Tmux
tmux
# Press Ctrl+A then ? to see bindings

# Test Neovim
nvim
# Should load with plugins

# Test bunches
bunch-manager.sh
# Should list available bunches

bunch-manager.sh coding-project
# Should set up coding environment
```

### Step 10.4: Verify Dotfiles

```bash
# Check all symlinks
cd ~
ls -la .wezterm.lua .tmux.conf
ls -la .config/nvim .config/hypr

# All should show symlinks to ~/dotfiles/
```

---

## 🎯 Quick Reference Card

### Modifier Layers

- **Alt (PRIMARY):** Window management, workspaces, GUI shortcuts
- **Ctrl (SECONDARY):** Terminal shortcuts, Tmux prefix (Ctrl+A)
- **Super (TERTIARY):** Launchers, system shortcuts

### Essential Shortcuts

**Hyprland:**
- `Alt + 1-0` → Workspaces
- `Alt + H/J/K/L` → Navigate windows
- `Alt + Shift + H/J/K/L` → Move windows
- `Super + Return` → Terminal
- `Super + Space` → Launcher
- `Super + Q` → Close window

**WezTerm:**
- `Alt + T` → New tab
- `Alt + H/J/K/L` → Navigate panes
- `Alt + \` → Split horizontal
- `Alt + -` → Split vertical

**Tmux:**
- `Ctrl + A` → Prefix
- `Prefix + \` → Split horizontal
- `Prefix + -` → Split vertical
- `Alt + H/J/K/L` → Navigate panes (no prefix!)

**Neovim:**
- `Space` → Leader key
- `Leader + e` → File explorer
- `Leader + ff` → Find files
- `Ctrl + H/J/K/L` → Navigate windows

---

## 🔧 Troubleshooting

### Hyprland not starting

```bash
# Check logs
cat ~/.hyprland.log

# Verify installation
hyprctl version
```

### WezTerm not opening

```bash
# Test from terminal
wezterm

# Check config syntax
wezterm show-config
```

### Nvim plugins not installing

```bash
# Open nvim and run
:Lazy sync

# Check health
:checkhealth
```

### Symlinks broken

```bash
cd ~/dotfiles
stow -R hyprland wezterm tmux nvim
```

---

## 📚 Additional Resources

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [WezTerm Documentation](https://wezfurlong.org/wezterm/)
- [Neovim Documentation](https://neovim.io/doc/)
- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/)

---

## 🎉 Conclusion

You now have a complete, unified keyboard environment with:

✅ Hyprland window manager
✅ WezTerm terminal
✅ Tmux multiplexer
✅ Neovim editor
✅ GNU Stow dotfiles management
✅ Bunches for context switching
✅ Strict modifier layer separation
✅ Git-managed configurations

**Your entire setup is now:**
- Version controlled in Git
- Deployable in ~3 minutes with `stow */`
- Cross-platform compatible
- Keyboard-driven and efficient

Happy hacking! 🚀
