local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action
local chrome = require("config.colors").chrome
local workspaces = require("config.workspaces")

local M = {}

local basename = workspaces.basename

-- Workspace name -> project directory name. Built once; the project list is static.
local workspace_projects = {}
for _, project in pairs(workspaces.projects) do
  workspace_projects[project.workspace] = basename(project.cwd)
end

-- cwd -> repo name, or false for directories known not to be in a repo.
local repo_name_cache = {}

local function uri_file_path(uri)
  if not uri then
    return ""
  end

  if type(uri) == "table" then
    return uri.file_path or uri.path or ""
  end

  local path = tostring(uri)
  path = path:gsub("^file://[^/]*", "")
  path = path:gsub("%%(%x%x)", function(hex)
    return string.char(tonumber(hex, 16))
  end)
  return path
end

local function pane_cwd(pane)
  local cwd_uri = pane and pane.current_working_dir
  return uri_file_path(cwd_uri)
end

local function git_repo_name(cwd)
  if cwd == "" then
    return nil
  end

  if repo_name_cache[cwd] == nil then
    local success, stdout = wezterm.run_child_process({
      "git",
      "-C",
      cwd,
      "rev-parse",
      "--show-toplevel",
    })

    if success and stdout and stdout ~= "" then
      repo_name_cache[cwd] = basename(stdout:gsub("%s+$", ""))
    else
      repo_name_cache[cwd] = false
    end
  end

  return repo_name_cache[cwd] or nil
end

local function project_for_workspace(workspace)
  if not workspace or workspace == "main" or workspace == "default" then
    return nil
  end
  return workspace_projects[workspace] or workspace
end

local function cwd_name(pane)
  local cwd = pane_cwd(pane)
  return cwd ~= "" and basename(cwd) or nil
end

local function current_project(pane, workspace)
  return project_for_workspace(workspace) or git_repo_name(pane_cwd(pane)) or cwd_name(pane)
end

local function strip_shell_prefix(title)
  return title:gsub("^shell:%s*", "")
end

local function tab_activity(tab)
  if tab.tab_title and #tab.tab_title > 0 then
    return strip_shell_prefix(tab.tab_title)
  end

  local pane_title = tab.active_pane and tab.active_pane.title
  if pane_title and #pane_title > 0 then
    return strip_shell_prefix(pane_title)
  end

  local process = tab.active_pane and tab.active_pane.foreground_process_name
  return (process and process:match("([^/]+)$")) or ""
end

function M.setup()
  -- Status: current project on the left, workspace + time on the right
  wezterm.on("update-status", function(window, pane)
    local workspace = window:active_workspace()
    local project = current_project(pane, workspace)
    local date = wezterm.strftime("%H:%M")

    window:set_left_status(project and wezterm.format({
      { Background = { Color = chrome.bg } },
      { Foreground = { Color = chrome.fg } },
      { Attribute = { Intensity = "Bold" } },
      { Text = "  " .. project .. "  " },
    }) or "")

    window:set_right_status(wezterm.format({
      { Attribute = { Intensity = "Bold" } },
      { Foreground = { Color = chrome.fg_dim } },
      { Text = " 󱂬 " .. workspace },
      { Text = "  " },
      { Foreground = { Color = chrome.fg } },
      { Text = date },
      { Text = "  " },
    }))
  end)

  -- Dynamic window title: repo/project only. Tab activity belongs in the tab bar.
  wezterm.on("format-window-title", function(_tab, pane, _tabs, _panes, _config, _hover, _max_width)
    return cwd_name(pane) or "WezTerm"
  end)

  -- Tab title: index + activity title, with process name as the last fallback
  wezterm.on("format-tab-title", function(tab, _tabs, _panes, _config, _hover, _max_width)
    local index = tab.tab_index + 1
    return string.format(" %d: %s ", index, tab_activity(tab))
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
