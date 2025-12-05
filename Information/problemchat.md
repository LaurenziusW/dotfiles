# Arch Bootstrap Hyprland Keybinding Fix

> Exported on: 12/5/2025, 2:30:29 PM

---

## 👤 You

laurenziusw/dotfilesGitHub the bootstrap arch produces some issues. super entwr doesnt work. pressing space brings up spotlight but pressing enter does not open these apps. also there is a config errorline 17 empty lhs. I am somehow able to open firefox, there it becomes apparant, that enter doesnt register onlz alt plus enter registers as only enter!!!!

## 🤖 Gemini

You've identified a critical bug in the bootstrap script that explains exactly why your system is behaving strangely.

### The Problem

The error `Config error ... at line 17: Empty lhs` and the "Enter not working" issue are caused by the same bug in `bootstrap_arch.sh`.

The script uses a "heredoc" (`<<EOF`) to create the config file. By default, Bash tries to replace any text starting with `$` inside a heredoc with variables. Since `$mainMod` wasn't defined in the install script, Bash replaced it with **nothing**.

1.  **Line 17 Error:** `  = SUPER ` (instead of `$mainMod = SUPER`) causes the config error.
2.  **Enter Key Broken:** `bind = , RETURN, exec, wezterm` (instead of `bind = $mainMod, RETURN...`) tells Hyprland to hijack the **Enter** key globally to launch the terminal.
3.  **Alt+Enter Works:** Because the broken binding specifically looks for "No Modifier + Enter", holding Alt bypasses the hijacker, allowing the keypress to reach the application.

-----

### Phase 1: Immediate Fix (Get your system working)

Since you can open a terminal (using `Alt+Enter` in Wofi/Firefox if needed), run this command to overwrite the broken config with a working one.

**Copy and run this entire block in your terminal:**

```bash
cat > ~/.config/hypr/hyprland.conf <<'EOF'
# --- RECOVERY CONFIG ---
monitor=,preferred,auto,1

input {
    kb_layout = us
    follow_mouse = 1
}

general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(33ccffee)
    layout = dwindle
}

$mainMod = SUPER

# Essentials
bind = $mainMod, RETURN, exec, wezterm
bind = $mainMod, B, exec, firefox
bind = $mainMod, M, exit, 
bind = $mainMod, Q, killactive, 
bind = $mainMod, Space, exec, wofi --show drun

# Navigation
bind = $mainMod, h, movefocus, l
bind = $mainMod, l, movefocus, r
bind = $mainMod, k, movefocus, u
bind = $mainMod, j, movefocus, d

exec-once = waybar
EOF
```

**Then reload Hyprland:**
You can usually do this by pressing `Super + M` (based on the config above to exit) and logging back in, or running `hyprctl reload` in the terminal.

-----

### Phase 2: Fix the Source (`bootstrap_arch.sh`)

We need to update the file in your `newuke` repo so this doesn't happen again. The fix is adding quotes around `EOF` (like `<<'EOF'`), which tells Bash "treat this strictly as text, do not expand variables."

**Updated `uke/arch/bootstrap.sh`:**

```bash
#!/usr/bin/env bash
# =============================================================================
# UKE v8 - Arch Linux Bootstrap
# Installs git, stow, hyprland, and sets up a minimal environment.
# =============================================================================
set -e

echo ">> [1/5] Updating System & Installing Essentials..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm \
    base-devel \
    git \
    stow \
    neovim \
    hyprland \
    waybar \
    wezterm \
    wofi \
    ttf-jetbrains-mono-nerd \
    firefox

echo ">> [2/5] Creating Directory Structure..."
# Create the stow targets in HOME so stow doesn't symlink the parent folders
mkdir -p ~/.config/{hypr,waybar,nvim,wezterm,yabai,skhd}
mkdir -p ~/.local/{bin,state/uke,share}

echo ">> [3/5] Creating Minimal Recovery Hyprland Config..."
# IMPORTANT: We use 'EOF' (quoted) to prevent $variable expansion during generation
cat > ~/.config/hypr/hyprland.conf <<'EOF'
# --- RECOVERY CONFIG ---
monitor=,preferred,auto,1

input {
    kb_layout = us
    follow_mouse = 1
}

general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(33ccffee)
    layout = dwindle
}

$mainMod = SUPER

# Essentials
bind = $mainMod, RETURN, exec, wezterm
bind = $mainMod, B, exec, firefox
bind = $mainMod, M, exit, 
bind = $mainMod, Q, killactive, 
bind = $mainMod, Space, exec, wofi --show drun

# Navigation
bind = $mainMod, h, movefocus, l
bind = $mainMod, l, movefocus, r
bind = $mainMod, k, movefocus, u
bind = $mainMod, j, movefocus, d

exec-once = waybar
EOF

echo ">> [4/5] Creating Dummy Local Overrides..."
# This prevents errors when you eventually stow your real configs
touch ~/.config/hypr/local.conf
touch ~/.zshrc.local
mkdir -p ~/.config/wezterm
echo "return {}" > ~/.config/wezterm/local.lua

echo ">> [5/5] Bootstrap Complete!"
echo "----------------------------------------------------------------"
echo "You can now type 'Hyprland' to start the graphical session."
echo ""
echo "Once inside:"
echo "  1. Open Terminal (Super + Enter)"
echo "  2. Clone your repo (if not done): git clone <url> ~/dotfiles/newuke"
echo "  3. Run: ~/dotfiles/newuke/installation_manager.sh install"
echo "----------------------------------------------------------------"
```

Would you like me to create the next verification step for `keyd` configuration, given you mentioned issues with keys registering?

---

## 👤 You

the old bootstrap config also had the error that hjkl where always for window swtiching even when super was not pressed. maybe there was a issue as to where it was always active. will this come up with the new config?

## 🤖 Gemini

No, this issue will **not** come up with the new configuration. You are absolutely correct about what was happening, and the fix I provided solves that specific problem as well.

Here is exactly why that happened and why it is fixed now:

### Why `hjkl` Were "Always Active" (The Bug)

In the old bootstrap script, because `EOF` was not quoted, Bash tried to find a value for the variable `$mainMod`. Since it wasn't defined, it replaced it with **nothing**.

This turned the intended line:
`bind = $mainMod, h, movefocus, l`

Into this:
`bind = , h, movefocus, l`

In Hyprland syntax, a comma with nothing before it means **"No Modifier"**. This told the system: "Whenever `h` is pressed (even when typing), move focus left."

### Why the New Config Fixes It

The updated script uses `<<'EOF'` (with single quotes). This tells Bash: "Do **not** touch any variables inside this block."

The new file will be written exactly as intended:

1.  It defines the variable: `$mainMod = SUPER`
2.  It uses the variable: `bind = $mainMod, h, movefocus, l`

Hyprland will now see the modifier is required, so `h`, `j`, `k`, and `l` will act as normal letters unless you are holding **Super**.

### Verification

If you ran the fix command from my previous response, you can verify it worked by looking at the file:

```bash
cat ~/.config/hypr/hyprland.conf | grep "bind ="
```

You should see lines starting with `bind = $mainMod...`. If you see `bind = ,...` anywhere, the fix didn't apply correctly, and you should run the block again.

---

