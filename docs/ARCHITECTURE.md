# Architecture: Technical Deep-Dive

This document explains the technical implementation of the Unified Keyboard Environment, including file structure, dependency management, cross-platform abstractions, and how all the pieces fit together.

---

## 📐 System Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    USER INTERACTION                         │
│            (Keyboard shortcuts via skhd/Hyprland)           │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                  WINDOW MANAGER LAYER                       │
│         macOS: Yabai              Linux: Hyprland           │
│     • BSP tiling layout         • Dynamic tiling            │
│     • Workspace management      • Workspace management      │
│     • Window manipulation       • Window manipulation       │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│               APPLICATION LAYER                             │
│    WezTerm • Neovim • Obsidian • Browsers • etc.           │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              ORCHESTRATION LAYER                            │
│      • Bunches (environment scripts)                        │
│      • lib-os-detect (platform abstraction)                 │
│      • gather-current-space (cleanup utility)               │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              CONFIGURATION LAYER                            │
│      ~/dotfiles/ (Git repository, managed by Stow)          │
└─────────────────────────────────────────────────────────────┘
```

---

## 🗂️ Directory Structure Deep-Dive

### Repository Layout

```
~/dotfiles/
├── .git/                          # Version control
├── .gitignore                     # Ignore patterns
├── README.md                      # Main documentation
├── PHILOSOPHY.md                  # Design principles
├── CHEAT-SHEET.md                 # Keybinding reference
├── ARCHITECTURE.md                # This file
│
├── hyprland/                      # Linux compositor config
│   └── .config/
│       └── hypr/
│           └── hyprland.conf      # Main Hyprland config
│
├── yabai/                         # macOS window manager
│   └── .config/
│       └── yabai/
│           └── yabairc            # Main Yabai config
│
├── skhd/                          # macOS hotkey daemon
│   └── .config/
│       └── skhd/
│           └── skhdrc             # Keyboard shortcuts
│
├── keyd/                          # Linux key remapping
│   └── default.conf               # Caps Lock layer config
│
├── karabiner/                     # macOS key remapping
│   └── .config/
│       └── karabiner/
│           └── karabiner.json     # Caps Lock layer config
│
├── wezterm/                       # Terminal emulator
│   └── .wezterm.lua               # Cross-platform config
│
├── nvim/                          # Neovim editor
│   └── .config/
│       └── nvim/
│           ├── init.lua           # Main config
│           ├── lazy-lock.json     # Plugin versions
│           └── lua/
│               ├── custom/        # User customizations
│               └── kickstart/     # Base config
│
├── tmux/                          # Terminal multiplexer
│   └── .tmux.conf                 # Tmux config
│
├── zsh/                           # Shell configuration
│   └── .zshrc                     # Cross-platform zsh config
│
├── local-bin/                     # Custom utilities
│   └── .local/
│       └── bin/
│           ├── gather-current-space   # Workspace cleanup
│           ├── bunch-manager          # Bunch orchestration
│           └── lib-os-detect          # Platform detection
│
├── workflow/                      # Environment orchestration
│   └── bunches/
│       ├── study-math.sh          # Example bunch
│       ├── coding-project.sh      # Example bunch
│       ├── templates/
│       │   └── bunch-template.sh  # Template for new bunches
│       └── oldBunchSHfiles/       # Archive of old bunches
│
└── scripts/                       # Management scripts
    ├── install.sh                 # Main installer
    ├── detect_install.sh          # Pre-flight checker
    └── maintenance/
        ├── collect-for-ai.sh      # Create context tarball
        ├── fulldump.sh            # System state report
        ├── verify-repo.sh         # Integrity checker
        └── update-management-tools.sh  # Meta-updater
```

---

## 🔌 Component Architecture

### 1. Window Manager Layer

#### macOS: Yabai + skhd

**Yabai** (`~/dotfiles/yabai/.config/yabai/yabairc`):
- **Binary Space Partitioning (BSP)** layout algorithm
- **Scripting Addition** (SA) for enhanced control
- **Rule-based workspace assignments** per application

**skhd** (`~/dotfiles/skhd/.config/skhd/skhdrc`):
- **Keyboard event capture** at system level
- **Command execution** (shell scripts, Yabai commands)
- **Modifier-aware** routing

**Communication Flow**:
```
User presses Cmd+H
  → skhd intercepts event
  → Executes: yabai -m window --focus west
  → Yabai queries window tree
  → Yabai sends focus command to macOS accessibility API
  → Window receives focus
```

**Key Files**:
- `/opt/homebrew/bin/yabai` - Binary
- `/tmp/yabai_*.err.log` - Runtime logs
- `/tmp/skhd_*.err.log` - Hotkey logs

#### Linux: Hyprland

**Hyprland** (`~/dotfiles/hyprland/.config/hypr/hyprland.conf`):
- **Wayland compositor** (replaces X11)
- **Dynamic tiling** with manual adjustments
- **Built-in IPC** via `hyprctl`

**Communication Flow**:
```
User presses Alt+H
  → Hyprland receives event (it's the compositor)
  → Checks keybind table
  → Executes: movefocus l (left)
  → Updates window tree
  → Renders new layout
```

**Key Files**:
- `/usr/bin/Hyprland` - Binary
- `~/.hyprland.log` - Runtime logs
- `/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket.sock` - IPC socket

### 2. Key Remapping Layer

#### macOS: Karabiner-Elements

**Purpose**: Remap Caps Lock to Escape (tap) or Ctrl (hold) + arrow layer.

**Config**: `~/dotfiles/karabiner/.config/karabiner/karabiner.json`

**Implementation**:
```json
{
  "from": { "key_code": "caps_lock" },
  "to": [
    { "key_code": "escape" }  // Tap behavior
  ],
  "to_if_held_down": [
    { "key_code": "left_control" }  // Hold behavior
  ]
}
```

**Note**: Currently NOT included in the repository (Karabiner uses GUI config). Manual setup required.

#### Linux: keyd

**Purpose**: System-wide key remapping (replaces Caps Lock functionality).

**Config**: `~/dotfiles/keyd/default.conf`

**Implementation**:
```ini
[main]
capslock = overload(caps_layer, esc)

[caps_layer:C]
h = left    # CapsLock+H → Left Arrow
j = down
k = up
l = right
```

**Service**:
```bash
sudo systemctl enable keyd
sudo systemctl start keyd
```

### 3. Terminal Layer

#### WezTerm

**Config**: `~/dotfiles/wezterm/.wezterm.lua`

**Platform Detection**:
```lua
local function is_darwin()
    return wezterm.target_triple:find("darwin") ~= nil
end

local secondary_mod = (is_darwin()) and "ALT" or "SUPER"
```

**Key Bindings**:
- Uses Alt (macOS) or Super (Linux) to avoid Cmd/Ctrl conflicts
- Example: `Alt+H` focuses pane left, `Alt+Shift+H` resizes left

**Design Choice**: WezTerm handles its own pane management instead of relying on Tmux. This gives users two options:
1. **WezTerm tabs/panes** for simple workflows
2. **Tmux sessions** for persistent, detachable workflows

#### Tmux

**Config**: `~/dotfiles/tmux/.tmux.conf`

**Prefix Key**: `Ctrl+A` (instead of default `Ctrl+B`)

**Rationale**: 
- `Ctrl+B` conflicts with backward navigation in shells
- `Ctrl+A` is ergonomic (pinky + ring finger)
- Consistent with GNU Screen users

**Key Bindings**:
```
Ctrl+A \  → Split horizontal (vertical divider)
Ctrl+A -  → Split vertical (horizontal divider)  
Ctrl+A hjkl → Navigate panes (vim-style)
```

### 4. Editor Layer

#### Neovim

**Config**: `~/dotfiles/nvim/.config/nvim/init.lua`

**Base**: [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)

**Plugin Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim)

**Key Plugins**:
- `nvim-lspconfig` - Language Server Protocol integration
- `telescope.nvim` - Fuzzy finder
- `nvim-treesitter` - Syntax highlighting
- `blink.cmp` - Autocompletion

**Leader Key**: `Space`

**Design Choice**: Kickstart provides a minimal, well-documented base. Users are encouraged to customize.

### 5. Shell Layer

#### Zsh

**Config**: `~/dotfiles/zsh/.zshrc`

**Platform Detection**:
```bash
case "$(uname -s)" in
    Darwin*)    OS="macos" ;;
    Linux*)     OS="linux" ;;
    *)          OS="unknown" ;;
esac
```

**Conditional Loading**:
- macOS: Homebrew integration, Yabai aliases
- Linux: Pacman/AUR helpers, Hyprland aliases

**Key Features**:
- **History Management**: Shared across sessions
- **Completion System**: Case-insensitive, menu-select
- **FZF Integration**: Fuzzy finding for files/history
- **Zoxide**: Smart directory jumping

---

## 🔄 Cross-Platform Abstraction

### The lib-os-detect Pattern

**File**: `~/dotfiles/local-bin/.local/bin/lib-os-detect`

**Purpose**: Single source of truth for OS detection and platform-specific commands.

**API**:
```bash
detect_os()            # Returns "macos" or "linux"
setup_os_commands()    # Exports platform-specific vars
launch_app("app")      # Launches app on current platform
```

**Usage in Bunches**:
```bash
#!/usr/bin/env bash
source "$(dirname "$0")/lib-os-detect"
setup_os_commands

# Now you can use:
$WM_FOCUS_SPACE 3        # Works on both platforms
launch_app "browser"     # Opens default browser
```

**Implementation**:
```bash
setup_os_commands() {
    OS=$(detect_os)
    
    if [[ "$OS" == "macos" ]]; then
        export WM_FOCUS_SPACE="yabai -m space --focus"
    elif [[ "$OS" == "linux" ]]; then
        export WM_FOCUS_SPACE="hyprctl dispatch workspace"
    fi
}
```

**Why This Works**:
- Bunches call `setup_os_commands()` once
- All subsequent commands use abstracted variables
- Same bunch script works on both platforms

---

## 🎯 Workspace Assignment System

### Rule Hierarchy

**macOS (Yabai)**:
```bash
# Specific rules first
yabai -m rule --add app="^Safari$" space=^1
yabai -m rule --add app="^Obsidian$" space=^2

# Catch-all rule last (uses regex negation)
yabai -m rule --add app!="^(Safari|Obsidian|WezTerm|...)$" space=^6
```

**Linux (Hyprland)**:
```
# Specific rules
windowrulev2 = workspace 1, class:^(firefox)$
windowrulev2 = workspace 2, class:^(obsidian)$

# No built-in catch-all, use gather-current-space instead
```

### gather-current-space Utility

**File**: `~/dotfiles/local-bin/.local/bin/gather-current-space`

**Purpose**: Manual workspace cleanup. Moves windows to their designated spaces.

**Algorithm**:
```bash
1. Detect current workspace
2. Query all windows in that workspace
3. For each window:
   a. Check app name against assignment rules
   b. If rule exists, move window to target space
   c. If no rule exists (catch-all), leave in Space 6
```

**Keybinding**: `Cmd/Alt + \`` (backtick)

**Why Manual Instead of Automatic?**:
- Some users want temporary windows in current space
- Automatic rules can be surprising/disruptive
- Manual trigger gives user control

---

## 🚀 Environment Bunches System

### Anatomy of a Bunch

**Example**: `~/dotfiles/workflow/bunches/study-math.sh`

```bash
#!/usr/bin/env bash

# 1. Load OS abstraction
source "$(dirname "$0")/lib-os-detect"
setup_os_commands

# 2. Announce startup
echo "📚 Starting: Study Math"

# 3. Configure workspace and launch apps
$WM_FOCUS_SPACE 2          # Go to Notes workspace
launch_app "notes"          # Open Obsidian
sleep 1                     # Wait for app to start

$WM_FOCUS_SPACE 1          # Go to Browser workspace
launch_app "browser"        # Open default browser
sleep 1

$WM_FOCUS_SPACE 3          # Go to Code/Terminal workspace  
launch_app "terminal"       # Open WezTerm
sleep 1

$WM_FOCUS_SPACE 5          # Go to Documents workspace
launch_app "pdf"            # Open PDF reader

# 4. Return to primary workspace
$WM_FOCUS_SPACE 2          # Back to Notes for studying

echo "✅ Math study environment ready!"
```

### Bunch Manager

**File**: `~/dotfiles/local-bin/.local/bin/bunch-manager`

**Commands**:
```bash
bunch-manager list          # Lists available bunches
bunch-manager run <name>    # Executes a bunch
bunch-manager create <name> # Creates from template
bunch-manager edit <name>   # Opens bunch in $EDITOR
```

**Template System**:
- New bunches copy from `templates/bunch-template.sh`
- Placeholders (`[BUNCH_NAME]`, `[DESCRIPTION]`) are replaced
- Template includes OS detection boilerplate

### Keybinding Integration (macOS)

**skhd config**:
```bash
cmd + ctrl - 1 : ~/dotfiles/workflow/bunches/study-math.sh
cmd + ctrl - 2 : ~/dotfiles/workflow/bunches/guitar-practice.sh
cmd + ctrl - 3 : ~/dotfiles/workflow/bunches/coding-project.sh
```

**Why `Cmd + Ctrl`?**:
- Tertiary layer (system orchestration)
- Rarely used by other apps
- Easy to remember (numbers match workspaces)

---

## 📦 Installation & Deployment

### GNU Stow Architecture

**How Stow Works**:
```
~/dotfiles/nvim/.config/nvim/init.lua
           │
           └─ Stowed to → ~/.config/nvim/init.lua (symlink)
```

**Stow Command**:
```bash
cd ~/dotfiles
stow nvim  # Creates symlink: ~/.config/nvim → ~/dotfiles/nvim/.config/nvim
```

**Directory Structure Requirement**:
```
package/
└── .config/        # Must mirror home directory structure
    └── nvim/
        └── init.lua
```

### install.sh Architecture

**File**: `~/dotfiles/scripts/install.sh`

**Flow**:
```
1. Detect OS (macOS vs Linux)
2. Define package list per platform
   macOS:  local-bin workflow nvim wezterm zsh tmux yabai skhd
   Linux:  local-bin workflow nvim wezterm zsh tmux hyprland
3. For each package:
   a. Run stow -n (dry-run) to detect conflicts
   b. If conflicts exist:
      - Create backup directory (~/dotfiles-backup-TIMESTAMP)
      - Move conflicting files to backup
   c. Run stow -R (re-stow) to create/refresh symlinks
```

**Drift Protection**:
```bash
# If you edit ~/.zshrc instead of ~/dotfiles/zsh/.zshrc:
./scripts/install.sh

# Output:
#   ⚠️  Local drift detected!
#   🔥 Moved local '.zshrc' to backup
#   🔗 Linking zsh...
```

### detect_install.sh Pre-Flight

**File**: `~/dotfiles/scripts/detect_install.sh`

**Purpose**: Check for conflicts BEFORE running install.

**Output**:
```
COMPONENT            | STATUS          | LOCATION
─────────────────────────────────────────────────────────
Zsh Configuration    | ⚪ Clean        | ~/.zshrc
Neovim Config        | ✅ Linked       | ~/.config/nvim
Yabai Config         | ❌ Directory    | ~/.config/yabai
```

**Statuses**:
- `⚪ Clean`: Path doesn't exist (ready for install)
- `✅ Linked`: Already symlinked to ~/dotfiles (correct state)
- `⚠️  Foreign Link`: Symlink pointing elsewhere (needs fixing)
- `❌ Directory/File`: Physical file exists (will be backed up)

**Interactive Wipe**:
```bash
./scripts/detect_install.sh
# Detects conflicts
# Offers to backup and remove conflicts
# Creates timestamped backup directory
```

---

## 🛡️ Error Handling & Recovery

### Logging Strategy

**Yabai (macOS)**:
- **Location**: `/tmp/yabai_*.err.log`
- **View**: `tail -f /tmp/yabai_*.err.log`
- **Common Errors**:
  - "Scripting Addition not loaded" → Run `sudo yabai --load-sa`
  - "Operation not permitted" → SIP partially disabled required

**skhd (macOS)**:
- **Location**: `/tmp/skhd_*.err.log`
- **View**: `tail -f /tmp/skhd_*.err.log`
- **Common Errors**:
  - "No such file or directory" → Path in skhdrc is wrong
  - "Permission denied" → Script needs +x permission

**Hyprland (Linux)**:
- **Location**: `~/.hyprland.log`
- **View**: `cat ~/.hyprland.log`
- **Common Errors**:
  - "Could not load module" → Missing Wayland dependency
  - "Socket connection failed" → Compositor not running

### State Verification

**fulldump.sh**:
```bash
~/dotfiles/scripts/maintenance/fulldump.sh
```

**Generates**: `~/full-system-dump.txt`

**Contents**:
1. **Link Verification**: Checks if symlinks point to ~/dotfiles
2. **Executable Check**: Verifies custom scripts are in PATH
3. **Content Dump**: Copies all config files into single file

**Use Cases**:
- Pre-flight check before major changes
- Debugging unexpected behavior
- Sharing config with AI assistant for troubleshooting

### Recovery Procedures

**If Window Manager Stops Working**:
```bash
# macOS
yabai --restart-service
skhd --restart-service

# Linux
hyprctl reload
# Or Ctrl+Alt+F2 → login → pkill Hyprland → Hyprland
```

**If Symlinks Break**:
```bash
cd ~/dotfiles
stow -D <package>   # Unlink
stow <package>      # Re-link
```

**If Config Corruption**:
```bash
cd ~/dotfiles
git status                    # Check for local changes
git diff                      # Review changes
git checkout HEAD -- <file>   # Restore from Git
stow -R <package>             # Re-link
```

**If Complete System Reset Needed**:
```bash
cd ~/dotfiles
stow -D nvim wezterm zsh tmux yabai skhd  # Unlink everything
./scripts/install.sh                       # Fresh install
```

---

## 🔐 Security Considerations

### Scripting Addition (macOS)

**What It Is**: Yabai injects code into macOS's Dock process to gain enhanced window management capabilities.

**Security Implications**:
- Requires SIP (System Integrity Protection) to be partially disabled
- Runs with elevated privileges (sudo yabai --load-sa)
- Theoretically allows arbitrary code execution in Dock

**Mitigation**:
- Yabai is open-source, auditable
- Large community, actively maintained
- Only install from official sources (GitHub releases)
- Review `yabairc` before running

**Alternative**: Don't use SA (lose some features like window focus following mouse).

### Sudo in Bunches

**Avoid**: Never put `sudo` commands in bunch scripts.

**Why**:
- Bunches run on keypress (no password prompt possible)
- Passwordless sudo is a security risk
- Bunches should orchestrate, not administrate

**If You Need Elevated Tasks**: Use a separate script, run manually.

### Git Credentials in Dotfiles

**Rule**: NEVER commit secrets to the repository.

**Excluded**:
- `~/.ssh/` (not in dotfiles)
- `~/.gnupg/` (not in dotfiles)
- `.env` files (add to `.gitignore`)

**For API Keys**: Use environment variables or OS keychain.

---

## 🚧 Known Limitations

### Platform-Specific

**macOS:**
- Yabai SA requires SIP partial disable
- Some apps (Safari, macOS settings) can't be tiled
- Notch on MacBooks can interfere with window placement

**Linux:**
- Wayland adoption still incomplete (some apps require Xwayland)
- keyd requires root (runs as systemd service)
- Electron apps may have focus issues in Wayland

### General

**Window Assignment Rules**:
- Apps can only be assigned to one workspace
- Multi-window apps (browsers with multiple windows) all go to same workspace
- No "always on top" windows in BSP mode

**Bunch Timing**:
- Apps launch asynchronously (need `sleep` delays)
- Fast machines need shorter sleeps, slow machines need longer
- No reliable way to detect "app finished launching"

**Keybinding Conflicts**:
- System shortcuts (macOS Spotlight, Mission Control) can conflict
- Some apps override Alt/Cmd shortcuts (disable in app preferences)

---

## 🔮 Future Extensibility

### Adding a New Platform

**Example**: Supporting BSD

1. Update `lib-os-detect`:
```bash
detect_os() {
    case "$(uname -s)" in
        Darwin*)  echo "macos" ;;
        Linux*)   echo "linux" ;;
        *BSD)     echo "bsd" ;;  # New
    esac
}
```

2. Create BSD-specific config package:
```
~/dotfiles/bsd-wm/
└── .config/
    └── bsd-wm/
        └── config
```

3. Update `install.sh`:
```bash
elif [[ "$OSTYPE" == *"bsd"* ]]; then
    OS="bsd"
    PACKAGES="local-bin workflow nvim wezterm zsh tmux bsd-wm"
```

### Adding Custom Tools

**Example**: Adding a rofi launcher (Linux)

1. Create package:
```bash
mkdir -p ~/dotfiles/rofi/.config/rofi
```

2. Add config:
```bash
cat > ~/dotfiles/rofi/.config/rofi/config.rasi << EOF
configuration {
    modi: "drun,run";
    font: "JetBrainsMono Nerd Font 12";
}
EOF
```

3. Stow:
```bash
cd ~/dotfiles
stow rofi
```

4. Bind in Hyprland:
```
bind = SUPER, SPACE, exec, rofi -show drun
```

### Plugin System (Not Implemented)

**Concept**: Allow users to add "plugin" directories that augment core functionality.

**Structure**:
```
~/dotfiles/plugins/
├── my-custom-bunch/
│   └── bunches/
│       └── deep-work.sh
└── my-utility/
    └── .local/bin/
        └── my-script
```

**Implementation**: `install.sh` could scan `plugins/` and stow each subdirectory.

---

## 📚 Dependency Graph

```
┌────────────────────────────────────────────────┐
│ USER                                           │
└───────────────────┬────────────────────────────┘
                    │
    ┌───────────────┼───────────────┐
    │               │               │
    ▼               ▼               ▼
┌─────────┐   ┌─────────┐   ┌─────────┐
│ skhd/   │   │ Hyprland│   │ keyd    │
│ skhdrc  │   │ .conf   │   │ .conf   │
└────┬────┘   └────┬────┘   └─────────┘
     │             │
     ▼             ▼
┌─────────────────────────────┐
│ Yabai / Hyprland            │
│ (Window Manager)            │
└──────────────┬──────────────┘
               │
    ┌──────────┼──────────┐
    │          │          │
    ▼          ▼          ▼
┌─────┐  ┌─────────┐  ┌─────┐
│Apps │  │ WezTerm │  │Nvim │
└─────┘  └────┬────┘  └─────┘
              │
              ▼
        ┌─────────┐
        │  Tmux   │
        └────┬────┘
             │
             ▼
        ┌─────────┐
        │   Zsh   │
        └─────────┘
```

**Runtime Dependencies**:
- Yabai requires: macOS Accessibility API
- Hyprland requires: Wayland compositor stack
- keyd requires: systemd, root privileges
- Bunches require: bash, lib-os-detect, window manager

---

## 🧪 Testing Strategy

### Unit Testing (Scripts)

**Example**: Testing `lib-os-detect`

```bash
#!/usr/bin/env bash
source ~/dotfiles/local-bin/.local/bin/lib-os-detect

# Test OS detection
result=$(detect_os)
if [[ "$result" == "macos" ]] || [[ "$result" == "linux" ]]; then
    echo "✅ OS detection works"
else
    echo "❌ OS detection failed: $result"
fi
```

### Integration Testing (Bunches)

**Manual Test Checklist**:
1. Run bunch script
2. Verify all apps launched
3. Check workspace assignments
4. Confirm focus returns to primary workspace

**Automated** (not implemented, but possible):
```bash
# Pseudo-code
bunch-manager run study-math
sleep 5
if hyprctl clients | grep -q "obsidian"; then
    echo "✅ Obsidian launched"
fi
```

### Regression Testing (Configs)

**Before Major Changes**:
```bash
./scripts/maintenance/fulldump.sh
mv ~/full-system-dump.txt ~/system-state-before.txt

# Make changes

./scripts/maintenance/fulldump.sh
diff ~/system-state-before.txt ~/full-system-dump.txt
```

---

## 📊 Performance Considerations

### Startup Time

**Bunch Launch Time**:
```
User presses Cmd+Ctrl+1
→ 0ms: skhd receives event
→ 1ms: Launches study-math.sh
→ 50ms: Obsidian starts
→ 1000ms: Obsidian window appears
→ 1050ms: Browser starts
→ 2000ms: Browser window appears
→ Total: ~2 seconds (perceived)
```

**Optimization**:
- Launch apps in parallel (background with &)
- Remove unnecessary `sleep` calls
- Pre-start commonly used apps at login

### Window Manager Overhead

**Yabai**: ~5MB RAM, <1% CPU (idle)
**Hyprland**: ~50MB RAM, 1-2% CPU (idle, includes compositor)

**Benchmark** (Window Focus Latency):
- Yabai: ~10ms (accessibility API overhead)
- Hyprland: ~5ms (direct compositor control)

### Configuration Load Time

**On Login** (macOS):
```
0ms: Login
100ms: Yabai loads
150ms: skhd loads
200ms: Accessibility permissions check
250ms: Window rules applied
500ms: All startup apps assigned to spaces
```

**On Config Reload**:
```
yabai --restart-service  # ~500ms
skhd --restart-service   # ~100ms
hyprctl reload           # ~50ms
```

---

## 🎓 Advanced Topics

### Custom Window Layouts

**Yabai BSP Manipulation**:
```bash
# Rotate tree 90 degrees
yabai -m space --rotate 90

# Mirror horizontally
yabai -m space --mirror x-axis

# Balance all windows to equal size
yabai -m space --balance
```

**Hyprland Split Ratios**:
```
# In hyprland.conf
windowrulev2 = size 70% 100%, class:^(wezterm)$
windowrulev2 = size 30% 100%, class:^(spotify)$
```

### Multi-Monitor Support

**Yabai**:
```bash
# Assign spaces to displays
yabai -m space 1 --display 1  # Primary display
yabai -m space 2 --display 2  # Secondary display
```

**Hyprland**:
```
# In hyprland.conf
monitor=DP-1,2560x1440@144,0x0,1
monitor=HDMI-A-1,1920x1080@60,2560x0,1
```

### Scripting Window Queries

**Yabai**:
```bash
# Get focused window ID
yabai -m query --windows --window | jq '.id'

# Get all windows on current space
yabai -m query --windows --space | jq '.[] | .app'
```

**Hyprland**:
```bash
# Get focused window
hyprctl activewindow -j | jq '.class'

# Get all windows
hyprctl clients -j | jq '.[] | .class'
```

---

## 🐛 Debugging Guide

### Problem: Keybinding Not Working

**Checklist**:
1. Check config syntax (especially quotes and escapes)
2. Verify daemon is running (ps aux | grep skhd/Hyprland)
3. Check logs (/tmp/skhd_*.err.log or ~/.hyprland.log)
4. Test command manually in terminal
5. Check for conflicting shortcuts (System Preferences on macOS)

**Example Debug**:
```bash
# macOS
skhd -V  # Verbose mode, run in terminal
# Press the problematic key, see if skhd detects it

# Linux
hyprctl dispatch exec kitty  # Test command directly
```

### Problem: Symlink Not Created

**Diagnosis**:
```bash
cd ~/dotfiles
stow -n -v nvim  # Dry-run with verbose output
```

**Common Causes**:
- File already exists at target location → Remove or backup
- Directory structure mismatch → Check package layout
- Stow not installed → brew install stow / sudo pacman -S stow

### Problem: App Not Launching in Bunch

**Debug**:
```bash
# Add debugging to bunch script
launch_app "browser"
echo "DEBUG: Launched browser"
sleep 2
echo "DEBUG: Wait complete"
```

**Common Causes**:
- App name mismatch (case-sensitive on Linux)
- App not installed
- Insufficient wait time (sleep too short)

---

## 📖 Further Reading

**Window Manager Design**:
- [dwm philosophy](https://dwm.suckless.org/tutorial/)
- [i3 user guide](https://i3wm.org/docs/userguide.html)

**Dotfiles Management**:
- [GNU Stow manual](https://www.gnu.org/software/stow/manual/stow.html)
- [Dotfiles best practices](https://dotfiles.github.io/)

**Shell Scripting**:
- [Bash Guide for Beginners](https://tldp.org/LDP/Bash-Beginners-Guide/html/)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)

---

**Last Updated**: 2024-11-27  
**Maintainer**: @LaurenziusW  
**Version**: 2.0 (Unified Architecture)
