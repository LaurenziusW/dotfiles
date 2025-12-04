# UKE v8 Philosophy

**Hand-crafted configs. No generators. No magic.**

## Core Principles

### 1. Direct Configuration

Unlike previous UKE versions that used generators, v8 is **hand-crafted**. You edit the actual config files directly. This means:

- No `uke gen` command to remember
- No registry.yaml → generated config translation
- What you see is what you get
- Easier to debug and understand

**Trade-off**: You manage two config files (skhd + Hyprland) instead of one registry.yaml. But you gain simplicity and robustness.

### 2. Modifier Abstraction (Cross-Platform)

The key insight: **same logical action, different physical keys**.

| Layer | macOS | Linux | Purpose |
|:------|:------|:------|:--------|
| **PRIMARY** | Cmd ⌘ | Alt | Window manager (focus, workspaces) |
| **PRIMARY+SHIFT** | Cmd+Shift | Alt+Shift | Move/manipulate windows |
| **SECONDARY** | Alt ⌥ | Super | App-internal (WezTerm panes) |
| **TERTIARY** | Alt+Shift | Super+Shift | Resize (context-aware) |
| **QUATERNARY** | Ctrl | Ctrl | Shell (NEVER intercepted) |
| **TMUX** | Ctrl+A | Ctrl+A | Terminal multiplexer |

**Why this works:**
- PRIMARY is intercepted by the WM before apps see it
- SECONDARY is passed through to apps (WezTerm handles it)
- QUATERNARY is sacred for shell operations (Ctrl+C, Ctrl+Z)

### 3. GNU Stow for Dotfiles

```
uke-v8/
├── mac/      → stow -t ~ .  (macOS configs)
├── arch/     → stow -t ~ .  (Linux configs)  
├── shared/   → stow -t ~ .  (cross-platform)
```

Benefits:
- No copy commands to remember
- Symlinks point to the repo
- Edit in place, changes apply immediately
- `git diff` shows exactly what changed

### 4. Local Overrides (Ghost Files)

Hardware-specific settings stay out of git:

```lua
-- ~/.config/wezterm/local.lua
return {
    font_size = 16,  -- HiDPI adjustment
}
```

Each config sources its local override:
- WezTerm: `require('local')` with pcall
- Hyprland: `source = ~/.config/hypr/local.conf`
- Zsh: `source ~/.zshrc.local`
- Yabai: `~/.config/yabai/local_rules`

### 5. Graceful Degradation

Every script checks prerequisites:

```bash
# Good: Check environment
if [[ -z "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    echo "Hyprland not running"
    exit 0
fi

# Good: Detect OS at runtime
case "$(uname -s)" in
    Darwin) yabai_implementation ;;
    Linux)  hyprland_implementation ;;
esac
```

### 6. State Management

Runtime state goes to XDG directories:

```
~/.local/state/uke/
├── sticky_windows    # Tracked sticky window IDs
└── uke.log          # Debug logs
```

**Why XDG?**
- `~/.config/` = user-editable configuration
- `~/.local/state/` = runtime state (can be regenerated)
- `~/.local/share/` = persistent user data

---

## Mental Model

```
┌─────────────────────────────────────────────────────────────────────┐
│  LAYER          │ MODIFIER        │ SCOPE                          │
├─────────────────┼─────────────────┼────────────────────────────────┤
│  PRIMARY        │ Cmd / Alt       │ Operating System Level         │
│                 │                 │ (Window Manager, Workspaces)   │
├─────────────────┼─────────────────┼────────────────────────────────┤
│  SECONDARY      │ Alt / Super     │ Application Level              │
│                 │                 │ (Terminal UI, Pane Navigation) │
├─────────────────┼─────────────────┼────────────────────────────────┤
│  TERTIARY       │ Alt+Shift       │ Dimensional Changes            │
│                 │ Super+Shift     │ (Resizing - context aware)     │
├─────────────────┼─────────────────┼────────────────────────────────┤
│  QUATERNARY     │ Ctrl            │ Shell Process Control          │
│                 │                 │ (Interrupt, Suspend, etc.)     │
├─────────────────┼─────────────────┼────────────────────────────────┤
│  TMUX           │ Ctrl+A          │ Session Multiplexing           │
│                 │                 │ (Terminal Sessions)            │
└─────────────────┴─────────────────┴────────────────────────────────┘
```

---

## Implementation Checklist

When adding a new feature:

### ☐ Is it cross-platform?
- Single script with OS detection
- Works on both macOS and Linux (or degrades gracefully)

### ☐ Does it follow UKE conventions?
- Script in `shared/.local/bin/` with `uke-` prefix
- Uses consistent output formatting
- Includes `--help` documentation
- Is executable (`chmod +x`)

### ☐ Is state properly managed?
- Runtime state → `~/.local/state/uke/`
- No state scattered around home directory

### ☐ Does it fail gracefully?
- Checks for required tools
- Provides helpful error messages
- Suggests fixes when things go wrong

---

## Avoid These Mistakes

### ❌ Scattering state files
```bash
# Bad
~/.sticky_windows
/tmp/uke_state

# Good
~/.local/state/uke/sticky_windows
```

### ❌ Silent failures
```bash
# Bad
hyprctl dispatch pin 2>/dev/null

# Good
if ! hyprctl dispatch pin; then
    echo "Could not pin window"
    exit 1
fi
```

### ❌ Hardcoding paths
```bash
# Bad
source ~/dotfiles/uke/lib/core.sh

# Good
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
```

---

## Summary

UKE v8 is intentionally simple:

| Aspect | v7 (generated) | v8 (hand-crafted) |
|:-------|:---------------|:------------------|
| Config source | registry.yaml | Direct config files |
| Workflow | Edit yaml → uke gen → reload | Edit config → reload |
| Complexity | Higher (generators, templates) | Lower (just configs) |
| Debugging | Harder (generated output) | Easier (direct files) |
| Flexibility | Registry-limited | Unlimited |

**The goal**: Same muscle memory everywhere, with configs you can understand and modify directly.
