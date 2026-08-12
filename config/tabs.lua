local chrome = require("config.colors").chrome

local M = {}

function M.apply(config)
  config.enable_tab_bar = true
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true
  config.show_tab_index_in_tab_bar = true
  config.hide_tab_bar_if_only_one_tab = false
  config.show_new_tab_button_in_tab_bar = false
  config.tab_max_width = 32
  config.switch_to_last_active_tab_when_closing_tab = true

  config.colors = config.colors or {}
  config.colors.tab_bar = {
    background = chrome.bg,
    active_tab = {
      bg_color = chrome.bg_active,
      fg_color = chrome.fg,
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = chrome.bg,
      fg_color = chrome.fg_dim,
    },
    inactive_tab_hover = {
      bg_color = chrome.bg_hover,
      fg_color = chrome.fg,
    },
    new_tab = {
      bg_color = chrome.bg,
      fg_color = chrome.fg_dim,
    },
    new_tab_hover = {
      bg_color = chrome.bg_hover,
      fg_color = chrome.fg,
    },
  }
end

return M
