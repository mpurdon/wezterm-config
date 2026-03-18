local wezterm = require("wezterm")
local mux = wezterm.mux

local home = wezterm.home_dir

local M = {}

-- ------------------------------------------------------------
-- Project definitions
-- Each project gets a workspace with a predefined pane layout:
--   - Main pane (left): editor
--   - Right pane: dev server
--   - Bottom-left pane: git / tests / sidecar
-- Add your own projects here.
-- ------------------------------------------------------------

M.projects = {
  -- Example project (uncomment and customise):
  -- myapp = {
  --   label = "My App",
  --   workspace = "myapp",
  --   cwd = home .. "/code/myapp",
  --   editor = { "nvim", "." },
  --   server = { "pnpm", "dev" },
  --   sidecar = { "git", "status" },
  -- },
}

-- ------------------------------------------------------------
-- Helpers
-- ------------------------------------------------------------

local function basename(path)
  return path:match("([^/]+)$") or path
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
  local _tab, pane, _window = mux.spawn_window({
    workspace = project.workspace,
    cwd = project.cwd,
  })

  -- Main pane: editor
  if project.editor then
    pane:send_text(table.concat(project.editor, " ") .. "\n")
  end

  -- Right pane: dev server
  local right = pane:split({
    direction = "Right",
    size = 0.34,
    cwd = project.cwd,
  })
  if project.server then
    right:send_text(table.concat(project.server, " ") .. "\n")
  end

  -- Bottom-left pane: sidecar
  local bottom = pane:split({
    direction = "Bottom",
    size = 0.28,
    cwd = project.cwd,
  })
  if project.sidecar then
    bottom:send_text(table.concat(project.sidecar, " ") .. "\n")
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

function M.basename(path)
  return basename(path)
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
