local wezterm = require("wezterm")

local M = {}

-- Per-window color scheme cycling. The chrome (tab bar, status) is not themed
-- by these — see colors.lua.
local schemes = {
  "Catppuccin Mocha",
  "Catppuccin Latte",
  "Tokyo Night",
  "Gruvbox Dark",
  "Dracula",
  "OneHalfDark",
}

-- Must run after keys.lua, which assigns config.keys wholesale.
function M.apply(config)
  config.keys = config.keys or {}

  table.insert(config.keys, {
    key = "T",
    mods = "LEADER|SHIFT",
    action = wezterm.action.EmitEvent("cycle-window-color-scheme"),
  })

  table.insert(config.keys, {
    key = "Backspace",
    mods = "LEADER",
    action = wezterm.action.EmitEvent("reset-window-color-scheme"),
  })
end

function M.setup()
  wezterm.on("cycle-window-color-scheme", function(window, _pane)
    local overrides = window:get_config_overrides() or {}
    local current = overrides.color_scheme or window:effective_config().color_scheme

    local next_index = 1
    for i, scheme in ipairs(schemes) do
      if scheme == current then
        next_index = i % #schemes + 1
        break
      end
    end

    overrides.color_scheme = schemes[next_index]
    window:set_config_overrides(overrides)
  end)

  wezterm.on("reset-window-color-scheme", function(window, _pane)
    local overrides = window:get_config_overrides() or {}
    overrides.color_scheme = nil
    window:set_config_overrides(overrides)
  end)
end

return M
