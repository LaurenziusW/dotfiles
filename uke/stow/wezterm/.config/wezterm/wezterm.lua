-- ==============================================================================
-- UKE WezTerm Configuration v7.2 - Cross-Platform (FIXED)
-- ==============================================================================
-- SECONDARY Layer: Alt (macOS) / Super (Linux)
-- Conflict-free: Cmd stays with yabai, Alt handles terminal internals
-- ==============================================================================

local wezterm = require('wezterm')
local config = wezterm.config_builder()
local act = wezterm.action

-- ==============================================================================
-- OS Detection
-- ==============================================================================

local function is_macos()
  return wezterm.target_triple:find("darwin") ~= nil
end

local function is_linux()
  return wezterm.target_triple:find("linux") ~= nil
end

-- SECONDARY modifier: Alt on macOS, Super on Linux
local SECONDARY = is_macos() and "ALT" or "SUPER"

-- ==============================================================================
-- Load Hardware Config (Ghost File)
-- ==============================================================================
-- Try multiple paths to find the generated hardware config

local hw = nil
local hw_paths = {
  wezterm.config_dir .. '/generated_hardware.lua',
  os.getenv("HOME") .. '/.config/wezterm/generated_hardware.lua',
  os.getenv("HOME") .. '/.wezterm_hardware.lua',
}

for _, path in ipairs(hw_paths) do
  local ok, result = pcall(function()
    return dofile(path)
  end)
  if ok and result then
    hw = result
    break
  end
end

-- Defaults if ghost file is missing
if not hw then
  hw = {
    font_size = is_macos() and 14.0 or 11.0,
    is_macos = is_macos(),
    is_linux = is_linux(),
    front_end = "OpenGL",
    gpu = "integrated",
    keyboard = "standard",
    monitors = 1,
  }
end

-- ==============================================================================
-- Appearance
-- ==============================================================================

config.color_scheme = 'Catppuccin Mocha'

config.font = wezterm.font_with_fallback({
  'JetBrainsMono Nerd Font',
  'JetBrains Mono',
  'Fira Code',
  'Menlo',
  'Monaco',
  'monospace',
})

config.font_size = hw.font_size or (is_macos() and 14.0 or 11.0)
config.line_height = 1.2

-- Window
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

config.window_background_opacity = 0.95
if is_macos() then
  config.macos_window_background_blur = 20
end

-- Tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

-- Initial size
config.initial_cols = 120
config.initial_rows = 35

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
config.window_close_confirmation = "NeverPrompt"
config.check_for_updates = false

-- Cursor
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 500

-- ==============================================================================
-- Keybindings (SECONDARY Layer)
-- ==============================================================================

config.keys = {
  -- ─────────────────────────────────────────────────────────────────────────
  -- Tab Management
  -- ─────────────────────────────────────────────────────────────────────────
  { key = "t", mods = SECONDARY, action = act.SpawnTab("CurrentPaneDomain") },

  -- Close pane (closes split first, then tab if no more panes)
  { key = "w", mods = SECONDARY, action = act.CloseCurrentPane({ confirm = false }) },
  { key = "x", mods = SECONDARY, action = act.CloseCurrentPane({ confirm = false }) },

  -- Tab navigation relative
  { key = "[", mods = SECONDARY, action = act.ActivateTabRelative(-1) },
  { key = "]", mods = SECONDARY, action = act.ActivateTabRelative(1) },

  -- ─────────────────────────────────────────────────────────────────────────
  -- Pane Splitting
  -- ─────────────────────────────────────────────────────────────────────────
  { key = "\\", mods = SECONDARY, action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "-", mods = SECONDARY, action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = SECONDARY, action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "D", mods = SECONDARY .. "|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

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
  { key = "H", mods = SECONDARY .. "|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "J", mods = SECONDARY .. "|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
  { key = "K", mods = SECONDARY .. "|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "L", mods = SECONDARY .. "|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },

  -- ─────────────────────────────────────────────────────────────────────────
  -- Utilities
  -- ─────────────────────────────────────────────────────────────────────────
  { key = "z", mods = SECONDARY, action = act.TogglePaneZoomState },
  { key = "f", mods = SECONDARY, action = act.Search({ CaseInSensitiveString = "" }) },
  { key = "r", mods = SECONDARY, action = act.ReloadConfiguration },
  { key = "p", mods = SECONDARY, action = act.ActivateCommandPalette },

  -- Copy mode
  { key = "c", mods = SECONDARY .. "|SHIFT", action = act.ActivateCopyMode },

  -- Quick select (like tmux fingers)
  { key = "Space", mods = SECONDARY, action = act.QuickSelect },

  -- Font size
  { key = "=", mods = SECONDARY, action = act.IncreaseFontSize },
  { key = "+", mods = SECONDARY .. "|SHIFT", action = act.IncreaseFontSize },
  { key = "0", mods = SECONDARY, action = act.ResetFontSize },
}

-- Tab navigation with numbers (1-9)
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = SECONDARY,
    action = act.ActivateTab(i - 1),
  })
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Mouse Bindings
-- ─────────────────────────────────────────────────────────────────────────────

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