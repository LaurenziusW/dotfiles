#!/usr/bin/env bash
# ==============================================================================
# UKE Core Library
# Shared functions and variables for UKE scripts
# ==============================================================================

# ------------------------------------------------------------------------------
# Colors & Styling
# ------------------------------------------------------------------------------
if [[ -t 1 ]]; then
    C_RED=$'\e[31m'
    C_GREEN=$'\e[32m'
    C_YELLOW=$'\e[33m'
    C_BLUE=$'\e[34m'
    C_CYAN=$'\e[36m'
    C_BOLD=$'\e[1m'
    C_DIM=$'\e[2m'
    C_RESET=$'\e[0m'
else
    C_RED='' C_GREEN='' C_YELLOW='' C_BLUE='' C_CYAN='' C_BOLD='' C_DIM='' C_RESET=''
fi

# ------------------------------------------------------------------------------
# Logging & Output
# ------------------------------------------------------------------------------
ok() { printf "%s✓%s %s\n" "$C_GREEN" "$C_RESET" "$*"; }
fail() { printf "%s✗%s %s\n" "$C_RED" "$C_RESET" "$*"; }
warn() { printf "%s!%s %s\n" "$C_YELLOW" "$C_RESET" "$*"; }
info() { printf "%s→%s %s\n" "$C_BLUE" "$C_RESET" "$*"; }

log_info()  { echo "[INFO] $*"; }
log_warn()  { echo "[WARN] $*" >&2; }
log_error() { echo "[ERROR] $*" >&2; }
log_fatal() { echo "[FATAL] $*" >&2; exit 1; }

# ------------------------------------------------------------------------------
# Environment
# ------------------------------------------------------------------------------
export UKE_VERSION="8.1"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export UKE_CONFIG="$XDG_CONFIG_HOME/uke"
export UKE_STATE="$XDG_STATE_HOME/uke"
export UKE_LOG_FILE="$UKE_STATE/uke.log"

# Ensure directories exist
mkdir -p "$UKE_CONFIG" "$UKE_STATE"

# ------------------------------------------------------------------------------
# OS Detection
# ------------------------------------------------------------------------------
is_macos() { [[ "$(uname -s)" == "Darwin" ]]; }
is_linux() { [[ "$(uname -s)" == "Linux" ]]; }

if is_macos; then
    export UKE_OS="macos"
elif is_linux; then
    export UKE_OS="linux"
else
    export UKE_OS="unknown"
fi

# ------------------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------------------
require_cmd() {
    if ! command -v "$1" &>/dev/null; then
        fail "Command not found: $1"
        exit 1
    fi
}
