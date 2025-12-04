# ==============================================================================
# UKE ZSH Profile
# ==============================================================================
# Login shell configuration - runs once at login
# ==============================================================================

# ==============================================================================
# Environment
# ==============================================================================
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# XDG Base Directory
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Path
export PATH="$HOME/.local/bin:$PATH"

# UKE
export UKE_ROOT="${UKE_ROOT:-$HOME/dotfiles/uke}"

# ==============================================================================
# Platform-Specific Login Setup
# ==============================================================================
case "$(uname -s)" in
    Darwin)
        # macOS: Setup Homebrew in login shell
        [[ -f "/opt/homebrew/bin/brew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
        [[ -f "/usr/local/bin/brew" ]] && eval "$(/usr/local/bin/brew shellenv)"
        ;;
    Linux)
        # ==============================================================================
        # Linux (Arch): Hyprland Auto-start on TTY1
        # ==============================================================================
        # SAFETY: Only runs on TTY1, not in graphical environment
        # ESCAPE HATCH: Hold Ctrl+C during login to skip, or create ~/.no-hyprland
        # TO DISABLE: Remove this block or create ~/.no-hyprland
        # ==============================================================================
        
        # Skip autostart conditions:
        # - Already in X or Wayland
        # - Not on TTY1
        # - Escape file exists
        # - NOAUTOSTART environment variable set
        if [[ -z "${DISPLAY:-}" ]] && \
           [[ -z "${WAYLAND_DISPLAY:-}" ]] && \
           [[ "${XDG_VTNR:-}" == "1" ]] && \
           [[ ! -f "$HOME/.no-hyprland" ]] && \
           [[ -z "${NOAUTOSTART:-}" ]]; then
            
            # Give user 2 seconds to press Ctrl+C to abort
            echo "Starting Hyprland in 2 seconds... (Ctrl+C to cancel, or create ~/.no-hyprland)"
            sleep 2
            
            # Check if Hyprland is actually installed and working
            if command -v Hyprland &>/dev/null; then
                # Use exec only if we're confident it will work
                # If it fails, we fall through to normal shell
                Hyprland || {
                    echo "Hyprland failed to start!"
                    echo "To disable autostart: touch ~/.no-hyprland"
                    echo "Dropping to shell..."
                }
            else
                echo "Hyprland not found. Install with: sudo pacman -S hyprland"
            fi
        fi
        ;;
esac
