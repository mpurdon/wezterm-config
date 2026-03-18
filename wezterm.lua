local wezterm = require("wezterm")
local config = wezterm.config_builder()

require("config.options").apply(config)
require("config.fonts").apply(config)
require("config.colors").apply(config)
require("config.keys").apply(config)
require("config.tabs").apply(config)
require("config.workspaces").apply(config)
require("config.events").setup()

return config
