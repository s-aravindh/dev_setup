local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.default_cursor_style = "SteadyBar"
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "RESIZE"
config.check_for_updates = false
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.font_size = 12.5
config.font = wezterm.font("Cascadia Code", { weight = "Bold" })
config.enable_tab_bar = true
config.window_padding = {
	left = 7,
	right = 0,
	top = 2,
	bottom = 0,
}
config.background = {
	{
		source = {
			File = "/Users/" .. os.getenv("USER") .. "/.config/wezterm/dark-desert.jpg",
		},
		hsb = {
			hue = 1.0,
			saturation = 1.02,
			brightness = 0.25,
		},
		-- attachment = { Parallax = 0.3 },
		-- width = "100%",
		-- height = "100%",
	},
	{
		source = {
			Color = "#282c35",
		},
		width = "100%",
		height = "100%",
		opacity = 0.35,
		-- opacity = 0.75,
		-- opacity = 1,
	},
}
-- config.window_background_opacity = 0.3
-- config.macos_window_background_blur = 20
config.keys = {
	-- ctrl+enter / shift+enter passthrough
	{ key = "Enter", mods = "CTRL", action = wezterm.action({ SendString = "\x1b[13;5u" }) },
	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b[13;2u" }) },

	-- word navigation
	-- SendKey is the alternative to SendString: sends a proper key event that
	-- the terminal translates to the right escape sequence based on its mode,
	-- rather than hardcoding raw bytes. e.g. SendKey META+b == SendString("\x1bb")
	{ key = "LeftArrow", mods = "OPT", action = wezterm.action.SendKey({ key = "b", mods = "ALT" }) },
	{ key = "RightArrow", mods = "OPT", action = wezterm.action.SendKey({ key = "f", mods = "ALT" }) },

	-- line navigation
	{ key = "LeftArrow", mods = "CMD", action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }) },
	{ key = "RightArrow", mods = "CMD", action = wezterm.action.SendKey({ key = "e", mods = "CTRL" }) },

	-- word deletion
	{ key = "Backspace", mods = "OPT", action = wezterm.action.SendKey({ key = "w", mods = "CTRL" }) },
	{ key = "Delete", mods = "OPT", action = wezterm.action.SendKey({ key = "d", mods = "ALT" }) },

	-- line deletion
	{ key = "Backspace", mods = "CMD", action = wezterm.action.SendKey({ key = "u", mods = "CTRL" }) },

	-- tabs
	{ key = "t", mods = "CMD", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{ key = "w", mods = "CMD", action = wezterm.action.CloseCurrentTab({ confirm = false }) },
	{ key = "1", mods = "CMD", action = wezterm.action.ActivateTab(0) },
	{ key = "2", mods = "CMD", action = wezterm.action.ActivateTab(1) },
	{ key = "3", mods = "CMD", action = wezterm.action.ActivateTab(2) },
	{ key = "4", mods = "CMD", action = wezterm.action.ActivateTab(3) },
	{ key = "5", mods = "CMD", action = wezterm.action.ActivateTab(4) },
	{ key = "6", mods = "CMD", action = wezterm.action.ActivateTab(5) },
	{ key = "7", mods = "CMD", action = wezterm.action.ActivateTab(6) },
	{ key = "8", mods = "CMD", action = wezterm.action.ActivateTab(7) },
	{ key = "9", mods = "CMD", action = wezterm.action.ActivateTab(8) },
	{
		key = "r",
		mods = "CMD|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = "Rename tab:",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

	-- panes: split, navigate, zoom, close
	{ key = "d", mods = "CMD", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "[", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "]", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "UpArrow", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "DownArrow", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "z", mods = "CMD", action = wezterm.action.TogglePaneZoomState },
	{ key = "x", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = true }) },

	-- font size
	{ key = "=", mods = "CMD", action = wezterm.action.IncreaseFontSize },
	{ key = "-", mods = "CMD", action = wezterm.action.DecreaseFontSize },
	{ key = "0", mods = "CMD", action = wezterm.action.ResetFontSize },

	-- scrollback
	{ key = "k", mods = "CMD", action = wezterm.action.ClearScrollback("ScrollbackOnly") },
	{ key = "PageUp", mods = "SHIFT", action = wezterm.action.ScrollByPage(-1) },
	{ key = "PageDown", mods = "SHIFT", action = wezterm.action.ScrollByPage(1) },

	-- copy mode: vi-style keyboard navigation & selection in terminal output
	{ key = "x", mods = "CTRL|SHIFT", action = wezterm.action.ActivateCopyMode },

	-- quick select: auto-highlights URLs, git hashes, file paths, IPs for one-key copy
	{ key = "Space", mods = "CMD|SHIFT", action = wezterm.action.QuickSelect },

	-- misc
	{ key = "f", mods = "CMD", action = wezterm.action.Search("CurrentSelectionOrEmptyString") },
	{ key = "p", mods = "CMD", action = wezterm.action.ActivateCommandPalette },
	{ key = "f", mods = "CMD|SHIFT", action = wezterm.action.ToggleFullScreen },
}

config.mouse_bindings = {
	-- right-click pastes from clipboard
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
	-- ctrl+click opens hyperlinks (alternative to the default opt+click)
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}
-- from: https://akos.ma/blog/adopting-wezterm/
config.hyperlink_rules = {
	-- Matches: a URL in parens: (URL)
	{
		regex = "\\((\\w+://\\S+)\\)",
		format = "$1",
		highlight = 1,
	},
	-- Matches: a URL in brackets: [URL]
	{
		regex = "\\[(\\w+://\\S+)\\]",
		format = "$1",
		highlight = 1,
	},
	-- Matches: a URL in curly braces: {URL}
	{
		regex = "\\{(\\w+://\\S+)\\}",
		format = "$1",
		highlight = 1,
	},
	-- Matches: a URL in angle brackets: <URL>
	{
		regex = "<(\\w+://\\S+)>",
		format = "$1",
		highlight = 1,
	},
	-- Then handle URLs not wrapped in brackets
	{
		regex = "[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)",
		format = "$1",
		highlight = 1,
	},
}
return config
