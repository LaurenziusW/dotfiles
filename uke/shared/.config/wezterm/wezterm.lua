-- =============================================================================
-- UKE v8 - WezTerm Configuration
-- Cross-platform terminal with unified keybindings
-- =============================================================================

local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- =============================================================================
-- OS Detection
-- =============================================================================
local is_macos = wezterm.target_triple:find("darwin") ~= nil
local is_linux = wezterm.target_triple:find("linux") ~= nil

-- SECONDARY modifier: Alt on macOS, Super on Linux
-- This keeps WM keybindings (PRIMARY) separate from terminal keybindings
local SECONDARY = is_macos and "ALT" or "SUPER"
local TERTIARY = SECONDARY .. "|SHIFT"

-- =============================================================================
-- Appearance
-- =============================================================================
config.color_scheme = "Nord"
config.font = wezterm.font("JetBrains Mono", { weight = "Medium" })
config.font_size = is_macos and 14 or 12
config.line_height = 1.1

config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

-- Cursor
config.default_cursor_style = "SteadyBar"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- macOS specific
if is_macos then
    config.native_macos_fullscreen_mode = false
    config.macos_window_background_blur = 20
end

-- =============================================================================
-- Keybindings
-- =============================================================================
-- Philosophy:
--   SECONDARY (Alt/Super) = Tab/Pane navigation (app-level)
--   TERTIARY (Alt+Shift/Super+Shift) = Pane resizing
--   CTRL = Shell commands (never intercepted)
--   CTRL+A = tmux prefix (passed through)

config.keys = {
    -- =========================================================================
    -- Tabs (SECONDARY)
    -- =========================================================================
    { key = "t", mods = SECONDARY, action = act.SpawnTab("CurrentPaneDomain") },
    { key = "w", mods = SECONDARY, action = act.CloseCurrentTab({ confirm = true }) },
    { key = "[", mods = SECONDARY, action = act.ActivateTabRelative(-1) },
    { key = "]", mods = SECONDARY, action = act.ActivateTabRelative(1) },
    { key = "1", mods = SECONDARY, action = act.ActivateTab(0) },
    { key = "2", mods = SECONDARY, action = act.ActivateTab(1) },
    { key = "3", mods = SECONDARY, action = act.ActivateTab(2) },
    { key = "4", mods = SECONDARY, action = act.ActivateTab(3) },
    { key = "5", mods = SECONDARY, action = act.ActivateTab(4) },
    { key = "6", mods = SECONDARY, action = act.ActivateTab(5) },
    { key = "7", mods = SECONDARY, action = act.ActivateTab(6) },
    { key = "8", mods = SECONDARY, action = act.ActivateTab(7) },
    { key = "9", mods = SECONDARY, action = act.ActivateTab(8) },

    -- =========================================================================
    -- Pane Splits (SECONDARY)
    -- =========================================================================
    { key = "\\", mods = SECONDARY, action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "-", mods = SECONDARY, action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "x", mods = SECONDARY, action = act.CloseCurrentPane({ confirm = true }) },
    { key = "z", mods = SECONDARY, action = act.TogglePaneZoomState },

    -- =========================================================================
    -- Pane Navigation (SECONDARY + hjkl)
    -- =========================================================================
    { key = "h", mods = SECONDARY, action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = SECONDARY, action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = SECONDARY, action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = SECONDARY, action = act.ActivatePaneDirection("Right") },

    -- =========================================================================
    -- Pane Resizing (TERTIARY + hjkl)
    -- =========================================================================
    { key = "h", mods = TERTIARY, action = act.AdjustPaneSize({ "Left", 5 }) },
    { key = "j", mods = TERTIARY, action = act.AdjustPaneSize({ "Down", 5 }) },
    { key = "k", mods = TERTIARY, action = act.AdjustPaneSize({ "Up", 5 }) },
    { key = "l", mods = TERTIARY, action = act.AdjustPaneSize({ "Right", 5 }) },

    -- =========================================================================
    -- Utilities
    -- =========================================================================
    { key = "r", mods = SECONDARY, action = act.ReloadConfiguration },
    { key = "f", mods = SECONDARY, action = act.Search({ CaseSensitiveString = "" }) },
    { key = "c", mods = SECONDARY, action = act.CopyTo("Clipboard") },
    { key = "v", mods = SECONDARY, action = act.PasteFrom("Clipboard") },

    -- Scroll
    { key = "u", mods = SECONDARY, action = act.ScrollByPage(-0.5) },
    { key = "d", mods = SECONDARY, action = act.ScrollByPage(0.5) },

    -- Font size
    { key = "=", mods = SECONDARY, action = act.IncreaseFontSize },
    { key = "-", mods = SECONDARY .. "|CTRL", action = act.DecreaseFontSize },
    { key = "0", mods = SECONDARY, action = act.ResetFontSize },
}

-- =============================================================================
-- Mouse
-- =============================================================================
config.mouse_bindings = {
    -- Right-click paste
    {
        event = { Down = { streak = 1, button = "Right" } },
        mods = "NONE",
        action = act.PasteFrom("Clipboard"),
    },
    -- Ctrl+Click open URL
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = act.OpenLinkAtMouseCursor,
    },
}

-- =============================================================================
-- Local Overrides (for hardware-specific settings)
-- =============================================================================
local ok, local_config = pcall(require, "local")
if ok and type(local_config) == "table" then
    for k, v in pairs(local_config) do
        config[k] = v
    end
end

return config
