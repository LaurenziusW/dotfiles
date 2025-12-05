import os
import stat
from pathlib import Path

# ==============================================================================
# UKE v8 Binary Definitions
# ==============================================================================
# These scripts are standalone, "no magic" versions compliant with the v8 Standard.
# They do not require a central library or registry.yaml.
# ==============================================================================

SCRIPTS = {}

# ------------------------------------------------------------------------------
# 1. UKE DOCTOR (v8 Standard)
# ------------------------------------------------------------------------------
SCRIPTS["uke-doctor"] = r"""#!/usr/bin/env bash
# ==============================================================================
# UKE v8 Doctor - Health Check
# ==============================================================================
set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🏥 UKE v8 Doctor${NC}"
echo "================="

check() {
    if command -v "$1" &>/dev/null; then
        echo -e "${GREEN}✅ $1 found${NC}"
    else
        echo -e "${RED}❌ $1 MISSING${NC}"
    fi
}

check_service() {
    if pgrep -x "$1" >/dev/null; then
        echo -e "${GREEN}✅ $1 running${NC}"
    else
        echo -e "${RED}❌ $1 STOPPED${NC}"
    fi
}

echo "Checking Core Tools..."
check "nvim"
check "tmux"
check "wezterm"
check "zsh"
check "stow"
check "jq"
check "fzf"
check "zoxide"

case "$(uname -s)" in
    Darwin)
        echo ""
        echo "Checking macOS Tools..."
        check "yabai"
        check "skhd"
        check_service "yabai"
        check_service "skhd"
        ;;
    Linux)
        echo ""
        echo "Checking Linux Tools..."
        check "hyprctl"
        check "waybar"
        check_service "Hyprland"
        ;;
esac

echo ""
echo "Done."
"""

# ------------------------------------------------------------------------------
# 2. UKE STICKY (v8 Standard)
# ------------------------------------------------------------------------------
SCRIPTS["uke-sticky"] = r"""#!/usr/bin/env bash
# ==============================================================================
# UKE Sticky - Toggle Floating/Pinned State
# ==============================================================================
# macOS: Float + Sticky + Topmost
# Linux: Float + Pin
# ==============================================================================

OS="$(uname -s)"

if [[ "$OS" == "Darwin" ]]; then
    # macOS (yabai)
    yabai -m window --toggle float
    yabai -m window --toggle sticky
    yabai -m window --toggle topmost
    echo "Toggled sticky window (macOS)"

elif [[ "$OS" == "Linux" ]]; then
    # Linux (Hyprland)
    hyprctl dispatch togglefloating
    hyprctl dispatch pin
    echo "Toggled sticky window (Linux)"
fi
"""

# ------------------------------------------------------------------------------
# 3. UKE SCRATCHPAD (v8 Standard)
# ------------------------------------------------------------------------------
SCRIPTS["uke-scratchpad"] = r"""#!/usr/bin/env bash
# ==============================================================================
# UKE Scratchpad - Toggle Dropdown Apps
# ==============================================================================
# Usage: uke-scratchpad [terminal|notes|music]
# ==============================================================================

APP="$1"
OS="$(uname -s)"

if [[ -z "$APP" ]]; then
    echo "Usage: uke-scratchpad <name>"
    exit 1
fi

if [[ "$OS" == "Darwin" ]]; then
    # macOS Implementation (Basic Focus/Launch)
    # Note: Full scratchpad behavior on macOS requires complex yabai rules
    # This is a 'best effort' launcher/focuser for v8 simplicity
    case "$APP" in
        terminal) TARGET="WezTerm" ;;
        notes)    TARGET="Obsidian" ;;
        music)    TARGET="Spotify" ;;
        *)        TARGET="$APP" ;;
    esac
    
    open -a "$TARGET"
    
elif [[ "$OS" == "Linux" ]]; then
    # Linux Implementation (Hyprland Special Workspaces)
    hyprctl dispatch togglespecialworkspace "$APP"
fi
"""

# ------------------------------------------------------------------------------
# 4. UKE GATHER (Ported to Human-Readable v8)
# ------------------------------------------------------------------------------
SCRIPTS["uke-gather"] = r"""#!/usr/bin/env bash
# ==============================================================================
# UKE Gather - Window Organization
# ==============================================================================
# Hand-crafted rules for organizing windows into workspaces.
# Edit this file to change your layout preferences.
# ==============================================================================
set -euo pipefail

# Helper for JSON parsing
require_jq() {
    if ! command -v jq &>/dev/null; then
        echo "Error: jq is required."
        exit 1
    fi
}

gather_macos() {
    require_jq
    echo "Gathering windows (macOS)..."
    
    # 1. Browser
    yabai -m query --windows | jq -r '.[] | select(.app | test("Safari|Brave|Firefox|Chrome")) | .id' | xargs -I {} yabai -m window {} --space 1 2>/dev/null || true
    
    # 2. Notes
    yabai -m query --windows | jq -r '.[] | select(.app | test("Obsidian|Notion")) | .id' | xargs -I {} yabai -m window {} --space 2 2>/dev/null || true
    
    # 3. Code
    yabai -m query --windows | jq -r '.[] | select(.app | test("WezTerm|Code|Xcode")) | .id' | xargs -I {} yabai -m window {} --space 3 2>/dev/null || true
    
    # 5. Documents
    yabai -m query --windows | jq -r '.[] | select(.app | test("Preview|PDF")) | .id' | xargs -I {} yabai -m window {} --space 5 2>/dev/null || true
    
    # 7. Media
    yabai -m query --windows | jq -r '.[] | select(.app | test("Spotify")) | .id' | xargs -I {} yabai -m window {} --space 7 2>/dev/null || true
    
    # 9. Comms
    yabai -m query --windows | jq -r '.[] | select(.app | test("Slack|Discord|Mail")) | .id' | xargs -I {} yabai -m window {} --space 9 2>/dev/null || true

    echo "Done."
}

gather_linux() {
    require_jq
    echo "Gathering windows (Linux)..."
    
    move() {
        local regex="$1"
        local ws="$2"
        hyprctl clients -j | jq -r ".[] | select(.class | test(\"$regex\"; \"i\")) | .address" | while read -r addr; do
            hyprctl dispatch movetoworkspacesilent "$ws,address:$addr" >/dev/null
        done
    }

    move "brave|firefox|chromium" 1
    move "obsidian|notion" 2
    move "wezterm|code|kitty" 3
    move "zathura|okular|evince" 5
    move "spotify" 7
    move "slack|discord|telegram|thunderbird" 9
    
    echo "Done."
}

case "$(uname -s)" in
    Darwin) gather_macos ;;
    Linux)  gather_linux ;;
esac
"""

# ------------------------------------------------------------------------------
# 5. UKE SESSION (Ported to Standalone)
# ------------------------------------------------------------------------------
SCRIPTS["uke-session"] = r"""#!/usr/bin/env bash
# ==============================================================================
# UKE Session - Save/Restore Window Layouts
# ==============================================================================
# Usage: uke-session [save|restore] <name>
# Data: ~/.local/state/uke/sessions/
# ==============================================================================
set -euo pipefail

SESSION_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/uke/sessions"
mkdir -p "$SESSION_DIR"

CMD="${1:-help}"
NAME="${2:-default}"

save_macos() {
    yabai -m query --windows | jq '[.[] | {app: .app, space: .space, frame: .frame}]' > "$SESSION_DIR/$1.json"
    echo "Saved macOS session: $1"
}

restore_macos() {
    local file="$SESSION_DIR/$1.json"
    if [[ ! -f "$file" ]]; then echo "Session '$1' not found."; exit 1; fi
    
    # Simple restore: move apps to spaces. Exact frame restoration is complex and often buggy.
    jq -c '.[]' "$file" | while read -r win; do
        local app=$(echo "$win" | jq -r '.app')
        local space=$(echo "$win" | jq -r '.space')
        
        # Find window ID by App name (first found)
        local id=$(yabai -m query --windows | jq -r ".[] | select(.app == \"$app\") | .id" | head -1)
        if [[ -n "$id" ]]; then
            yabai -m window "$id" --space "$space" 2>/dev/null || true
        fi
    done
    echo "Restored macOS session: $1"
}

save_linux() {
    hyprctl clients -j | jq '[.[] | {class: .class, workspace: .workspace.id}]' > "$SESSION_DIR/$1.json"
    echo "Saved Linux session: $1"
}

restore_linux() {
    local file="$SESSION_DIR/$1.json"
    if [[ ! -f "$file" ]]; then echo "Session '$1' not found."; exit 1; fi
    
    jq -c '.[]' "$file" | while read -r win; do
        local class=$(echo "$win" | jq -r '.class')
        local ws=$(echo "$win" | jq -r '.workspace')
        
        local addr=$(hyprctl clients -j | jq -r ".[] | select(.class == \"$class\") | .address" | head -1)
        if [[ -n "$addr" ]]; then
            hyprctl dispatch movetoworkspacesilent "$ws,address:$addr" >/dev/null
        fi
    done
    echo "Restored Linux session: $1"
}

case "$CMD" in
    save)
        [[ "$(uname -s)" == "Darwin" ]] && save_macos "$NAME" || save_linux "$NAME"
        ;;
    restore)
        [[ "$(uname -s)" == "Darwin" ]] && restore_macos "$NAME" || restore_linux "$NAME"
        ;;
    list)
        ls "$SESSION_DIR"/*.json 2>/dev/null | xargs -n 1 basename .json
        ;;
    *)
        echo "Usage: uke-session [save|restore|list] <name>"
        exit 1
        ;;
esac
"""

# ------------------------------------------------------------------------------
# 6. UKE LAUNCH (Ported to Standalone)
# ------------------------------------------------------------------------------
SCRIPTS["uke-launch"] = r"""#!/usr/bin/env bash
# ==============================================================================
# UKE Launch - Smart Launcher
# ==============================================================================
# Usage: uke-launch <alias|file|url>
# ==============================================================================

TARGET="$1"
OS="$(uname -s)"

if [[ -z "$TARGET" ]]; then
    echo "Usage: uke-launch <alias|file|url>"
    exit 1
fi

# 1. URL Handler
if [[ "$TARGET" =~ ^https?:// ]]; then
    if [[ "$OS" == "Darwin" ]]; then open "$TARGET"; else xdg-open "$TARGET"; fi
    exit 0
fi

# 2. File Handler
if [[ -f "$TARGET" ]]; then
    if [[ "$OS" == "Darwin" ]]; then open "$TARGET"; else xdg-open "$TARGET"; fi
    exit 0
fi

# 3. Alias Handler (v8 Defaults)
case "$TARGET" in
    browser)  CMD="Brave Browser" ; LINUX_CMD="brave" ;;
    terminal) CMD="WezTerm"       ; LINUX_CMD="wezterm" ;;
    editor)   CMD="nvim"          ; LINUX_CMD="nvim" ;;
    files)    CMD="Finder"        ; LINUX_CMD="thunar" ;;
    pdf)      CMD="Preview"       ; LINUX_CMD="zathura" ;;
    notes)    CMD="Obsidian"      ; LINUX_CMD="obsidian" ;;
    music)    CMD="Spotify"       ; LINUX_CMD="spotify" ;;
    *)        CMD="$TARGET"       ; LINUX_CMD="$TARGET" ;;
esac

if [[ "$OS" == "Darwin" ]]; then
    if [[ "$CMD" == "nvim" ]]; then
        wezterm start -- nvim
    else
        open -a "$CMD"
    fi
else
    if [[ "$LINUX_CMD" == "nvim" ]]; then
        wezterm start -- nvim
    else
        "$LINUX_CMD" >/dev/null 2>&1 &
        disown
    fi
fi
"""

# ------------------------------------------------------------------------------
# 7. UKE SNAPSHOT (Ported, Simplified)
# ------------------------------------------------------------------------------
SCRIPTS["uke-snapshot"] = r"""#!/usr/bin/env bash
# ==============================================================================
# UKE Snapshot - System Backup Wrapper
# ==============================================================================
# Wraps snapper/timeshift/btrfs based on availability.
# ==============================================================================
set -euo pipefail

detect_backend() {
    if command -v snapper &>/dev/null; then echo "snapper";
    elif command -v timeshift &>/dev/null; then echo "timeshift";
    else echo "none"; fi
}

BACKEND=$(detect_backend)
DESC="${2:-Manual Snapshot}"

create() {
    case "$BACKEND" in
        snapper)
            sudo snapper create -d "$DESC" -c timeline
            echo "Snapper snapshot created."
            ;;
        timeshift)
            sudo timeshift --create --comments "$DESC" --scripted
            echo "Timeshift snapshot created."
            ;;
        *)
            echo "No snapshot backend found (snapper/timeshift)."
            exit 1
            ;;
    esac
}

list() {
    case "$BACKEND" in
        snapper) sudo snapper list ;;
        timeshift) sudo timeshift --list ;;
        *) echo "No backend found." ;;
    esac
}

case "${1:-list}" in
    create) create ;;
    list)   list ;;
    *)      echo "Usage: uke-snapshot [create|list] [description]" ;;
esac
"""

# ------------------------------------------------------------------------------
# 8. UKE BUNCH (Ported to Standalone)
# ------------------------------------------------------------------------------
SCRIPTS["uke-bunch"] = r"""#!/usr/bin/env bash
# ==============================================================================
# UKE Bunch - Environment Preset Runner
# ==============================================================================
# Executes scripts found in ~/.config/uke/bunches/
# ==============================================================================

BUNCH_DIR="$HOME/.config/uke/bunches"
NAME="$1"

if [[ -z "$NAME" ]]; then
    echo "Available bunches:"
    if [[ -d "$BUNCH_DIR" ]]; then
        ls "$BUNCH_DIR" | grep ".sh$" | sed 's/\.sh//'
    else
        echo "  (No bunches found in $BUNCH_DIR)"
    fi
    exit 0
fi

TARGET="$BUNCH_DIR/$NAME.sh"

if [[ -f "$TARGET" ]]; then
    echo "Running bunch: $NAME"
    bash "$TARGET"
else
    echo "Bunch '$NAME' not found."
    exit 1
fi
"""

# ------------------------------------------------------------------------------
# 9. UKE AUTOSTART (Hyprland Launcher)
# ------------------------------------------------------------------------------
SCRIPTS["uke-autostart"] = r"""#!/usr/bin/env bash
# ==============================================================================
# UKE Autostart (Linux/Hyprland)
# ==============================================================================
# Checks for Hyprland and starts it. Used in .zprofile
# ==============================================================================

if [[ "$(uname -s)" != "Linux" ]]; then exit 0; fi

# Guard: Don't run if Hyprland is already running
if pgrep -x "Hyprland" >/dev/null; then exit 0; fi

# Guard: Manual disable
if [[ -f "$HOME/.no-hyprland" ]]; then
    echo "Hyprland autostart disabled (~/.no-hyprland exists)."
    return 0 2>/dev/null || exit 0
fi

# TTY Check (Only auto-start on TTY1)
if [[ "$(tty)" == "/dev/tty1" ]]; then
    echo "Starting Hyprland..."
    
    # Environment Setup
    export XDG_CURRENT_DESKTOP=Hyprland
    export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=Hyprland
    
    # Exec
    exec Hyprland
fi
"""

# ------------------------------------------------------------------------------
# GENERATION LOGIC
# ------------------------------------------------------------------------------

def generate_bins():
    output_dir = Path("bin")
    output_dir.mkdir(parents=True, exist_ok=True)
    
    print(f"Generating v8 scripts in {output_dir.resolve()}...")
    
    for filename, content in SCRIPTS.items():
        filepath = output_dir / filename
        
        # Write content
        with open(filepath, "w") as f:
            f.write(content)
        
        # Make executable (chmod +x)
        st = os.stat(filepath)
        os.chmod(filepath, st.st_mode | stat.S_IEXEC)
        
        print(f"  [+] {filename}")

if __name__ == "__main__":
    generate_bins()
    print("\nGeneration complete. Copy 'bin/' content to 'uke/shared/.local/bin/'.")