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
        # Linux (Arch): Hyprland Auto-start on TTY1
        # Start Hyprland on TTY1 login with fallback
        # To disable: comment out or remove this block
        if [[ -z "${DISPLAY:-}" ]] && [[ "${XDG_VTNR:-}" == "1" ]] && [[ -z "${WAYLAND_DISPLAY:-}" ]]; then
            if command -v uke-autostart &>/dev/null; then
                exec uke-autostart
            elif command -v Hyprland &>/dev/null; then
                exec Hyprland
            fi
        fi
        ;;
esac
