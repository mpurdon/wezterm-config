local wezterm = require("wezterm")

local M = {}

function M.scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Catppuccin Mocha"
  else
    return "Catppuccin Latte"
  end
end

function M.apply(config)
  local appearance = wezterm.gui and wezterm.gui.get_appearance() or "Dark"
  config.color_scheme = M.scheme_for_appearance(appearance)

  config.window_background_opacity = 0.95
  config.macos_window_background_blur = 20

  config.inactive_pane_hsb = {
    saturation = 0.85,
    brightness = 0.7,
  }
end

return M
