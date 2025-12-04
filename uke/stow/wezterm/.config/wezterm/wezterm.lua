-- ==============================================================================
-- UKE WezTerm Configuration
-- ==============================================================================
-- This is the main WezTerm config managed by UKE
-- Hardware-specific settings are in generated_hardware.lua (ghost file)
-- ==============================================================================

local wezterm = require('wezterm')
local config = wezterm.config_builder()

-- ==============================================================================
-- Load Hardware Config (Ghost File)
-- ==============================================================================
local hw_ok, hw = pcall(function()
    return dofile(wezterm.config_dir .. '/generated_hardware.lua')
end)

if not hw_ok then
    -- Defaults if ghost file is missing
    hw = {
        font_size = 11.0,
        is_macos = wezterm.target_triple:find("darwin") ~= nil,
        is_linux = wezterm.target_triple:find("linux") ~= nil,
        front_end = "OpenGL",
    }
end

-- ==============================================================================
-- Appearance
-- ==============================================================================
config.color_scheme = 'Nord (Gogh)'
config.font = wezterm.font_with_fallback({
    'JetBrainsMono Nerd Font',
    'JetBrains Mono',
    'Fira Code',
    'monospace',
})
config.font_size = hw.font_size

-- Window
config.window_decorations = "RESIZE"
config.window_padding = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 4,
}
config.window_background_opacity = 0.95
config.hide_tab_bar_if_only_one_tab = true

-- ==============================================================================
-- GPU / Rendering
-- ==============================================================================
config.front_end = hw.front_end or "OpenGL"
config.webgpu_power_preference = "HighPerformance"

-- ==============================================================================
-- Behavior
-- ==============================================================================
config.scrollback_lines = 10000
config.enable_scroll_bar = false
config.check_for_updates = false

-- Cursor
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 500

-- ==============================================================================
-- Keybindings
-- ==============================================================================
-- UKE uses the window manager for most navigation, so WezTerm bindings are minimal
-- SECONDARY modifier (Alt on macOS, Super on Linux) is reserved for terminal internals

local mod = hw.is_macos and 'ALT' or 'SUPER'

config.keys = {
    -- Pane management (SECONDARY modifier)
    { key = 'd', mods = mod, action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
    { key = 'D', mods = mod .. '|SHIFT', action = wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' }) },
    { key = 'w', mods = mod, action = wezterm.action.CloseCurrentPane({ confirm = true }) },
    
    -- Pane navigation
    { key = 'h', mods = mod, action = wezterm.action.ActivatePaneDirection('Left') },
    { key = 'j', mods = mod, action = wezterm.action.ActivatePaneDirection('Down') },
    { key = 'k', mods = mod, action = wezterm.action.ActivatePaneDirection('Up') },
    { key = 'l', mods = mod, action = wezterm.action.ActivatePaneDirection('Right') },
    
    -- Tab management
    { key = 't', mods = mod, action = wezterm.action.SpawnTab('CurrentPaneDomain') },
    { key = '[', mods = mod, action = wezterm.action.ActivateTabRelative(-1) },
    { key = ']', mods = mod, action = wezterm.action.ActivateTabRelative(1) },
    
    -- Zoom current pane
    { key = 'z', mods = mod, action = wezterm.action.TogglePaneZoomState },
    
    -- Copy mode
    { key = 'c', mods = mod .. '|SHIFT', action = wezterm.action.ActivateCopyMode },
    
    -- Scrollback search
    { key = 'f', mods = mod .. '|SHIFT', action = wezterm.action.Search({ CaseInSensitiveString = '' }) },
    
    -- Font size
    { key = '=', mods = mod, action = wezterm.action.IncreaseFontSize },
    { key = '-', mods = mod, action = wezterm.action.DecreaseFontSize },
    { key = '0', mods = mod, action = wezterm.action.ResetFontSize },
    
    -- Quick select (like tmux fingers)
    { key = 'Space', mods = mod, action = wezterm.action.QuickSelect },
}

-- Tab navigation with numbers
for i = 1, 9 do
    table.insert(config.keys, {
        key = tostring(i),
        mods = mod,
        action = wezterm.action.ActivateTab(i - 1),
    })
end

return config
