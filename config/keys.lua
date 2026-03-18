local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

function M.apply(config)
  config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1200 }

  config.keys = {
    -- Global convenience
    { key = "r", mods = "CMD|SHIFT", action = act.ReloadConfiguration },
    { key = "P", mods = "CMD|SHIFT", action = act.ActivateCommandPalette },
    { key = "Enter", mods = "ALT", action = act.ToggleFullScreen },

    -- macOS-style splits
    { key = "d", mods = "CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "D", mods = "CMD|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

    -- tmux-style splits with leader
    { key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

    -- Pane navigation
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

    -- Pane resize
    { key = "H", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
    { key = "J", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Down", 3 }) },
    { key = "K", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Up", 3 }) },
    { key = "L", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },

    -- Pane management
    { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

    -- Tabs
    { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "n", mods = "LEADER", action = act.SpawnWindow },
    { key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
    { key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },

    -- Tab navigation by number
    { key = "1", mods = "LEADER", action = act.ActivateTab(0) },
    { key = "2", mods = "LEADER", action = act.ActivateTab(1) },
    { key = "3", mods = "LEADER", action = act.ActivateTab(2) },
    { key = "4", mods = "LEADER", action = act.ActivateTab(3) },
    { key = "5", mods = "LEADER", action = act.ActivateTab(4) },
    { key = "6", mods = "LEADER", action = act.ActivateTab(5) },
    { key = "7", mods = "LEADER", action = act.ActivateTab(6) },
    { key = "8", mods = "LEADER", action = act.ActivateTab(7) },
    { key = "9", mods = "LEADER", action = act.ActivateTab(8) },

    -- Rename tab
    {
      key = "r",
      mods = "LEADER",
      action = act.PromptInputLine({
        description = "Tab name:",
        action = wezterm.action_callback(function(window, _pane, line)
          if line then
            window:active_tab():set_title(line)
          end
        end),
      }),
    },

    -- Workspaces
    { key = "w", mods = "LEADER", action = act.EmitEvent("workspace-switcher") },
    { key = "W", mods = "LEADER|SHIFT", action = act.EmitEvent("workspace-new") },
    { key = ",", mods = "LEADER", action = act.SwitchWorkspaceRelative(-1) },
    { key = ".", mods = "LEADER", action = act.SwitchWorkspaceRelative(1) },
    { key = "p", mods = "LEADER", action = act.EmitEvent("project-picker") },

    -- Quick workspace hotkeys
    {
      key = "m",
      mods = "LEADER",
      action = act.SwitchToWorkspace({
        name = "main",
        spawn = { cwd = wezterm.home_dir },
      }),
    },

    -- Search / copy mode / quick select
    { key = "f", mods = "LEADER", action = act.Search({ CaseInSensitiveString = "" }) },
    { key = "[", mods = "CMD", action = act.ActivateCopyMode },
    { key = "Space", mods = "LEADER", action = act.QuickSelect },

    -- Font size
    { key = "=", mods = "CMD", action = act.IncreaseFontSize },
    { key = "-", mods = "CMD", action = act.DecreaseFontSize },
    { key = "0", mods = "CMD", action = act.ResetFontSize },

    -- Pass through CTRL-A when pressed twice
    { key = "a", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) },
  }

  -- Right-click paste
  config.mouse_bindings = {
    {
      event = { Down = { streak = 1, button = "Right" } },
      mods = "NONE",
      action = act.PasteFrom("Clipboard"),
    },
  }
end

return M
