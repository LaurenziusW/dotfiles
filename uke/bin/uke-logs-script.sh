#!/usr/bin/env bash
# ==============================================================================
# uke-logs - UKE Diagnostic Logger
# ==============================================================================
# Sammelt alle Fehler und Logs für Debugging
#
# Verwendung: uke logs
# Speichert alle Logs in: ~/.local/state/uke/logs-$(date +%s)/
#
# Wird aufgerufen von: bin/uke-logs (symlink)
# ==============================================================================

set -e

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/../lib/core.sh"

log_dir="$UKE_STATE/logs-$(date +%s)"
mkdir -p "$log_dir"

log_info "🔍 Collecting UKE diagnostics..."
log_info "📁 Logs will be saved to: $log_dir"

# =============================================================================
# 1. SYSTEM INFO
# =============================================================================
log_info "Collecting system info..."
{
    echo "=== System Info ==="
    uname -a
    echo ""
    echo "=== OS Release ==="
    cat /etc/os-release 2>/dev/null || echo "N/A"
    echo ""
    echo "=== UKE Environment ==="
    env | grep -i uke || echo "No UKE vars set"
    echo ""
    echo "=== UKE Directories ==="
    echo "UKE_ROOT: $UKE_ROOT"
    echo "UKE_CONFIG: $UKE_CONFIG"
    echo "UKE_GEN: $UKE_GEN"
    echo "UKE_STATE: $UKE_STATE"
} > "$log_dir/01-system.log"

# =============================================================================
# 2. HYPRLAND
# =============================================================================
log_info "Collecting Hyprland diagnostics..."
{
    echo "=== Hyprland Version ==="
    hyprland --version 2>/dev/null || echo "Hyprland not found"
    
    echo ""
    echo "=== Config Paths ==="
    echo "XDG_CONFIG_HOME: ${XDG_CONFIG_HOME:-not set}"
    ls -la ~/.config/hypr/hyprland.conf 2>/dev/null || echo "~/.config/hypr/hyprland.conf not found"
    
    echo ""
    echo "=== Generated Config (first 60 lines) ==="
    head -n 60 ~/.config/hypr/hyprland.conf 2>/dev/null || echo "Not found"
    
    echo ""
    echo "=== Hyprland Journal Logs (last 100 lines) ==="
    journalctl --user-unit hyprland.service --no-pager -n 100 2>/dev/null || \
    journalctl --user --since "1 hour ago" --no-pager | grep -i hypr | tail -100 || \
    echo "Journalctl not available"
    
    echo ""
    echo "=== Active Workspace ==="
    hyprctl activeworkspace 2>/dev/null || echo "Hyprland not running"
    
    echo ""
    echo "=== Config Validation (syntax check) ==="
    if command -v hyprctl &>/dev/null && pgrep -x hyprland >/dev/null 2>&1; then
        echo "Hyprland is running - config is valid"
    else
        echo "Hyprland not running - cannot validate live"
    fi
} > "$log_dir/02-hyprland.log"

# =============================================================================
# 3. WEZTERM
# =============================================================================
log_info "Collecting WezTerm diagnostics..."
{
    echo "=== WezTerm Version ==="
    wezterm --version 2>/dev/null || echo "WezTerm not installed"
    
    echo ""
    echo "=== Config Path ==="
    ls -la ~/.config/wezterm/wezterm.lua 2>/dev/null || echo "Not found"
    
    echo ""
    echo "=== Lua Syntax Check ==="
    if command -v lua &>/dev/null; then
        lua -c ~/.config/wezterm/wezterm.lua 2>&1 && echo "✓ Lua syntax is valid" || echo "✗ Lua syntax error found"
    else
        echo "Lua not installed - cannot validate"
    fi
    
    echo ""
    echo "=== WezTerm Process ==="
    ps aux | grep -i wezterm | grep -v grep || echo "WezTerm not running"
    
    echo ""
    echo "=== WezTerm Config (first 50 lines) ==="
    head -n 50 ~/.config/wezterm/wezterm.lua 2>/dev/null || echo "Not found"
    
    echo ""
    echo "=== WezTerm Logs ==="
    find ~/.local/share/wezterm -name "*.log" -mmin -120 -exec tail -20 {} \; 2>/dev/null || echo "No recent logs found"
} > "$log_dir/03-wezterm.log"

# =============================================================================
# 4. ZSH
# =============================================================================
log_info "Collecting Zsh diagnostics..."
{
    echo "=== Zsh Version ==="
    zsh --version
    
    echo ""
    echo "=== Config Paths ==="
    ls -la ~/.zshrc ~/.zprofile 2>/dev/null || echo "Not found"
    
    echo ""
    echo "=== Zsh Startup Test (trace first 50 lines) ==="
    timeout 5 zsh -x ~/.zshrc 2>&1 | head -50 || echo "Timeout or error"
    
    echo ""
    echo "=== Zsh History ==="
    ls -lah ~/.zsh_history 2>/dev/null || echo "Not found"
    
    echo ""
    echo "=== Plugin Status ==="
    echo "fzf: $(command -v fzf &>/dev/null && echo '✓ Found' || echo '✗ NOT FOUND')"
    echo "zoxide: $(command -v zoxide &>/dev/null && echo '✓ Found' || echo '✗ NOT FOUND')"
    echo "starship: $(command -v starship &>/dev/null && echo '✓ Found' || echo '✗ NOT FOUND')"
    echo "exa/eza: $(command -v eza &>/dev/null && echo '✓ eza' || (command -v exa &>/dev/null && echo '✓ exa') || echo '✗ NOT FOUND')"
} > "$log_dir/04-zsh.log"

# =============================================================================
# 5. UKE PROJECT
# =============================================================================
log_info "Collecting UKE project diagnostics..."
{
    echo "=== UKE Root ==="
    echo "UKE_ROOT=$UKE_ROOT"
    echo "Exists: $(test -d "$UKE_ROOT" && echo 'YES' || echo 'NO')"
    
    echo ""
    echo "=== UKE Directory Tree (2 levels) ==="
    if command -v tree &>/dev/null; then
        tree -L 2 "$UKE_ROOT" 2>/dev/null || find "$UKE_ROOT" -maxdepth 2 -type f | head -30
    else
        find "$UKE_ROOT" -maxdepth 2 -type f | head -30
    fi
    
    echo ""
    echo "=== Registry.yaml (first 60 lines) ==="
    head -n 60 "$UKE_CONFIG/registry.yaml" 2>/dev/null || echo "Not found at: $UKE_CONFIG/registry.yaml"
    
    echo ""
    echo "=== Generated Files (recent) ==="
    find "$UKE_GEN" -type f -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -15 || echo "No gen files"
    
    echo ""
    echo "=== Git Status ==="
    cd "$UKE_ROOT" && git status --short 2>/dev/null || echo "Not a git repo or git not available"
} > "$log_dir/05-uke.log"

# =============================================================================
# 6. SYSTEMD USER SERVICES
# =============================================================================
log_info "Collecting systemd logs..."
{
    echo "=== User Service Status ==="
    systemctl --user status 2>&1 | head -10
    
    echo ""
    echo "=== Recent Journal Entries (last 2 hours) ==="
    journalctl --user --since "2 hours ago" --no-pager -n 50 2>/dev/null || echo "N/A"
    
    echo ""
    echo "=== Failed Units ==="
    systemctl --user list-units --failed --no-pager 2>/dev/null || echo "N/A"
} > "$log_dir/06-systemd.log"

# =============================================================================
# 7. ENVIRONMENT & PATH
# =============================================================================
log_info "Collecting environment variables..."
{
    echo "=== PATH ==="
    echo "$PATH" | tr ':' '\n' | nl
    
    echo ""
    echo "=== Key Environment Variables ==="
    env | grep -E "EDITOR|SHELL|LANG|LC_|XDG_|UKE_" | sort
    
    echo ""
    echo "=== Locale ==="
    locale
} > "$log_dir/07-environment.log"

# =============================================================================
# 8. FILE PERMISSIONS
# =============================================================================
log_info "Checking file permissions..."
{
    echo "=== .config Ownership ==="
    ls -ld ~/.config
    
    echo ""
    echo "=== UKE State Directory ==="
    ls -lad "$UKE_STATE"
    
    echo ""
    echo "=== Config File Permissions ==="
    echo "WezTerm:"
    ls -la ~/.config/wezterm/wezterm.lua 2>/dev/null || echo "  Not found"
    
    echo ""
    echo "Hyprland:"
    ls -la ~/.config/hypr/hyprland.conf 2>/dev/null || echo "  Not found"
    
    echo ""
    echo "Zsh:"
    ls -la ~/.zshrc 2>/dev/null || echo "  Not found"
} > "$log_dir/08-permissions.log"

# =============================================================================
# SUMMARY
# =============================================================================
echo ""
log_ok "Diagnostics complete!"
echo ""
echo "📊 Generated files in: $log_dir"
ls -lh "$log_dir"/*.log

echo ""
echo "💾 Quick review:"
for f in "$log_dir"/*.log; do
    echo ""
    echo "--- $(basename "$f") (first 3 lines) ---"
    head -3 "$f"
done

echo ""
echo "🚀 To download via SCP:"
echo "   scp -r $log_dir user@your-mac:/tmp/"
echo ""
echo "📋 Full command to view specific log:"
echo "   cat $log_dir/02-hyprland.log"
echo "   cat $log_dir/03-wezterm.log"
echo "   cat $log_dir/04-zsh.log"
