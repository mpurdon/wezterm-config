local M = {}

-- Terminal chrome (tab bar + status line). Deliberately independent of the
-- active color scheme so the chrome stays put while cycling themes.
M.chrome = {
  bg = "#1f1f28",
  bg_active = "#2a2a37",
  bg_hover = "#242430",
  fg = "#f2f2f2",
  fg_dim = "#9ca0aa",
}

function M.apply(config)
  config.color_scheme = "Catppuccin Mocha"

  config.window_background_opacity = 0.95
  config.macos_window_background_blur = 20

  config.inactive_pane_hsb = {
    saturation = 0.85,
    brightness = 0.7,
  }
end

return M
