# UKE Philosophy: Implementing Features the Right Way

This document explains UKE's architectural principles and how to implement new features in a way that maintains consistency, portability, and maintainability.

## Core Principles

### 1. Single Source of Truth (SSOT)

**Everything derives from `registry.yaml`.**

The registry is the canonical definition of:
- Keybindings and their modifiers
- Application names (cross-platform)
- Workspace assignments
- Window rules
- Service definitions
- Scratchpad configurations

**Why this matters:** When you want to change a keybinding, you change it in ONE place. The generators (`gen.sh`) then produce platform-specific configs.

```yaml
# Good: Define once
keybindings:
  sticky:
    key: "s"
    mod: "primary_shift"
    command: "uke-sticky toggle"

# gen.sh produces:
# - Hyprland: bind = ALT SHIFT, S, exec, uke-sticky toggle
# - skhd:     cmd + shift - s : uke-sticky toggle
```

**Anti-pattern:** Never hardcode platform-specific keybindings directly in config files.

---

### 2. Modifier Abstraction

UKE uses **semantic modifiers** that map to platform-specific keys:

| Semantic | macOS | Linux |
|----------|-------|-------|
| `primary` | Cmd | Alt |
| `primary_shift` | Cmd+Shift | Alt+Shift |
| `secondary` | Alt | Super |
| `secondary_shift` | Alt+Shift | Super+Shift |
| `tertiary` | Alt+Shift | Super+Shift |
| `quaternary` | Ctrl | Ctrl |

**When implementing a new keybinding:**

1. Choose the appropriate semantic modifier based on the action's "tier":
   - `primary`: Core WM operations (focus, move windows)
   - `primary_shift`: Window manipulation (resize, special modes like sticky)
   - `secondary`: Terminal/app-internal bindings
   - `launcher`: Multi-key launchers (Cmd+Alt / Alt+Super)

2. Define it in `registry.yaml` using the semantic name
3. Let `gen.sh` handle the platform translation

---

### 3. Cross-Platform Command Abstraction

Commands should be **platform-agnostic wrappers** that detect the environment and call the appropriate tool.

**Pattern:**

```bash
#!/usr/bin/env bash
# uke-<feature>

if is_linux; then
    if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
        hyprland_implementation
    fi
elif is_macos; then
    yabai_implementation
fi
```

**Example: `uke-sticky`**

```bash
# The command abstracts away:
# - Hyprland: hyprctl dispatch togglefloating + pin
# - Yabai: yabai -m window --toggle float/sticky/topmost

# User just runs: uke-sticky toggle
# Works identically on both platforms
```

**Anti-pattern:** Don't create `uke-sticky-hyprland` and `uke-sticky-yabai`. One command, multiple implementations.

---

### 4. State Management

For features that need to track state (like sticky windows), use:

```
$XDG_STATE_HOME/uke/  (~/.local/state/uke/)
├── sticky_windows      # List of sticky window IDs
├── crash_count         # Autostart crash tracking
├── machine.profile     # Hardware profile
└── setup-state         # Setup wizard progress
```

**Why XDG_STATE_HOME?**
- `~/.config/` is for user-editable configuration
- `~/.local/state/` is for runtime state that can be regenerated
- `~/.local/share/` is for persistent user data (backups)

---

### 5. Ghost Files (Hardware Abstraction)

**Ghost files** are machine-specific configurations generated from the profile:

```
~/.config/hypr/generated_hardware.conf
~/.config/wezterm/generated_hardware.lua
```

These contain:
- GPU-specific settings (nvidia vs intel vs amd)
- Form factor adjustments (laptop vs desktop)
- Monitor configurations
- Font size scaling

**Why?**
- Same dotfiles work on multiple machines
- Hardware-specific tweaks don't pollute main configs
- `uke apply` regenerates them from `machine.profile`

**When adding hardware-dependent features:**

1. Add the setting to `scripts/apply_profile.sh`
2. Reference the ghost file in your stow config
3. Document the setting in the profile options

---

### 6. Graceful Degradation

Every UKE command should:

1. **Check prerequisites** before acting
2. **Fail gracefully** with helpful messages
3. **Work without optional dependencies** where possible

**Example:**

```bash
# Good: Check if we're in the right environment
if [[ -z "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    warn "Hyprland not running, skipping..."
    return 0
fi

# Good: Fallback when optional tool missing
if command -v reflector &>/dev/null; then
    reflector --latest 20 ...
else
    warn "reflector not installed, skipping mirror optimization"
fi
```

---

### 7. Generator Flow

```
registry.yaml
     │
     ▼
  gen.sh
     │
     ├──▶ gen/hyprland/keybinds.conf
     ├──▶ gen/skhd/skhdrc
     └──▶ gen/yabai/yabairc

machine.profile
     │
     ▼
apply_profile.sh
     │
     ├──▶ ~/.config/hypr/generated_hardware.conf
     └──▶ ~/.config/wezterm/generated_hardware.lua
```

**When adding a new feature:**

1. Define it in `registry.yaml` (if it's a keybinding, app, or setting)
2. Update `gen.sh` to parse and output platform configs
3. Create the `uke-<feature>` command in `bin/`
4. If hardware-dependent, add to `apply_profile.sh`
5. Document in README.md

---

## Implementation Checklist

When adding a new feature, ask yourself:

### ☐ Is it defined in registry.yaml?
- Keybindings → `keybindings:` section
- Apps → `apps:` section  
- Services → `services:` section
- Window rules → `window_rules:` section

### ☐ Is it cross-platform?
- Single command with platform detection
- Uses semantic modifiers
- Tested on both macOS and Linux (or gracefully degrades)

### ☐ Does it follow UKE conventions?
- Script in `bin/` with `uke-` prefix
- Sources `lib/core.sh` for colors and helpers
- Uses `ok()`, `fail()`, `info()`, `warn()` for output
- Includes `--help` documentation
- Is executable (`chmod +x`)

### ☐ Is state properly managed?
- Runtime state → `$XDG_STATE_HOME/uke/`
- User data → `$XDG_DATA_HOME/uke/`
- Config → `$XDG_CONFIG_HOME/uke/` or `$UKE_ROOT/config/`

### ☐ Does it fail gracefully?
- Checks for required tools
- Provides helpful error messages
- Suggests fixes when things go wrong

### ☐ Is it documented?
- Added to README.md
- Has `--help` output
- Comments in code explain "why" not just "what"

---

## Example: Adding the Sticky Feature

Here's how `uke-sticky` was implemented following these principles:

### Step 1: Define in registry.yaml

```yaml
keybindings:
  sticky:
    key: "s"
    mod: "primary_shift"      # Alt+Shift on Linux, Cmd+Shift on macOS
    action: "exec"
    command: "uke-sticky toggle"
```

### Step 2: Create cross-platform command

```bash
# bin/uke-sticky

if is_linux; then
    hyprland_toggle()  # Uses hyprctl
elif is_macos; then
    yabai_toggle()     # Uses yabai -m
fi
```

### Step 3: Implement platform-specific logic

**Hyprland:**
```bash
hyprctl dispatch togglefloating
hyprctl dispatch pin
```

**Yabai:**
```bash
yabai -m window --toggle float
yabai -m window --toggle sticky
yabai -m window --toggle topmost
```

### Step 4: Track state

```bash
STICKY_STATE="$XDG_STATE_HOME/uke/sticky_windows"
echo "$window_id" >> "$STICKY_STATE"  # Remember it's sticky
```

### Step 5: Make it toggleable

```bash
if is_already_sticky "$window_id"; then
    unmake_sticky "$window_id"
else
    make_sticky "$window_id"
fi
```

### Step 6: Add subcommands

```bash
case "${1:-toggle}" in
    toggle) ... ;;
    list)   ... ;;
    clear)  ... ;;
esac
```

### Step 7: Document

- Added to README.md
- Includes `--help`
- This philosophy doc

---

## Avoid These Mistakes

### ❌ Hardcoding platform-specific values

```bash
# Bad
bind = ALT, S, exec, uke-sticky

# Good: Let gen.sh produce this from registry.yaml
```

### ❌ Creating duplicate commands

```bash
# Bad
bin/uke-sticky-hyprland
bin/uke-sticky-yabai

# Good: One command with internal platform detection
bin/uke-sticky
```

### ❌ Scattering state files

```bash
# Bad
~/.sticky_windows
/tmp/uke_state
~/.config/uke/runtime_stuff

# Good: Centralized
~/.local/state/uke/sticky_windows
```

### ❌ Silent failures

```bash
# Bad
hyprctl dispatch pin 2>/dev/null

# Good
if ! hyprctl dispatch pin; then
    fail "Could not pin window"
    exit 1
fi
```

### ❌ Missing help

```bash
# Bad: No documentation
case "$1" in
    toggle) ... ;;
esac

# Good: Always include help
case "$1" in
    -h|--help) show_help ;;
    toggle) ... ;;
esac
```

---

## Summary

UKE's power comes from its abstractions:

| Layer | Purpose |
|-------|---------|
| `registry.yaml` | Single source of truth |
| `gen.sh` | Platform-specific config generation |
| `lib/core.sh` | Shared utilities and detection |
| `uke-*` commands | Cross-platform wrappers |
| Ghost files | Machine-specific overrides |

When in doubt, follow the pattern of existing features. Read the code of `uke-sticky`, `uke-services`, or `uke-backup` to see these principles in action.

The goal is: **Change one thing in one place, have it work everywhere.**
