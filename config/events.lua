local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action
local colors = require("config.colors")
local workspaces = require("config.workspaces")

local M = {}

function M.setup()
  -- Dynamically switch color scheme when system appearance changes
  wezterm.on("window-config-reloaded", function(window, _pane)
    local overrides = window:get_config_overrides() or {}
    local appearance = window:get_appearance()
    local scheme = colors.scheme_for_appearance(appearance)

    if overrides.color_scheme ~= scheme then
      overrides.color_scheme = scheme
      window:set_config_overrides(overrides)
    end
  end)

  -- Right status: workspace name + time
  wezterm.on("update-right-status", function(window, _pane)
    local workspace = window:active_workspace()
    local date = wezterm.strftime("%H:%M")

    window:set_right_status(wezterm.format({
      { Attribute = { Intensity = "Bold" } },
      { Foreground = { Color = "#6c7086" } },
      { Text = " 󱂬 " .. workspace },
      { Text = "  " },
      { Foreground = { Color = "#cdd6f4" } },
      { Text = date },
      { Text = "  " },
    }))
  end)

  -- Dynamic window title: workspace — cwd
  wezterm.on("format-window-title", function(tab, pane, _tabs, _panes, _config, _hover, _max_width)
    local cwd_uri = pane:get_current_working_dir()
    local cwd = ""
    if cwd_uri then
      cwd = cwd_uri.file_path or cwd_uri.path or ""
    end
    local name = cwd ~= "" and workspaces.basename(cwd) or "shell"
    local ws = tab:get_workspace()
    return string.format("%s — %s", ws, name)
  end)

  -- Tab title: index + process name or custom title
  wezterm.on("format-tab-title", function(tab, _tabs, _panes, _config, _hover, _max_width)
    local title = tab.tab_title
    if not title or #title == 0 then
      title = tab.active_pane.foreground_process_name:match("([^/]+)$") or "shell"
    end
    local index = tab.tab_index + 1
    return string.format(" %d: %s ", index, title)
  end)

  -- Workspace switcher (fuzzy)
  wezterm.on("workspace-switcher", function(window, pane)
    window:perform_action(
      act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
      pane
    )
  end)

  -- Create a new named workspace
  wezterm.on("workspace-new", function(window, pane)
    window:perform_action(
      act.PromptInputLine({
        description = "Name for new workspace:",
        action = wezterm.action_callback(function(_win, _p, line)
          if not line or line == "" then
            return
          end
          workspaces.switch_or_create(line)
        end),
      }),
      pane
    )
  end)

  -- Project picker: launch a project workspace with predefined layout
  wezterm.on("project-picker", function(window, pane)
    local choices = workspaces.project_choices()
    if #choices == 0 then
      -- No projects defined — show a hint
      window:perform_action(
        act.PromptInputLine({
          description = "No projects defined. Add them in config/workspaces.lua",
          action = wezterm.action_callback(function() end),
        }),
        pane
      )
      return
    end

    window:perform_action(
      act.InputSelector({
        title = "Launch project workspace",
        choices = choices,
        action = wezterm.action_callback(function(_win, _p, id, _label)
          if not id then
            return
          end
          local project = workspaces.projects[id]
          if not project then
            return
          end
          if workspaces.workspace_exists(project.workspace) then
            mux.set_active_workspace(project.workspace)
          else
            workspaces.launch_project_layout(project)
          end
        end),
      }),
      pane
    )
  end)

  -- Startup: open a clean "main" workspace
  wezterm.on("gui-startup", function(cmd)
    if cmd then
      return
    end
    local _tab, _pane, _window = mux.spawn_window({
      workspace = "main",
      cwd = wezterm.home_dir,
    })
    mux.set_active_workspace("main")
  end)
end

return M
