local wezterm = require("wezterm")
local home = wezterm.home_dir

-- ------------------------------------------------------------
-- Project definitions — example / template
--
-- Copy this file to config/projects.lua and add your own projects there.
-- config/projects.lua is gitignored so local paths stay out of the repo;
-- this file is the fallback when it does not exist.
--
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
}
