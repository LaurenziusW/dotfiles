-- ==============================================================================
-- WEZTERM CONFIG - Unified Keyboard Environment
-- ==============================================================================
-- SECONDARY Layer: Alt (macOS) / Super (Linux)
-- Conflict-free: Cmd stays with yabai, Alt handles terminal internals
-- ==============================================================================

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- OS Detection
local function is_macos()
    return wezterm.target_triple:find("darwin") ~= nil
end

-- SECONDARY modifier: Alt on macOS, Super on Linux
local SECONDARY = is_macos() and "ALT" or "SUPER"

-- =============================================================================
-- Appearance
-- =============================================================================
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font_with_fallback({
    "JetBrains Mono",
    "Fira Code",
    "Menlo",
    "Monaco",
})
config.font_size = is_macos() and 14.0 or 12.0
config.line_height = 1.2

config.window_decorations = "RESIZE"
config.window_padding = {
    left = 8,
    right = 8,
    top = 8,
    bottom = 8,
}
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20

-- Tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

-- =============================================================================
-- Behavior
-- =============================================================================
config.scrollback_lines = 10000
config.window_close_confirmation = "NeverPrompt"
config.check_for_updates = false

-- Initial size
config.initial_cols = 120
config.initial_rows = 35

-- =============================================================================
-- Keybindings (SECONDARY Layer)
-- =============================================================================
local act = wezterm.action

config.keys = {
    -- ─────────────────────────────────────────────────────────────────────────
    -- Tab Management
    -- ─────────────────────────────────────────────────────────────────────────
    { key = "t", mods = SECONDARY, action = act.SpawnTab("CurrentPaneDomain") },
    { key = "w", mods = SECONDARY, action = act.CloseCurrentTab({ confirm = false }) },
    
    -- Tab navigation by number
    { key = "1", mods = SECONDARY, action = act.ActivateTab(0) },
    { key = "2", mods = SECONDARY, action = act.ActivateTab(1) },
    { key = "3", mods = SECONDARY, action = act.ActivateTab(2) },
    { key = "4", mods = SECONDARY, action = act.ActivateTab(3) },
    { key = "5", mods = SECONDARY, action = act.ActivateTab(4) },
    { key = "6", mods = SECONDARY, action = act.ActivateTab(5) },
    { key = "7", mods = SECONDARY, action = act.ActivateTab(6) },
    { key = "8", mods = SECONDARY, action = act.ActivateTab(7) },
    { key = "9", mods = SECONDARY, action = act.ActivateTab(8) },
    
    -- Tab navigation relative
    { key = "[", mods = SECONDARY, action = act.ActivateTabRelative(-1) },
    { key = "]", mods = SECONDARY, action = act.ActivateTabRelative(1) },

    -- ─────────────────────────────────────────────────────────────────────────
    -- Pane Splitting
    -- ─────────────────────────────────────────────────────────────────────────
    { key = "\\", mods = SECONDARY, action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "-", mods = SECONDARY, action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "x", mods = SECONDARY, action = act.CloseCurrentPane({ confirm = false }) },

    -- ─────────────────────────────────────────────────────────────────────────
    -- Pane Navigation (Vim-style)
    -- ─────────────────────────────────────────────────────────────────────────
    { key = "h", mods = SECONDARY, action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = SECONDARY, action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = SECONDARY, action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = SECONDARY, action = act.ActivatePaneDirection("Right") },

    -- ─────────────────────────────────────────────────────────────────────────
    -- Pane Resizing (SECONDARY + Shift)
    -- ─────────────────────────────────────────────────────────────────────────
    { key = "h", mods = SECONDARY .. "|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
    { key = "j", mods = SECONDARY .. "|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
    { key = "k", mods = SECONDARY .. "|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
    { key = "l", mods = SECONDARY .. "|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },

    -- ─────────────────────────────────────────────────────────────────────────
    -- Utilities
    -- ─────────────────────────────────────────────────────────────────────────
    { key = "z", mods = SECONDARY, action = act.TogglePaneZoomState },
    { key = "f", mods = SECONDARY, action = act.Search({ CaseInSensitiveString = "" }) },
    { key = "r", mods = SECONDARY, action = act.ReloadConfiguration },
    { key = "p", mods = SECONDARY, action = act.ActivateCommandPalette },
}

-- Mouse bindings
config.mouse_bindings = {
    -- Right click to paste
    {
        event = { Down = { streak = 1, button = "Right" } },
        mods = "NONE",
        action = act.PasteFrom("Clipboard"),
    },
}

-- Keep default keybindings for system copy/paste
config.disable_default_key_bindings = false

return config
