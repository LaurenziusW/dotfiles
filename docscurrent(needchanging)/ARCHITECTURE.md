# UKE Architecture

## Design Principles

1. **Single Source of Truth**: registry.yaml drives all platform configs
2. **Generate, Don't Modify**: Never edit generated configs directly
3. **Platform Abstraction**: Write once, run on macOS and Linux
4. **Fail Fast**: Validate early, error clearly
5. **Observable**: Logging, debugging, health checks built-in

## Data Flow

```
registry.yaml
    ↓
lib/gen.sh (reads registry)
    ↓
gen/{skhd,yabai,hyprland}/ (generates)
    ↓
WM symlinks (install.sh creates)
    ↓
Window Manager (reads at runtime)
```

## Component Responsibilities

### config/registry.yaml
- Modifier definitions (primary, tertiary, bunch, resize)
- Application bundle IDs / class names
- Workspace definitions and app assignments
- Keybinding specifications
- Bunch definitions

### lib/core.sh
- Platform detection (is_macos)
- Path constants (UKE_ROOT, UKE_CONFIG, UKE_GEN)
- Logging functions (log_info, log_error, ok, fail)
- Utility functions (require_cmd, require_file)

### lib/gen.sh
- YAML parsing with yq
- Platform-specific config generation
- Modifier resolution for target platform
- Workspace rule generation
- Keybinding translation

### lib/wm.sh
- Window manager abstraction
- Platform-agnostic operations (reload, focus, workspace)
- Runtime WM interaction
- Status queries

### bin/uke
- Primary CLI entry point
- Command routing (gen, reload, status, edit, validate)
- High-level orchestration

### bin/uke-bunch
- Bunch execution
- App launching per platform
- Workspace focusing

### bin/uke-gather
- Window organization
- Workspace-based gathering

### bin/uke-doctor
- Health checks
- Dependency verification
- Link validation

### bin/uke-backup
- Manual backup/restore
- Manifest generation

### bin/uke-debug
- System diagnostics
- Keybinding tracing

## Modifier Hierarchy

Purpose: Prevent conflicts between WM and terminal/tmux

| Level | macOS | Linux | Usage |
|-------|-------|-------|-------|
| Primary | Cmd | Alt | Window focus, workspace switch |
| Primary+Shift | Cmd+Shift | Alt+Shift | Window move, workspace move |
| Tertiary | Cmd+Alt | Super | Launchers, utilities |
| Bunch | Cmd+Ctrl | Super+Ctrl | Bunch triggers |
| Resize | Alt+Shift | Alt+Shift | Window resize |

Terminal apps use:
- Alt (macOS/Linux): tab/pane navigation
- Ctrl: tmux prefix, shell controls

## Extension Points

- Add new commands: `bin/uke` case statement
- Add new generators: `lib/gen.sh` functions
- Add new platforms: `lib/wm.sh` abstractions
- Add new bunches: `config/registry.yaml` bunches section
