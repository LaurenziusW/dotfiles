#!/usr/bin/env bash
# ==============================================================================
# UKE Core Library v7.0
# ==============================================================================
# Foundation library with cloud path support and hardware profile integration.
# ==============================================================================
set -euo pipefail

[[ -n "${_UKE_CORE_LOADED:-}" ]] && return 0
readonly _UKE_CORE_LOADED=1

# ==============================================================================
# Path Resolution
# ==============================================================================
_resolve_uke_root() {
    local src="${BASH_SOURCE[1]:-${BASH_SOURCE[0]}}"
    while [[ -L "$src" ]]; do
        local dir="$(cd -P "$(dirname "$src")" && pwd)"
        src="$(readlink "$src")"
        [[ "$src" != /* ]] && src="$dir/$src"
    done
    cd -P "$(dirname "$src")/.." && pwd
}

export UKE_ROOT="${UKE_ROOT:-$(_resolve_uke_root)}"
export UKE_VERSION="7.2.0"

# ==============================================================================
# Cloud Path Support
# ==============================================================================
# If UKE_CLOUD_PATH is set, use it as the config source instead of UKE_ROOT
# Example: UKE_CLOUD_PATH="$HOME/Dropbox/uke-config"
#          UKE_CLOUD_PATH="$HOME/iCloud/uke-config"
#          UKE_CLOUD_PATH="$HOME/Google Drive/uke-config"
resolve_config_path() {
    if [[ -n "${UKE_CLOUD_PATH:-}" ]] && [[ -d "${UKE_CLOUD_PATH}" ]]; then
        echo "${UKE_CLOUD_PATH}"
    else
        echo "${UKE_ROOT}"
    fi
}

export UKE_CONFIG_SOURCE="$(resolve_config_path)"

# ==============================================================================
# Directory Structure
# ==============================================================================
# Code directories (from repo)
export UKE_LIB="$UKE_ROOT/lib"
export UKE_BIN="$UKE_ROOT/bin"
export UKE_SCRIPTS="$UKE_ROOT/scripts"
export UKE_STOW="$UKE_ROOT/stow"
export UKE_BUNCHES="$UKE_ROOT/bunches"
export UKE_DOCS="$UKE_ROOT/docs"
export UKE_TEMPLATES="$UKE_ROOT/templates"

# Config source (may be cloud or local)
export UKE_CONFIG="$UKE_CONFIG_SOURCE/config"

# Generated output (always local)
export UKE_GEN="$UKE_ROOT/gen"

# State (always local, machine-specific)
export UKE_STATE="${XDG_STATE_HOME:-$HOME/.local/state}/uke"
export UKE_LOG_FILE="$UKE_STATE/uke.log"

# Hardware profile (the "ghost file")
export UKE_PROFILE_FILE="$UKE_STATE/machine.profile"

# Ensure directories exist
mkdir -p "$UKE_STATE" 2>/dev/null || true
mkdir -p "$UKE_GEN"/{skhd,yabai,hyprland} 2>/dev/null || true

# ==============================================================================
# Platform Detection
# ==============================================================================
case "$(uname -s)" in
    Darwin) export UKE_OS="macos" ;;
    Linux)  export UKE_OS="linux" ;;
    *)      export UKE_OS="unknown" ;;
esac

# Distro detection (Linux only)
if [[ "$UKE_OS" == "linux" ]]; then
    if [[ -f /etc/arch-release ]]; then
        export UKE_DISTRO="arch"
    elif [[ -f /etc/debian_version ]]; then
        export UKE_DISTRO="debian"
    elif [[ -f /etc/fedora-release ]]; then
        export UKE_DISTRO="fedora"
    else
        export UKE_DISTRO="unknown"
    fi
else
    export UKE_DISTRO=""
fi

is_macos() { [[ "$UKE_OS" == "macos" ]]; }
is_linux() { [[ "$UKE_OS" == "linux" ]]; }

# ==============================================================================
# Hardware Profile Loading
# ==============================================================================
# Load machine-specific settings if profile exists
load_hardware_profile() {
    if [[ -f "$UKE_PROFILE_FILE" ]]; then
        # shellcheck source=/dev/null
        source "$UKE_PROFILE_FILE"
        return 0
    fi
    return 1
}

# Get profile value with fallback
get_profile() {
    local var="UKE_$1"
    local default="${2:-}"
    echo "${!var:-$default}"
}

# Check if profile exists
has_profile() {
    [[ -f "$UKE_PROFILE_FILE" ]]
}

# ==============================================================================
# Colors
# ==============================================================================
if [[ -t 1 ]]; then
    C_RED=$'\e[31m' C_GREEN=$'\e[32m' C_YELLOW=$'\e[33m'
    C_BLUE=$'\e[34m' C_MAGENTA=$'\e[35m' C_CYAN=$'\e[36m'
    C_BOLD=$'\e[1m' C_DIM=$'\e[2m' C_RESET=$'\e[0m'
else
    C_RED='' C_GREEN='' C_YELLOW='' C_BLUE='' C_MAGENTA='' C_CYAN=''
    C_BOLD='' C_DIM='' C_RESET=''
fi

# ==============================================================================
# Logging
# ==============================================================================
_log() {
    local level="$1" color="$2"; shift 2
    local ts="$(date '+%H:%M:%S')"
    printf "%s[%s]%s %s%s%s %s\n" "$C_DIM" "$ts" "$C_RESET" "$color" "$level" "$C_RESET" "$*" >&2
    [[ -w "$UKE_STATE" ]] && printf "[%s] [%s] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$*" >> "$UKE_LOG_FILE"
}

log_debug() { [[ -n "${UKE_DEBUG:-}" ]] && _log "DEBUG" "$C_BLUE" "$@"; }
log_info()  { _log "INFO " "$C_GREEN" "$@"; }
log_warn()  { _log "WARN " "$C_YELLOW" "$@"; }
log_error() { _log "ERROR" "$C_RED" "$@"; }
log_fatal() { _log "FATAL" "$C_RED" "$@"; exit 1; }

ok()   { printf "%s✓%s %s\n" "$C_GREEN" "$C_RESET" "$*"; }
fail() { printf "%s✗%s %s\n" "$C_RED" "$C_RESET" "$*"; }
warn() { printf "%s!%s %s\n" "$C_YELLOW" "$C_RESET" "$*"; }
info() { printf "%s→%s %s\n" "$C_BLUE" "$C_RESET" "$*"; }

# ==============================================================================
# Utilities
# ==============================================================================
require_cmd() {
    for cmd in "$@"; do
        command -v "$cmd" &>/dev/null || log_fatal "Required command not found: $cmd"
    done
}

require_file() {
    for f in "$@"; do
        [[ -f "$f" ]] || log_fatal "Required file not found: $f"
    done
}

run() {
    log_debug "exec: $*"
    if [[ -n "${UKE_DRY_RUN:-}" ]]; then
        log_info "[dry-run] $*"
        return 0
    fi
    "$@"
}

# Atomic file write
write_file() {
    local dest="$1"
    local content
    content=$(cat)
    
    mkdir -p "$(dirname "$dest")"
    local temp_file
    temp_file=$(mktemp)
    printf "%s\n" "$content" > "$temp_file"
    mv "$temp_file" "$dest"
}

# ==============================================================================
# YAML Helpers (requires yq)
# ==============================================================================
yaml_get() {
    local file="$1"
    local path="$2"
    local default="${3:-}"
    
    if command -v yq &>/dev/null; then
        local result
        result=$(yq -r "$path | select(. != null)" "$file" 2>/dev/null) || true
        echo "${result:-$default}"
    else
        echo "$default"
    fi
}

yaml_keys() {
    local file="$1"
    local path="$2"
    
    if command -v yq &>/dev/null; then
        yq -r "$path | keys | .[]" "$file" 2>/dev/null || true
    fi
}

yaml_array() {
    local file="$1"
    local path="$2"
    
    if command -v yq &>/dev/null; then
        yq -r "$path | .[]" "$file" 2>/dev/null || true
    fi
}
