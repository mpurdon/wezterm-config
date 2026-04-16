local M = {}

function M.apply(config)
	-- Window
	config.window_decorations = "RESIZE"
	config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
	config.initial_cols = 120
	config.initial_rows = 36
	config.adjust_window_size_when_changing_font_size = false
	config.window_close_confirmation = "NeverPrompt"
	config.native_macos_fullscreen_mode = false

	-- Shell
	config.default_prog = { "/bin/zsh", "-l" }
	config.exit_behavior = "CloseOnCleanExit"

	-- Scrollback
	config.scrollback_lines = 15000

	-- Cursor
	config.default_cursor_style = "BlinkingBar"
	config.cursor_blink_rate = 500
	config.cursor_blink_ease_in = "Constant"
	config.cursor_blink_ease_out = "Constant"

	-- Bell
	config.audible_bell = "Disabled"

	-- General
	config.automatically_reload_config = true
	config.max_fps = 120
	config.animation_fps = 60
	config.check_for_updates = false
	config.warn_about_missing_glyphs = false
end

return M
