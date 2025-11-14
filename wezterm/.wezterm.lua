-- ~/.wezterm.lua
-- Unified Cross-Platform Terminal Config (macOS version)
-- CONFLICT-FREE: Uses Ctrl for terminal navigation, Cmd stays with yabai

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- OS detection for cross-platform compatibility
local function is_darwin()
	return wezterm.target_triple:find("darwin") ~= nil
end

-- SECONDARY modifier: Alt on macOS, Super on Linux
-- No conflict: skhd only uses Alt+Shift for resizing, leaving Alt alone free
local secondary_mod = (is_darwin()) and "ALT" or "SUPER"

-- All WezTerm hotkeys use the SECONDARY (Alt/Super) layer
-- This keeps them separate from global window management (Cmd)
config.keys = {
	-- Tab Management
	{
		key = "t",
		mods = secondary_mod,
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "w",
		mods = secondary_mod,
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},

	-- Pane Splitting
	{
		key = "-",
		mods = secondary_mod,
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "\\",
		mods = secondary_mod,
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},

	-- Pane Navigation (vim-style)
	-- Using Alt/Super instead of Cmd to avoid conflict with yabai focus commands
	{
		key = "h",
		mods = secondary_mod,
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = secondary_mod,
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = secondary_mod,
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = secondary_mod,
		action = wezterm.action.ActivatePaneDirection("Right"),
	},

	-- Pane Resizing (Alt/Super + Shift for fine control)
	{
		key = "h",
		mods = secondary_mod .. "|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "j",
		mods = secondary_mod .. "|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "k",
		mods = secondary_mod .. "|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "l",
		mods = secondary_mod .. "|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},

	-- Tab Navigation (Alt/Super + Number)
	{
		key = "1",
		mods = secondary_mod,
		action = wezterm.action.ActivateTab(0),
	},
	{
		key = "2",
		mods = secondary_mod,
		action = wezterm.action.ActivateTab(1),
	},
	{
		key = "3",
		mods = secondary_mod,
		action = wezterm.action.ActivateTab(2),
	},
	{
		key = "4",
		mods = secondary_mod,
		action = wezterm.action.ActivateTab(3),
	},
	{
		key = "5",
		mods = secondary_mod,
		action = wezterm.action.ActivateTab(4),
	},
	{
		key = "6",
		mods = secondary_mod,
		action = wezterm.action.ActivateTab(5),
	},
	{
		key = "7",
		mods = secondary_mod,
		action = wezterm.action.ActivateTab(6),
	},
	{
		key = "8",
		mods = secondary_mod,
		action = wezterm.action.ActivateTab(7),
	},
	{
		key = "9",
		mods = secondary_mod,
		action = wezterm.action.ActivateTab(8),
	},
}

-- Keep default keybindings enabled (for system copy/paste, etc.)
config.disable_default_key_bindings = false

-- Visual settings for better usability
config.font_size = 13.0
config.line_height = 1.2
config.window_padding = {
	left = 8,
	right = 8,
	top = 8,
	bottom = 8,
}

-- Tab bar configuration
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false

return config
