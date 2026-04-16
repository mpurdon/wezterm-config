local wezterm = require("wezterm")
local home = wezterm.home_dir

-- ------------------------------------------------------------
-- Project definitions
-- Each project gets a workspace with a predefined pane layout.
--
-- Simple format (auto-layout based on git repo detection):
--   editor, server, sidecar fields → git repo gets 3-pane split, non-git gets single pane
--
-- Custom layout format:
--   layout = array of pane definitions, first entry is the main pane.
--   Each subsequent entry splits from the previous pane by default.
--     cmd        = command to run (optional)
--     direction  = "Right" | "Left" | "Top" | "Bottom" (default "Right")
--     size       = fraction of parent pane (default 0.5)
--     cwd        = override cwd for this pane (default project.cwd)
--     split_from = 1-based index of pane to split from (default previous pane)
--
-- Add your own projects here.
-- ------------------------------------------------------------

return {
  -- Simple format example:
  -- myapp = {
  --   label = "My App",
  --   workspace = "myapp",
  --   cwd = home .. "/code/myapp",
  --   editor = { "nvim", "." },
  --   server = { "pnpm", "dev" },
  --   sidecar = { "git", "status" },
  -- },
  --
  -- Custom layout example:
  -- myapp = {
  --   label = "My App",
  --   workspace = "myapp",
  --   cwd = home .. "/code/myapp",
  --   layout = {
  --     { cmd = { "nvim", "." } },
  --     { cmd = { "pnpm", "dev" }, direction = "Right", size = 0.34 },
  --     { cmd = { "git", "status" }, direction = "Bottom", size = 0.40 },
  --   },
  -- },

  opc = {
    label = "OPC Platform",
    workspace = "opc",
    cwd = home .. "/Projects/opc",
    layout = {
      { cmd = { "claude" } },
      { cmd = { "bun", "run", "-F", "@opc/frontend", "dev" }, direction = "Right", size = 0.34 },
      { cmd = { "git", "status" }, direction = "Bottom", size = 0.40 },
    },
  },

  ["opc-site"] = {
    label = "OPC Site",
    workspace = "opc-site",
    cwd = home .. "/Projects/opc-site",
    editor = { "claude" },
    server = { "bun", "run", "dev" },
    sidecar = { "git", "status" },
  },

  ["core-services"] = {
    label = "Core Services",
    workspace = "core-services",
    cwd = home .. "/Projects/trajector/core-services-monorepo",
    editor = { "claude" },
    server = false,
    sidecar = { "git", "status" },
  },

  ["agentic-agents"] = {
    label = "Agentic Agents",
    workspace = "agentic-agents",
    cwd = home .. "/Projects/trajector/agentic-agents",
    editor = { "claude" },
    server = false,
    sidecar = { "git", "status" },
  },

  ["employee-portal"] = {
    label = "Employee Portal",
    workspace = "employee-portal",
    cwd = home .. "/Projects/trajector/employee-portal",
    editor = { "claude" },
    server = { "pnpm", "dev" },
    sidecar = { "git", "status" },
  },

  ["relevant-reviews"] = {
    label = "Relevant Reviews",
    workspace = "relevant-reviews",
    cwd = home .. "/Projects/relevant-reviews",
    editor = { "claude" },
    server = false,
    sidecar = { "git", "status" },
  },

  gitf = {
    label = "GiTF",
    workspace = "gitf",
    cwd = home .. "/Projects/gitf",
    editor = { "claude" },
    server = { "iex", "-S", "mix", "phx.server" },
    sidecar = { "git", "status" },
  },
}
