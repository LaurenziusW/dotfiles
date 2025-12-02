# Additional Configurations Guide

**Essential shell and utility configs to complete your Unified Keyboard Environment**

---

## 📋 Overview

This guide covers the additional configuration files that complement your keyboard environment:

- **`.zshrc`** - Comprehensive Zsh shell configuration
- **`.gitconfig`** - Git configuration with productivity aliases
- **`.gitignore_global`** - Global gitignore patterns
- **`starship.toml`** - Modern shell prompt configuration

These configs integrate seamlessly with your existing setup and follow the same philosophy of keyboard-driven efficiency.

---

## 🐚 Zsh Configuration (`.zshrc`)

### What It Includes

**Core Features:**
- ✅ OS detection (macOS/Linux) with platform-specific aliases
- ✅ Respects Ctrl layer (doesn't break Tmux!)
- ✅ Comprehensive Git aliases
- ✅ Dotfiles management helpers
- ✅ Bunches system integration
- ✅ Cross-platform tool integration (FZF, Zoxide, Starship)

**Key Highlights:**

**1. Modifier Layer Respect:**
```zsh
# Uses emacs-style keybindings (Ctrl+A, Ctrl+E, etc.)
bindkey -e

# Ctrl+A preserved for Tmux when in tmux session!
# All Ctrl shortcuts available for terminal
```

**2. Bunches Integration:**
```zsh
# Quick bunch runner
bunch() {
    if [ -z "$1" ]; then
        bunch-manager.sh
    else
        bunch-manager.sh "$1"
    fi
}

# Usage:
bunch                 # List available bunches
bunch coding-project  # Run specific bunch
```

**3. Dotfiles Helpers:**
```zsh
# Quick stow commands
stowit nvim          # Stow a package
unstowit nvim        # Remove stow package
restowit nvim        # Refresh stow package
stowlist             # List all stow packages
stowcheck nvim       # Dry run (see what would happen)

# Quick access
dots                 # cd to ~/dotfiles
```

**4. Git Shortcuts:**
```zsh
gs    # git status
ga    # git add
gc    # git commit
gp    # git push
gl    # git log --oneline --graph
gd    # git diff
```

**5. Cross-Platform Aliases:**
```zsh
# macOS specific:
yabai-restart        # Restart Yabai
skhd-restart         # Restart skhd
yabai-log            # Tail Yabai logs

# Linux specific:
hypr-restart         # Reload Hyprland
hypr-log             # View Hyprland logs
update               # System update (pacman -Syu)
```

### Setup in Dotfiles

**Directory structure:**
```bash
cd ~/dotfiles
mkdir -p zsh

# Copy .zshrc
cp /path/to/configs/.zshrc zsh/.zshrc

# IMPORTANT: Customize first!
nvim zsh/.zshrc
# Edit: Name, email, preferences

# Stow it
stow zsh
```

**Verify:**
```bash
ls -la ~/.zshrc
# Should show: .zshrc -> dotfiles/zsh/.zshrc

source ~/.zshrc
```

### Customization

**Local overrides (not tracked in git):**
```bash
# Create ~/.zshrc.local for machine-specific config
nvim ~/.zshrc.local

# Examples:
export CUSTOM_PATH="/opt/myapp/bin"
alias work='cd ~/work/current-project'
```

**Tool Installation (Optional but Recommended):**

**macOS:**
```bash
brew install fzf zoxide starship eza fd ripgrep bat htop
```

**Arch Linux:**
```bash
sudo pacman -S fzf zoxide starship eza fd ripgrep bat htop
```

---

## 🔧 Git Configuration (`.gitconfig`)

### What It Includes

**Productivity Features:**
- ✅ 30+ useful Git aliases
- ✅ Better diff and merge settings
- ✅ Dotfiles-specific helpers
- ✅ Neovim as merge/diff tool
- ✅ Platform-specific credential handling

**Key Aliases:**

**Quick commits:**
```bash
git cm "message"     # git commit -m "message"
git save             # Quick savepoint (adds all, commits)
git wip              # Work in progress commit
```

**Better logs:**
```bash
git l                # Oneline graph
git lg               # Pretty graph with colors
git tree             # Full tree view
```

**Branch management:**
```bash
git cob feature      # git checkout -b feature
git cleanup          # Delete merged branches
```

**Dotfiles helpers:**
```bash
git dots-save        # Quick commit with timestamp
git dots-diff        # See what changed
git dots-sync        # Pull and push
```

### Setup in Dotfiles

**Directory structure:**
```bash
cd ~/dotfiles
mkdir -p git

# Copy configs
cp /path/to/configs/.gitconfig git/.gitconfig
cp /path/to/configs/.gitignore_global git/.gitignore_global

# CRITICAL: Edit with your info!
nvim git/.gitconfig
# Change: name, email, github username

# Stow it
stow git
```

**Verify:**
```bash
ls -la ~/.gitconfig ~/.gitignore_global

git config --global user.name   # Should show your name
git config --global user.email  # Should show your email
```

### Important Customizations

**Before using, update these:**

```ini
[user]
    name = Your Actual Name          # CHANGE THIS
    email = your.real@email.com      # CHANGE THIS

[github]
    user = YOUR_GITHUB_USERNAME      # CHANGE THIS
```

**Machine-specific settings:**
```bash
# Create ~/.gitconfig.local for machine-specific overrides
nvim ~/.gitconfig.local

# Examples:
[user]
    signingkey = YOUR_GPG_KEY_ID

[commit]
    gpgsign = true
```

---

## 🚫 Global Gitignore (`.gitignore_global`)

### What It Includes

Comprehensive patterns for:
- ✅ OS files (macOS .DS_Store, Linux *~, Windows Thumbs.db)
- ✅ Editor files (Vim .swp, VSCode .vscode/, etc.)
- ✅ Language artifacts (Python __pycache__, Node node_modules/, etc.)
- ✅ Build files, logs, temporary files
- ✅ Credentials and secrets (.env, *.key, etc.)

### Usage

Already set up in the `.gitconfig`:
```ini
[core]
    excludesfile = ~/.gitignore_global
```

**Add custom patterns:**
```bash
echo "my-custom-pattern/" >> ~/.gitignore_global
```

---

## ⭐ Starship Prompt (`starship.toml`)

### What It Is

A modern, fast, cross-shell prompt that shows:
- Current directory
- Git status and branch
- Programming language versions
- Time
- OS icon
- Much more!

**Example prompt:**
```
┌─  ~/dotfiles  main !1 +2                           19:30
└─❯
```

### Features in This Config

**Information displayed:**
- ✅ OS icon (macOS  / Arch  / Linux )
- ✅ Current directory (with substitutions for common folders)
- ✅ Git branch and status
- ✅ Programming language versions (auto-detected)
- ✅ Current time
- ✅ Command duration (if > 500ms)
- ✅ Exit status on errors

**Color scheme:**
- Matches keyboard environment aesthetic
- Clean and minimal
- Easy to read

### Setup

**1. Install Starship:**

**macOS:**
```bash
brew install starship
```

**Arch Linux:**
```bash
sudo pacman -S starship
```

**2. Add to dotfiles:**
```bash
cd ~/dotfiles
mkdir -p starship/.config

# Copy config
cp /path/to/configs/starship.toml starship/.config/starship.toml

# Stow it
stow starship
```

**3. Verify:**
```bash
ls -la ~/.config/starship.toml

# Already enabled in .zshrc!
# If you see the prompt, it's working
```

### Customization

**Edit the config:**
```bash
nvim ~/.config/starship.toml
```

**Common customizations:**

**Change prompt symbol:**
```toml
[character]
success_symbol = '[➜](bold green)'  # Change ❯ to ➜
```

**Add workspace indicator:**
```toml
[custom.workspace]
command = """
if [ "$OS" = "macos" ]; then
    yabai -m query --spaces --space | jq -r '.index'
elif [ "$OS" = "linux" ]; then
    hyprctl activeworkspace | grep "workspace ID" | awk '{print $3}'
fi
"""
when = true
format = '[WS:$output]($style) '
style = 'bold yellow'
```

**Disable time:**
```toml
[time]
disabled = true
```

---

## 📦 Dotfiles Structure

After adding all these configs:

```
~/dotfiles/
├── zsh/
│   └── .zshrc
├── git/
│   ├── .gitconfig
│   └── .gitignore_global
├── starship/
│   └── .config/
│       └── starship.toml
├── nvim/
│   └── .config/nvim/...
├── wezterm/
│   └── .wezterm.lua
├── tmux/
│   └── .tmux.conf
├── hyprland/          # Linux only
│   └── .config/hypr/...
├── yabai/             # macOS only
│   └── .config/yabai/...
└── skhd/              # macOS only
    └── .config/skhd/...
```

---

## 🚀 Quick Setup Guide

### Step 1: Add Configs to Dotfiles

```bash
cd ~/dotfiles

# Create package directories
mkdir -p zsh git starship/.config

# Copy configs (update paths!)
cp ~/.zshrc zsh/.zshrc
cp .gitconfig git/.gitconfig
cp .gitignore_global git/.gitignore_global
cp starship.toml starship/.config/starship.toml
```

### Step 2: Customize

```bash
# IMPORTANT: Edit before stowing!
nvim git/.gitconfig      # Add your name/email
nvim zsh/.zshrc          # Review and adjust
nvim starship/.config/starship.toml  # Optional tweaks
```

### Step 3: Remove Old Configs

```bash
# Backup first!
mv ~/.zshrc ~/.zshrc.backup
mv ~/.gitconfig ~/.gitconfig.backup
mv ~/.gitignore_global ~/.gitignore_global.backup
mv ~/.config/starship.toml ~/.config/starship.toml.backup
```

### Step 4: Stow

```bash
cd ~/dotfiles
stow zsh
stow git
stow starship

# Verify symlinks
ls -la ~/.zshrc ~/.gitconfig ~/.config/starship.toml
```

### Step 5: Test

```bash
# Reload shell
source ~/.zshrc

# Should see Starship prompt
# Test git aliases
git l

# Test dotfiles helpers
stowlist

# Test bunch helper
bunch
```

### Step 6: Commit

```bash
cd ~/dotfiles
git add zsh git starship
git commit -m "Add shell and utility configs"
git push
```

---

## 🔄 Tool Installation Guide

### Essential Tools

**macOS:**
```bash
# Core tools
brew install fzf zoxide starship eza fd ripgrep bat htop

# Optional but recommended
brew install lazygit delta git-delta

# Zsh plugins
brew install zsh-syntax-highlighting zsh-autosuggestions
```

**Arch Linux:**
```bash
# Core tools
sudo pacman -S fzf zoxide starship eza fd ripgrep bat htop

# Optional but recommended
sudo pacman -S lazygit git-delta

# Zsh plugins (already installed in setup guide)
sudo pacman -S zsh-syntax-highlighting zsh-autosuggestions
```

### Tool Descriptions

**FZF** - Fuzzy finder
- Ctrl+R → Search command history
- Ctrl+T → Search files
- Alt+C → Change directory

**Zoxide** - Smart cd
- `z <partial-path>` → Jump to frequently used directories
- Learns from your usage patterns

**Starship** - Modern prompt
- Fast (written in Rust)
- Cross-shell compatible
- Highly customizable

**Eza** - Modern ls
- Better colors and icons
- Git integration
- Tree view

**Fd** - Modern find
- Faster than find
- Intuitive syntax
- Respects .gitignore

**Ripgrep** - Modern grep
- Blazing fast code search
- Respects .gitignore
- Syntax highlighting

**Bat** - Modern cat
- Syntax highlighting
- Git integration
- Line numbers

---

## 🎯 Usage Examples

### Dotfiles Workflow

**Make a change:**
```bash
# Edit config (it's a symlink!)
nvim ~/.zshrc

# Actually editing: ~/dotfiles/zsh/.zshrc

# Commit
cd ~/dotfiles
git dots-save  # Quick commit with timestamp
# or
git add zsh && git cm "Add custom function" && git push
```

**Deploy to new machine:**
```bash
git clone <your-repo> ~/dotfiles
cd ~/dotfiles
stow zsh git starship
source ~/.zshrc
```

### Git Shortcuts

**Quick workflow:**
```bash
# Edit files
nvim file.txt

# Add and commit
git cm "Update file"

# Oops, forgot something
git can  # Amend without editing message

# Push
git p
```

**Branch cleanup:**
```bash
# After merging PRs
git cleanup  # Removes all merged branches
```

### Bunch Management

**List bunches:**
```bash
bunch
# Shows all available bunches
```

**Run bunch:**
```bash
bunch coding-project
# Activates coding environment
```

**Create new bunch:**
```bash
cd ~/workflow/bunches
cp templates/bunch-template.sh my-bunch.sh
nvim my-bunch.sh
chmod +x my-bunch.sh
```

---

## 🐛 Troubleshooting

### Zsh: Command not found

**Problem:** Aliases or functions not working

**Solution:**
```bash
source ~/.zshrc
# or
reload  # Alias for source ~/.zshrc
```

### Git: Config not loading

**Problem:** Git aliases don't work

**Solution:**
```bash
# Check if symlink is correct
ls -la ~/.gitconfig

# Verify config
git config --list | grep alias

# Re-stow
cd ~/dotfiles && stow -R git
```

### Starship: Not showing

**Problem:** Still see basic prompt

**Solution:**
```bash
# Check if installed
starship --version

# Check if in .zshrc
grep starship ~/.zshrc

# Should see: eval "$(starship init zsh)"

# Reload
source ~/.zshrc
```

### FZF: Keybindings not working

**Problem:** Ctrl+R doesn't search history

**Solution:**
```bash
# Check if installed
fzf --version

# Re-source in .zshrc
source ~/.zshrc

# If still not working, manually source:
source <(fzf --zsh)
```

---

## ✅ Verification Checklist

After setup, verify:

- [ ] Starship prompt appears
- [ ] Git aliases work (`git l`)
- [ ] Dotfiles helpers work (`stowlist`)
- [ ] Bunch command works (`bunch`)
- [ ] FZF works (Ctrl+R for history)
- [ ] Zoxide works (`z <dir>`)
- [ ] Eza works (`ls` shows colors/icons)
- [ ] All symlinks correct (`ls -la ~/.zshrc` etc.)
- [ ] Git shows your name/email (`git config user.name`)

---

## 📚 Additional Resources

**Starship:**
- Docs: https://starship.rs/
- Config: https://starship.rs/config/

**FZF:**
- GitHub: https://github.com/junegunn/fzf
- Examples: https://github.com/junegunn/fzf/wiki/examples

**Zoxide:**
- GitHub: https://github.com/ajeetdsouza/zoxide

**Eza:**
- GitHub: https://github.com/eza-community/eza

---

## 🎉 Summary

You now have:
- ✅ Comprehensive Zsh configuration
- ✅ Productive Git setup with 30+ aliases
- ✅ Global gitignore for all projects
- ✅ Modern Starship prompt
- ✅ Full integration with keyboard environment
- ✅ All managed with GNU Stow

**These configs complete your workflow with:**
- Keyboard-driven efficiency
- Cross-platform compatibility
- Git-managed and deployable
- Respects your modifier layer philosophy

**Happy hacking!** ⌨️🚀
