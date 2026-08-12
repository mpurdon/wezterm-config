local wezterm = require("wezterm")
local mux = wezterm.mux

local home = wezterm.home_dir

local M = {}

M.projects = require("config.projects")

-- ------------------------------------------------------------
-- Helpers
-- ------------------------------------------------------------

function M.basename(path)
  local trimmed = path:gsub("/+$", "")
  return trimmed:match("([^/]+)$") or trimmed
end

local function is_git_dir(path)
  local success, _, _ = wezterm.run_child_process({ "test", "-d", path .. "/.git" })
  return success
end

function M.workspace_exists(name)
  for _, ws in ipairs(mux.get_workspace_names()) do
    if ws == name then
      return true
    end
  end
  return false
end

function M.switch_or_create(name, cwd)
  if not M.workspace_exists(name) then
    mux.spawn_window({
      workspace = name,
      cwd = cwd or home,
    })
  end
  mux.set_active_workspace(name)
end

function M.launch_project_layout(project)
  local _tab, first_pane, _window = mux.spawn_window({
    workspace = project.workspace,
    cwd = project.cwd,
  })

  if project.layout then
    -- Custom layout: each entry defines a pane
    local panes = { first_pane }

    for i, entry in ipairs(project.layout) do
      if i == 1 then
        if entry.cmd then
          first_pane:send_text(table.concat(entry.cmd, " ") .. "\n")
        end
      else
        local parent = panes[entry.split_from or (i - 1)]
        local new_pane = parent:split({
          direction = entry.direction or "Right",
          size = entry.size or 0.5,
          cwd = entry.cwd or project.cwd,
        })
        if entry.cmd then
          new_pane:send_text(table.concat(entry.cmd, " ") .. "\n")
        end
        table.insert(panes, new_pane)
      end
    end
  else
    -- Simple format: editor | server | sidecar (auto-layout)
    if project.editor then
      first_pane:send_text(table.concat(project.editor, " ") .. "\n")
    end

    if is_git_dir(project.cwd) then
      local right = first_pane:split({
        direction = "Right",
        size = 0.34,
        cwd = project.cwd,
      })
      if project.server then
        right:send_text(table.concat(project.server, " ") .. "\n")
      end

      local bottom_right = right:split({
        direction = "Bottom",
        size = 0.40,
        cwd = project.cwd,
      })
      if project.sidecar then
        bottom_right:send_text(table.concat(project.sidecar, " ") .. "\n")
      end
    end
  end

  mux.set_active_workspace(project.workspace)
end

function M.project_choices()
  local choices = {}
  for id, p in pairs(M.projects) do
    table.insert(choices, {
      id = id,
      label = string.format("%s  —  %s", p.label, p.cwd),
    })
  end
  table.sort(choices, function(a, b)
    return a.label < b.label
  end)
  return choices
end

-- ------------------------------------------------------------
-- Config
-- ------------------------------------------------------------

function M.apply(config)
  config.default_workspace = "main"

  config.launch_menu = {
    { label = "Zsh", args = { "/bin/zsh", "-l" } },
    { label = "Bash", args = { "/bin/bash", "-l" } },
    { label = "Config", cwd = home .. "/.config" },
  }
end

return M
