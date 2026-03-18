local wezterm = require("wezterm")

local M = {}

function M.apply(config)
  config.enable_tab_bar = true
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true
  config.show_tab_index_in_tab_bar = true
  config.hide_tab_bar_if_only_one_tab = true
  config.show_new_tab_button_in_tab_bar = false
  config.tab_max_width = 32
  config.switch_to_last_active_tab_when_closing_tab = true

  config.colors = config.colors or {}
  config.colors.tab_bar = {
    background = "rgba(0,0,0,0.6)",
    active_tab = {
      bg_color = "#1e1e2e",
      fg_color = "#cdd6f4",
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = "rgba(0,0,0,0.4)",
      fg_color = "#6c7086",
    },
    inactive_tab_hover = {
      bg_color = "#313244",
      fg_color = "#cdd6f4",
    },
    new_tab = {
      bg_color = "rgba(0,0,0,0.4)",
      fg_color = "#6c7086",
    },
    new_tab_hover = {
      bg_color = "#313244",
      fg_color = "#cdd6f4",
    },
  }
end

return M
