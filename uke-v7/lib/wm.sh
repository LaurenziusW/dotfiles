#!/usr/bin/env bash
# ==============================================================================
# UKE Window Manager Abstraction v7.0
# ==============================================================================

[[ -n "${_UKE_WM_LOADED:-}" ]] && return 0
readonly _UKE_WM_LOADED=1

source "${UKE_LIB:-$(dirname "$0")/../lib}/core.sh"

# ==============================================================================
# Status
# ==============================================================================
wm_name() {
    is_macos && echo "yabai" || echo "hyprland"
}

wm_running() {
    if is_macos; then
        pgrep -q yabai
    else
        [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]
    fi
}

# ==============================================================================
# Focus
# ==============================================================================
wm_focus() {
    local dir="$1"
    if is_macos; then
        case "$dir" in
            left)  yabai -m window --focus west ;;
            down)  yabai -m window --focus south ;;
            up)    yabai -m window --focus north ;;
            right) yabai -m window --focus east ;;
        esac
    else
        local d; case "$dir" in left) d=l;; down) d=d;; up) d=u;; right) d=r;; esac
        hyprctl dispatch movefocus "$d"
    fi
}

# ==============================================================================
# Move Window
# ==============================================================================
wm_move() {
    local dir="$1"
    if is_macos; then
        case "$dir" in
            left)  yabai -m window --warp west ;;
            down)  yabai -m window --warp south ;;
            up)    yabai -m window --warp north ;;
            right) yabai -m window --warp east ;;
        esac
    else
        local d; case "$dir" in left) d=l;; down) d=d;; up) d=u;; right) d=r;; esac
        hyprctl dispatch movewindow "$d"
    fi
}

# ==============================================================================
# Resize
# ==============================================================================
wm_resize() {
    local dir="$1" amt="${2:-50}"
    if is_macos; then
        case "$dir" in
            left)  yabai -m window --resize left:-${amt}:0 ;;
            down)  yabai -m window --resize bottom:0:${amt} ;;
            up)    yabai -m window --resize top:0:-${amt} ;;
            right) yabai -m window --resize right:${amt}:0 ;;
        esac
    else
        case "$dir" in
            left)  hyprctl dispatch resizeactive -${amt} 0 ;;
            down)  hyprctl dispatch resizeactive 0 ${amt} ;;
            up)    hyprctl dispatch resizeactive 0 -${amt} ;;
            right) hyprctl dispatch resizeactive ${amt} 0 ;;
        esac
    fi
}

# ==============================================================================
# Workspace
# ==============================================================================
wm_workspace() {
    local ws="$1"
    is_macos && yabai -m space --focus "$ws" || hyprctl dispatch workspace "$ws"
}

wm_move_to_workspace() {
    local ws="$1" follow="${2:-1}"
    if is_macos; then
        [[ "$follow" == "1" ]] && yabai -m window --space "$ws" --focus || yabai -m window --space "$ws"
    else
        [[ "$follow" == "1" ]] && hyprctl dispatch movetoworkspace "$ws" || hyprctl dispatch movetoworkspacesilent "$ws"
    fi
}

wm_current_workspace() {
    if is_macos; then
        yabai -m query --spaces --space 2>/dev/null | grep -o '"index":[0-9]*' | cut -d: -f2
    else
        hyprctl activeworkspace -j 2>/dev/null | grep -o '"id":[0-9]*' | cut -d: -f2
    fi
}

# ==============================================================================
# Window Controls
# ==============================================================================
wm_fullscreen() { is_macos && yabai -m window --toggle zoom-fullscreen || hyprctl dispatch fullscreen 0; }
wm_float()      { is_macos && yabai -m window --toggle float || hyprctl dispatch togglefloating; }
wm_split()      { is_macos && yabai -m window --toggle split || hyprctl dispatch togglesplit; }
wm_rotate()     { is_macos && yabai -m space --rotate 90 || hyprctl dispatch layoutmsg orientationcycle; }
wm_balance()    { is_macos && yabai -m space --balance; }
wm_close()      { is_macos && yabai -m window --close || hyprctl dispatch killactive; }

# ==============================================================================
# Query
# ==============================================================================
wm_windows() {
    local ws="${1:-}"
    if is_macos; then
        [[ -n "$ws" ]] && yabai -m query --windows --space "$ws" || yabai -m query --windows
    else
        local all; all="$(hyprctl clients -j)"
        [[ -n "$ws" ]] && echo "$all" | jq "[.[] | select(.workspace.id == $ws)]" || echo "$all"
    fi
}

# ==============================================================================
# Service Management
# ==============================================================================
wm_reload() {
    log_info "Reloading window manager..."
    if is_macos; then
        yabai --restart-service 2>/dev/null && ok "yabai restarted"
        skhd --restart-service 2>/dev/null && ok "skhd restarted"
    else
        hyprctl reload 2>/dev/null && ok "hyprland reloaded"
    fi
}
