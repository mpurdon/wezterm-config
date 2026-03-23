local wezterm = require("wezterm")
local mux = wezterm.mux

local home = wezterm.home_dir

local M = {}

-- ------------------------------------------------------------
-- Project definitions
-- Each project gets a workspace with a layout based on whether cwd is a git repo:
--   Git repo:     left (editor) | top-right (server) | bottom-right (sidecar)
--   Non-git repo: single pane (editor only)
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
  local _tab, pane, _window = mux.spawn_window({
    workspace = project.workspace,
    cwd = project.cwd,
  })

  -- Main pane: editor
  if project.editor then
    pane:send_text(table.concat(project.editor, " ") .. "\n")
  end

  -- Git repos get a split layout; non-git repos stay single pane
  if is_git_dir(project.cwd) then
    -- Right pane: dev server
    local right = pane:split({
      direction = "Right",
      size = 0.34,
      cwd = project.cwd,
    })
    if project.server then
      right:send_text(table.concat(project.server, " ") .. "\n")
    end

    -- Bottom-right pane: sidecar
    local bottom_right = right:split({
      direction = "Bottom",
      size = 0.40,
      cwd = project.cwd,
    })
    if project.sidecar then
      bottom_right:send_text(table.concat(project.sidecar, " ") .. "\n")
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
