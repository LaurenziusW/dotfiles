## Hyprland Configuration Reference (v0.51+)

A comprehensive, error-proof guide for Hyprland window manager configuration. This reference is structured for clarity and designed to prevent common configuration mistakes.

***

### Quick Reference: Configuration File Order

Maintain this order in your `~/.config/hypr/hyprland.conf` to avoid parsing errors that prevent keybindings from loading:

1. **Monitors** — Display configuration
2. **Variables** — Global shortcuts and application names
3. **Autostart** — `exec-once` commands (run once at startup)
4. **Environment** — Environment variables
5. **Input** — Keyboard and touchpad settings
6. **General** — General window manager behavior
7. **Decoration** — Visual effects (borders, shadows, rounding)
8. **Animations** — Animation curves and timing
9. **Layouts** — Layout-specific settings (dwindle, master, etc.)
10. **Gestures** — Trackpad gestures (new in v0.51)
11. **Window Rules (v2)** — Window-specific behavior
12. **Keybindings** — All bind statements (must come after all other configurations)

***

### Critical Breaking Changes (v0.51+)

#### Gesture System Completely Overhauled

**Old syntax (v0.50 and earlier) — REMOVED:**
```
gestures {
    workspace_swipe = true
    workspace_swipe_fingers = 3
}
```

**New syntax (v0.51+) — REQUIRED:**
```
gesture = fingers, direction, action, [options]
```

**Common gesture configuration errors and fixes:**

| Error | Cause | Fix |
|-------|-------|-----|
| "Error 126" or config parse failure | Old `gestures{}` block still present | Replace entire `gestures{}` section with new `gesture =` lines |
| Gesture not working | Missing fingers parameter | Always specify: `gesture = 3, horizontal, workspace` |
| Gesture conflict | Multiple gestures for same trigger | Use modifiers to differentiate: `gesture = 3, down, mod: ALT, close` |

#### Shadow Property Renamed

| Version | Property | Status |
|---------|----------|--------|
| v0.50 and earlier | `drop_shadow` | ❌ Removed |
| v0.50+ | `shadow` | ✓ Current |

Update all shadow configurations:
```
# OLD (broken)
decoration {
    drop_shadow = true
}

# NEW (correct)
decoration {
    shadow {
        enabled = true
        range = 8
    }
}
```

***

### Gesture Configuration (New in v0.51)

#### Syntax Rules

```
gesture = fingers, direction, action, [options]
```

- **fingers** — Number of touch points (integer, e.g., `3`)
- **direction** — Swipe or pinch direction (see table below)
- **action** — Gesture behavior (see Actions table)
- **options** — Optional modifiers, scale, or parameters

#### Supported Directions

| Direction | Type | Meaning |
|-----------|------|---------|
| `swipe` | Any swipe | Matches any swipe regardless of direction |
| `horizontal` | Swipe plane | Left or right swipe |
| `vertical` | Swipe plane | Up or down swipe |
| `left` | Directional | Swipe left |
| `right` | Directional | Swipe right |
| `up` | Directional | Swipe up |
| `down` | Directional | Swipe down |
| `pinch` | Pinch gesture | Any pinch (zoom) |
| `pinchin` | Pinch direction | Pinch inward (zoom out) |
| `pinchout` | Pinch direction | Pinch outward (zoom in) |

#### Supported Actions

| Action | Parameters | Description |
|--------|-----------|-------------|
| `workspace` | none | Switch to next/previous workspace based on swipe direction |
| `move` | none | Move active window in swipe direction |
| `resize` | none | Resize active window in swipe direction |
| `special` | workspace name | Toggle special workspace (e.g., `special, magic`) |
| `close` | none | Close active window |
| `fullscreen` | none or `maximize` | Toggle fullscreen or maximize |
| `float` | none, `float`, or `tile` | Toggle float, force float, or force tile |
| `dispatcher` | dispatcher, params | Execute any Hyprland dispatcher |

#### Gesture Options

| Option | Format | Purpose |
|--------|--------|---------|
| `mod` | `mod: MODMASK` | Restrict gesture to specific modifier(s) |
| `scale` | `scale: FLOAT` | Animation speed multiplier (e.g., `1.5`) |

#### Common Gesture Configurations

**Basic workspace switching:**
```
gesture = 3, left, workspace, +1
gesture = 3, right, workspace, -1
```

**With modifier restrictions:**
```
gesture = 3, down, mod: ALT, close
gesture = 3, up, mod: SUPER, scale: 1.5, fullscreen
```

**Special workspace toggling:**
```
gesture = 3, up, special, magic
gesture = 3, down, special, scratchpad
```

**Window operations:**
```
gesture = 3, left, float
gesture = 4, pinchout, resize
```

**Using dispatcher:**
```
gesture = 3, down, dispatcher, exec, wmctrl -l
```

***

### Core Configuration Blocks

#### Monitor Configuration

```
monitor=,preferred,auto,1
```

- First value: monitor name (empty = auto-detect)
- `preferred`: native resolution
- `auto`: position (auto-place or specify X,Y)
- `1`: scale factor

#### Variables (Global Shortcuts)

```
$terminal = wezterm
$menu = wofi --show drun
$mainMod = SUPER
```

**Best practices:**
- Define all repeated values as variables
- Use descriptive names
- Reference consistently throughout config

#### General Settings

```
general {
    gaps_in = 4
    gaps_out = 8
    border_size = 2
    col.active_border = rgba(88c0d0ff)
    col.inactive_border = rgba(3b4252ff)
    layout = dwindle
    resize_on_border = true
    no_border_on_floating = false
}
```

#### Decoration & Visual Effects

```
decoration {
    rounding = 4
    
    blur {
        enabled = true
        size = 6
        passes = 2
        noise = 0.0117
    }
    
    shadow {
        enabled = true
        range = 8
        render_power = 3
        color = rgba(1a1a1aee)
        offset = 0 0
    }
}
```

**Critical:** `drop_shadow` is obsolete. Use `shadow{}` block instead.

#### Animations

```
animations {
    enabled = true
    
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    
    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
    animation = specialWorkspace, 1, 6, default, slidevert
}
```

#### Input Configuration

```
input {
    kb_layout = us
    kb_variant = 
    kb_model = 
    kb_options = 
    kb_rules = 
    
    follow_mouse = 1
    
    touchpad {
        natural_scroll = true
        disable_while_typing = true
        drag_lock = false
    }
}
```

#### Layouts

```
dwindle {
    pseudotile = true
    preserve_split = true
    smart_split = false
}

master {
    allow_small_split = false
    special_scale_factor = 0.8
    mfact = 0.55
}
```

***

### Window Rules (v2)

**Syntax:**
```
windowrulev2 = property, match condition
```

#### Critical Rule Usage Notes

**Always use `windowrulev2`, NOT `windowrule`** — The older `windowrule` syntax is deprecated and causes configuration conflicts.

#### Common Window Matching Conditions

| Condition | Format | Example |
|-----------|--------|---------|
| Class (regex) | `class:^(pattern)$` | `class:^(firefox)$` |
| Title (regex) | `title:^(pattern)$` | `title:^(VLC)$` |
| Initial class | `initialclass:^(pattern)$` | `initialclass:^(foot)$` |
| Window title on creation | `initialtitle:^(pattern)$` | Matches title when window first appears |
| Floating state | `floating:0` or `floating:1` | `floating:1` for floating windows |
| Workspace selector | `onworkspace:SELECTOR` | `onworkspace:w[t1]` (tiled on workspace 1) |
| Active window | `activewindow` | Current focused window |

#### Window Rule Properties

| Property | Effect | Example |
|----------|--------|---------|
| `float` | Make window floating | `windowrulev2 = float, class:pavucontrol` |
| `tile` | Make window tiled | `windowrulev2 = tile, class:firefox` |
| `workspace WORKSPACE` | Move to workspace | `windowrulev2 = workspace 2, class:firefox` |
| `workspace special:NAME` | Move to special workspace | `windowrulev2 = workspace special:magic, class:kitty` |
| `size DIMENSIONS` | Set window size | `windowrulev2 = size 800 600, class:myapp` |
| `move POSITION` | Set window position | `windowrulev2 = move 100 100, class:myapp` |
| `monitor ID` | Move to specific monitor | `windowrulev2 = monitor 1, class:firefox` |
| `bordersize SIZE` | Override border size | `windowrulev2 = bordersize 0, floating:1` |
| `rounding RADIUS` | Override rounding | `windowrulev2 = rounding 10, class:myapp` |
| `nofocus` | Don't focus on creation | `windowrulev2 = nofocus, class:notification` |
| `noshadow` | Disable shadows | `windowrulev2 = noshadow, class:slurp` |
| `noborder` | Disable borders | `windowrulev2 = noborder, class:rofi` |
| `noanim` | Disable animations | `windowrulev2 = noanim, class:splash` |
| `suppressevent` | Suppress window events | `windowrulev2 = suppressevent maximize, class:.*` |
| `opacity FLOAT` | Set window opacity | `windowrulev2 = opacity 0.8, class:firefox` |
| `group` | Group windows together | `windowrulev2 = group new, class:^(firefox\|chromium)$` |

#### Window Rule Examples

```
# Float specific applications
windowrulev2 = float, class:^(pavucontrol)$
windowrulev2 = float, title:^(Open File)$

# Move applications to specific workspaces
windowrulev2 = workspace 2, class:^(firefox)$
windowrulev2 = workspace special:magic, class:^(foot)$

# Modify window appearance on specific workspaces
windowrulev2 = bordersize 0, floating:0, onworkspace:w[t1]
windowrulev2 = rounding 0, floating:0, onworkspace:w[t1]

# Ignore maximize events
windowrulev2 = suppressevent maximize, class:.*

# Set opacity for specific apps
windowrulev2 = opacity 0.9, class:^(wezterm)$

# Disable animations for notifications
windowrulev2 = noanim, class:^(notify-osd)$

# Floating windows in specific workspaces
windowrulev2 = float, workspace:special

# Prevent focus on creation
windowrulev2 = nofocus, class:^(notification)$
```

***

### Keybinding Configuration

**Syntax:**
```
bind = MODIFIERS, KEY, DISPATCHER, ARGS
bindm = MODIFIERS, MOUSE_BUTTON, DISPATCHER, ARGS
```

#### Modifier Keys

| Modifier | Symbol |
|----------|--------|
| Super (Windows key) | `SUPER` |
| Control | `CTRL` |
| Shift | `SHIFT` |
| Alt | `ALT` |
| Combination | `SUPER CTRL` or `SUPER_CTRL` |

#### Key Syntax

| Format | Example | Meaning |
|--------|---------|---------|
| Letter | `a`, `Return` | ASCII character or named key |
| Keycode | `code:42` | Numeric keycode |
| Number | `123` | Raw keycode number |
| Mouse button | `mouse:272` | Mouse button ID (272=left, 273=right, 274=middle) |

#### Common Keybinding Patterns

**Window management:**
```
bind = $mainMod, Return, exec, $terminal
bind = $mainMod, Q, killactive
bind = $mainMod, V, togglefloating
bind = $mainMod, M, exit
```

**Focus navigation (Vim-style):**
```
bind = $mainMod, h, movefocus, l
bind = $mainMod, l, movefocus, r
bind = $mainMod, k, movefocus, u
bind = $mainMod, j, movefocus, d
```

**Workspace switching:**
```
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
# ... continue to 9
```

**Move window to workspace:**
```
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
# ... continue to 9
```

**Special workspace:**
```
bind = $mainMod, S, togglespecialworkspace, magic
```

**Mouse bindings:**
```
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow
```

***

### Troubleshooting Configuration Errors

#### Parse Failures & Keybinding Issues

**Problem:** Keybinds don't work after config change.

**Cause:** Configuration syntax error occurs *before* the keybinding section, preventing the entire config from loading.

**Solution:**
1. Check `~/.config/hypr/hyprland.log` for error location
2. Use `hyprctl reload` to test config without restarting
3. Verify syntax around the reported line number
4. Ensure configuration blocks are properly closed

#### Unknown Key/Property Errors

**Problem:** "Unknown key" or "Unknown option" errors.

**Cause:** Property name changed between versions.

**Solution:**
1. Check [Hyprland Wiki](https://wiki.hypr.land/) for current syntax
2. Common renames:
   - `drop_shadow` → `shadow` (v0.50+)
   - `gestures{}` → `gesture =` (v0.51+)
   - `windowrule` → `windowrulev2` (recommended)

#### Source Globbing Errors

**Problem:** Error about source wildcards.

**Cause:** `source=` statement with wildcard (`*`) pointing to non-existent files or paths.

**Solution:**
```
# BAD (if config files don't exist)
source=~/.config/hypr/*.conf

# GOOD (if you're confident files exist)
source=~/.config/hypr/custom.conf
```

#### Special Workspace Issues

**Problem:** `togglespecialworkspace` not working or errors.

**Cause:** Incorrect dispatcher syntax or missing workspace name.

**Solution:**
```
# CORRECT
bind = $mainMod, S, togglespecialworkspace, magic

# WRONG (don't use exec)
bind = $mainMod, S, exec, togglespecialworkspace, magic

# WRONG (need workspace name)
bind = $mainMod, S, togglespecialworkspace
```

#### Gesture Configuration Issues

**Problem:** Gestures not recognized or old gesture syntax errors.

**Cause:** Still using v0.50 or earlier gesture syntax.

**Solution:**
```
# OLD (broken in v0.51+)
gestures {
    workspace_swipe = true
}

# NEW (required for v0.51+)
gesture = 3, left, workspace, +1
gesture = 3, right, workspace, -1
```

***

### Minimal Valid Configuration (v0.51+)

Use this as a starting template to build your configuration:

```
# ===== MONITORS =====
monitor=,preferred,auto,1

# ===== VARIABLES =====
$terminal = wezterm
$menu = wofi --show drun
$mainMod = SUPER

# ===== AUTOSTART =====
exec-once = waybar

# ===== ENVIRONMENT =====
env = XCURSOR_SIZE,24

# ===== INPUT =====
input {
    kb_layout = us
    follow_mouse = 1
    touchpad {
        natural_scroll = true
    }
}

# ===== GENERAL =====
general {
    gaps_in = 4
    gaps_out = 8
    border_size = 2
    col.active_border = rgba(88c0d0ff)
    col.inactive_border = rgba(3b4252ff)
    layout = dwindle
}

# ===== DECORATION =====
decoration {
    rounding = 4
    blur {
        enabled = true
        size = 6
        passes = 2
    }
    shadow {
        enabled = true
        range = 8
        render_power = 3
    }
}

# ===== ANIMATIONS =====
animations {
    enabled = true
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 7, myBezier
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

# ===== LAYOUT =====
dwindle {
    pseudotile = true
    preserve_split = true
}

# ===== GESTURES =====
gesture = 3, horizontal, workspace
gesture = 3, up, special, magic

# ===== WINDOW RULES =====
windowrulev2 = suppressevent maximize, class:.*
windowrulev2 = float, class:^(pavucontrol)$

# ===== KEYBINDINGS =====
bind = $mainMod, Return, exec, $terminal
bind = $mainMod, Q, killactive
bind = $mainMod, V, togglefloating
bind = $mainMod, R, exec, $menu

bind = $mainMod, h, movefocus, l
bind = $mainMod, l, movefocus, r
bind = $mainMod, k, movefocus, u
bind = $mainMod, j, movefocus, d

bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3

bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3

bind = $mainMod, S, togglespecialworkspace, magic

bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow
```

***

### Best Practices for Error-Free Configurations

**1. Configuration Order is Critical**
- Always place configuration blocks in the specified order
- Keybindings **must** come last
- Configuration errors before keybindings prevent all binds from loading

**2. Use Variables Consistently**
- Define all frequently used values as variables
- Reference variables instead of hardcoding values
- Makes bulk changes trivial

**3. Prefer v2 Window Rules**
- Use `windowrulev2` exclusively
- Avoid deprecated `windowrule` syntax
- Provides more flexible matching options

**4. Test Configuration Changes**
- Use `hyprctl reload` to test without restarting
- Check `~/.config/hypr/hyprland.log` for specific errors
- Line numbers in errors guide you to problem areas

**5. Comment Configuration Sections**
- Use clear section headers
- Group related settings
- Makes future maintenance easier

**6. Validate Syntax Before Restarting**
- Minor typos can break entire keybinding system
- Always check log file for parse errors
- Test with `hyprctl reload` first

***

### Version Information

This reference is accurate for **Hyprland v0.51+**. Configuration may differ for older versions. Always check the [official Hyprland Wiki](https://wiki.hypr.land/) for your specific version.

Sources
