#!/usr/bin/env bash
# ==============================================================================
# UKE Core Library
# ==============================================================================
set -euo pipefail

[[ -n "${_UKE_CORE_LOADED:-}" ]] && return 0
readonly _UKE_CORE_LOADED=1

# ------------------------------------------------------------------------------
# Path Resolution
# ------------------------------------------------------------------------------
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
export UKE_VERSION="6.0.0"

# ------------------------------------------------------------------------------
# Directories
# ------------------------------------------------------------------------------
export UKE_LIB="$UKE_ROOT/lib"
export UKE_BIN="$UKE_ROOT/bin"
export UKE_CONFIG="$UKE_ROOT/config"
export UKE_GEN="$UKE_ROOT/gen"
export UKE_STOW="$UKE_ROOT/stow"
export UKE_BUNCHES="$UKE_ROOT/bunches"
export UKE_SCRIPTS="$UKE_ROOT/scripts"
export UKE_DOCS="$UKE_ROOT/docs"

export UKE_STATE="${XDG_STATE_HOME:-$HOME/.local/state}/uke"
export UKE_LOG_FILE="$UKE_STATE/uke.log"

mkdir -p "$UKE_STATE" 2>/dev/null || true

# ------------------------------------------------------------------------------
# Platform Detection
# ------------------------------------------------------------------------------
case "$(uname -s)" in
    Darwin) export UKE_OS="macos" ;;
    Linux)  export UKE_OS="linux" ;;
    *)      export UKE_OS="unknown" ;;
esac

is_macos() { [[ "$UKE_OS" == "macos" ]]; }
is_linux() { [[ "$UKE_OS" == "linux" ]]; }

# ------------------------------------------------------------------------------
# Colors
# ------------------------------------------------------------------------------
if [[ -t 1 ]]; then
    readonly C_RED=$'\e[31m' C_GREEN=$'\e[32m' C_YELLOW=$'\e[33m'
    readonly C_BLUE=$'\e[34m' C_MAGENTA=$'\e[35m' C_CYAN=$'\e[36m'
    readonly C_BOLD=$'\e[1m' C_DIM=$'\e[2m' C_RESET=$'\e[0m'
else
    readonly C_RED='' C_GREEN='' C_YELLOW='' C_BLUE='' C_MAGENTA='' C_CYAN=''
    readonly C_BOLD='' C_DIM='' C_RESET=''
fi

# ------------------------------------------------------------------------------
# Logging
# ------------------------------------------------------------------------------
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

# ------------------------------------------------------------------------------
# Utilities
# ------------------------------------------------------------------------------
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
