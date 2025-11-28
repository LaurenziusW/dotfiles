local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Platform
local is_macos = wezterm.target_triple:find("darwin") ~= nil

-- Appearance
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font_with_fallback({ "JetBrains Mono", "Fira Code", "Menlo" })
config.font_size = is_macos and 14.0 or 12.0

config.window_decorations = "RESIZE"
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

-- Behavior
config.scrollback_lines = 10000
config.window_close_confirmation = "NeverPrompt"

-- Keys (Alt modifier to not conflict with WM)
local act = wezterm.action
config.keys = {
    -- Tabs
    { key = "t", mods = "ALT", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "w", mods = "ALT", action = act.CloseCurrentTab({ confirm = false }) },
    { key = "1", mods = "ALT", action = act.ActivateTab(0) },
    { key = "2", mods = "ALT", action = act.ActivateTab(1) },
    { key = "3", mods = "ALT", action = act.ActivateTab(2) },
    { key = "4", mods = "ALT", action = act.ActivateTab(3) },
    { key = "5", mods = "ALT", action = act.ActivateTab(4) },
    { key = "[", mods = "ALT", action = act.ActivateTabRelative(-1) },
    { key = "]", mods = "ALT", action = act.ActivateTabRelative(1) },
    
    -- Panes
    { key = "\\", mods = "ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "-", mods = "ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "x", mods = "ALT", action = act.CloseCurrentPane({ confirm = false }) },
    { key = "h", mods = "ALT|SHIFT", action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = "ALT|SHIFT", action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "ALT|SHIFT", action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = "ALT|SHIFT", action = act.ActivatePaneDirection("Right") },
    { key = "z", mods = "ALT", action = act.TogglePaneZoomState },
    
    -- Misc
    { key = "f", mods = "ALT", action = act.Search({ CaseInSensitiveString = "" }) },
    { key = "r", mods = "ALT", action = act.ReloadConfiguration },
}

config.mouse_bindings = {
    { event = { Down = { streak = 1, button = "Right" } }, mods = "NONE", action = act.PasteFrom("Clipboard") },
}

config.initial_cols = 120
config.initial_rows = 35

return config
