local wezterm = require("wezterm")

local M = {}

function M.apply(config)
  config.font = wezterm.font_with_fallback({
    { family = "JetBrains Mono", weight = "Medium" },
    { family = "Symbols Nerd Font Mono" },
    "Apple Color Emoji",
  })
  config.font_size = 14.0
  config.line_height = 1.2
  config.cell_width = 1.0

  config.font_rules = {
    {
      intensity = "Bold",
      italic = false,
      font = wezterm.font_with_fallback({
        { family = "JetBrains Mono", weight = "Bold" },
      }),
    },
    {
      intensity = "Bold",
      italic = true,
      font = wezterm.font_with_fallback({
        { family = "JetBrains Mono", weight = "Bold", italic = true },
      }),
    },
  }

  -- Rendering
  config.freetype_load_target = "Light"
  config.freetype_render_target = "HorizontalLcd"
end

return M
