-- =============================================================================
-- UKE v8.1 - WezTerm Configuration (Consolidated)
-- Cross-platform terminal with unified keybindings and features
-- =============================================================================

local wezterm = require('wezterm')
local config = wezterm.config_builder()
local act = wezterm.action

-- =============================================================================
-- OS Detection
-- =============================================================================

local function is_macos()
  return wezterm.target_triple:find("darwin") ~= nil
end

local function is_linux()
  return wezterm.target_triple:find("linux") ~= nil
end

-- SECONDARY modifier: Alt on macOS, Super on Linux
-- This keeps WM keybindings (PRIMARY) separate from terminal keybindings
local SECONDARY = is_macos() and "ALT" or "SUPER"
local TERTIARY = SECONDARY .. "|SHIFT"

-- =============================================================================
-- Load Hardware Config (Ghost File) for Font Size & Rendering
-- =============================================================================
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
    front_end = "WebGpu",
    gpu = "integrated",
    keyboard = "standard",
    monitors = 1,
  }
end

-- =============================================================================
-- Appearance
-- =============================================================================

config.color_scheme = 'Catppuccin Mocha' -- User preference: Catppuccin

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
config.tab_bar_at_bottom = true -- User preference: Tabs at bottom
config.hide_tab_bar_if_only_one_tab = true

-- Initial size
config.initial_cols = 120
config.initial_rows = 35

-- Cursor
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 500

-- =============================================================================
-- GPU / Rendering
-- =============================================================================

config.front_end = hw.front_end or "OpenGL"
config.webgpu_power_preference = "HighPerformance"

-- =============================================================================
-- Behavior
-- =============================================================================

config.scrollback_lines = 10000
config.enable_scroll_bar = false
config.window_close_confirmation = "NeverPrompt"
config.check_for_updates = false

-- =============================================================================
-- Keybindings (SECONDARY Layer)
-- =============================================================================

config.keys = {
  -- ─────────────────────────────────────────────────────────────────────────
  -- Tab Management
  -- ─────────────────────────────────────────────────────────────────────────
  { key = "t", mods = SECONDARY, action = act.SpawnTab("CurrentPaneDomain") },
  { key = "w", mods = SECONDARY, action = act.CloseCurrentTab({ confirm = true }) },
  { key = "x", mods = SECONDARY, action = act.CloseCurrentPane({ confirm = false }) }, -- Added from newconfigs
  { key = "[", mods = SECONDARY, action = act.ActivateTabRelative(-1) },
  { key = "]", mods = SECONDARY, action = act.ActivateTabRelative(1) },

  -- ─────────────────────────────────────────────────────────────────────────
  -- Pane Splitting
  -- ─────────────────────────────────────────────────────────────────────────
  { key = "\\", mods = SECONDARY, action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "-", mods = SECONDARY, action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = SECONDARY, action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) }, -- Added from newconfigs
  { key = "D", mods = SECONDARY .. "|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) }, -- Added from newconfigs

  -- ─────────────────────────────────────────────────────────────────────────
  -- Pane Navigation (Vim-style)
  -- ─────────────────────────────────────────────────────────────────────────
  { key = "h", mods = SECONDARY, action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = SECONDARY, action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = SECONDARY, action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = SECONDARY, action = act.ActivatePaneDirection("Right") },

  -- ─────────────────────────────────────────────────────────────────────────
  -- Pane Resizing (TERTIARY + hjkl)
  -- ─────────────────────────────────────────────────────────────────────────
  { key = "h", mods = TERTIARY, action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "j", mods = TERTIARY, action = act.AdjustPaneSize({ "Down", 5 }) },
  { key = "k", mods = TERTIARY, action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "l", mods = TERTIARY, action = act.AdjustPaneSize({ "Right", 5 }) },
  { key = "H", mods = SECONDARY .. "|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) }, -- Alias with H/J/K/L
  { key = "J", mods = SECONDARY .. "|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
  { key = "K", mods = SECONDARY .. "|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "L", mods = SECONDARY .. "|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },

  -- ─────────────────────────────────────────────────────────────────────────
  -- Utilities
  -- ─────────────────────────────────────────────────────────────────────────
  { key = "z", mods = SECONDARY, action = act.TogglePaneZoomState },
  { key = "f", mods = SECONDARY, action = act.Search({ CaseInSensitiveString = "" }) },
  { key = "r", mods = SECONDARY, action = act.ReloadConfiguration },
  { key = "p", mods = SECONDARY, action = act.ActivateCommandPalette }, -- Added from newconfigs

  { key = "c", mods = SECONDARY, action = act.CopyTo("Clipboard") },
  { key = "v", mods = SECONDARY, action = act.PasteFrom("Clipboard") },

  { key = "c", mods = SECONDARY .. "|SHIFT", action = act.ActivateCopyMode }, -- Added from newconfigs
  { key = "Space", mods = SECONDARY, action = act.QuickSelect }, -- Added from newconfigs

  -- Scroll
  { key = "u", mods = SECONDARY, action = act.ScrollByPage(-0.5) },
  { key = "d", mods = SECONDARY, action = act.ScrollByPage(0.5) },

  -- Font size
  { key = "=", mods = SECONDARY, action = act.IncreaseFontSize },
  { key = "+", mods = SECONDARY .. "|SHIFT", action = act.IncreaseFontSize },
  { key = "-", mods = SECONDARY .. "|CTRL", action = act.DecreaseFontSize },
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

-- Keep default keybindings for system copy/paste
config.disable_default_key_bindings = false

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
