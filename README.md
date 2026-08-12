# WezTerm Configuration

A modular WezTerm configuration with tmux-style keybindings, project workspaces, and per-window theme cycling.

## File Structure

```
~/.config/wezterm/
├── wezterm.lua          # Entry point — loads all modules
└── config/
    ├── options.lua      # Window, shell, cursor, scrollback, performance
    ├── keys.lua         # Leader key, keybindings, mouse bindings
    ├── fonts.lua        # Font family, size, rendering rules
    ├── colors.lua       # Color scheme, chrome palette, opacity, pane dimming
    ├── themes.lua       # Per-window color scheme cycling
    ├── tabs.lua         # Tab bar appearance and colors
    ├── projects_example.lua  # Project definition template (committed)
    ├── projects.lua     # Your project definitions (gitignored)
    ├── workspaces.lua   # Workspace helpers, project launcher, launch menu
    └── events.lua       # Event handlers (startup, status bar, titles, pickers)
```

## Features

### Appearance
- **Catppuccin Mocha** by default; cycle through alternate schemes per window with `Ctrl-A` `Shift+T`
- Transparent background (95% opacity) with macOS background blur
- Retro-style tab bar pinned to the bottom, always visible
- Tab bar and status line share a fixed chrome palette (`colors.lua`), so they stay put while cycling themes
- Inactive panes are dimmed (reduced saturation and brightness)
- Native title bar with resize handles
- Window title: the current project (workspace project → git repo → directory name)
- Left status: current project. Right status: workspace icon + clock

### Fonts
- **Comic Code Ligatures** (Medium) as the primary font — programming ligatures enabled
- **Symbols Nerd Font Mono** for icon fallback
- **Apple Color Emoji** for emoji
- Explicit bold and bold-italic font rules
- LCD subpixel rendering with light hinting
- 14pt, 1.2 line height

### Shell & General
- Default shell: `/bin/zsh -l`
- 10,000 line scrollback
- Blinking bar cursor (500ms rate)
- Audible bell disabled
- 120 max FPS, 60 animation FPS
- Auto-reload config on save
- No update checks, no missing glyph warnings

### Project Workspaces
Define projects in `config/projects.lua`. That file is **gitignored** so local paths and
private project names stay out of the repo — copy `config/projects_example.lua` to
`config/projects.lua` to get started. If it is missing, the example is used as a fallback
and the project picker simply comes up empty.

Each project gets its own workspace. With the simple format the pane layout is
**dynamic** — it detects whether the project directory is a git repository:

**Git repo** — 3-pane split:

```
┌──────────────────┬──────────┐
│                  │  Server  │
│                  │  (34%)   │
│     Editor       ├──────────┤
│   (66% width)    │ Sidecar  │
│                  │  (40%)   │
└──────────────────┴──────────┘
```

**Non-git directory** — single pane (editor only)

Example project definition:

```lua
myapp = {
  label = "My App",
  workspace = "myapp",
  cwd = home .. "/code/myapp",
  editor = { "nvim", "." },
  server = { "pnpm", "dev" },
  sidecar = { "git", "status" },
},
```

For full control, use `layout` instead of `editor`/`server`/`sidecar` — an array of pane
definitions with `cmd`, `direction`, `size`, `cwd`, and `split_from`. See the comments at
the top of `config/projects.lua`.

### Launch Menu
Available via the command palette or launcher:
- **Zsh** — login shell
- **Bash** — login shell
- **Config** — opens in `~/.config`

## Keybindings

The **leader key** is `Ctrl-A` (1200ms timeout). Pressing the leader activates a modal layer where the next keypress triggers an action.

### Global (no leader required)

| Keys | Action |
|---|---|
| `Cmd+Shift+R` | Reload configuration |
| `Cmd+Shift+P` | Command palette |
| `Alt+Enter` | Toggle fullscreen |
| `Cmd+D` | Split pane horizontally |
| `Cmd+Shift+D` | Split pane vertically |
| `Cmd+[` | Enter copy mode |
| `Cmd+=` | Increase font size |
| `Cmd+-` | Decrease font size |
| `Cmd+0` | Reset font size |
| Right-click | Paste from clipboard |

### Pane Management (leader)

| Keys | Action |
|---|---|
| `Ctrl-A` `\` | Split horizontal |
| `Ctrl-A` `-` | Split vertical |
| `Ctrl-A` `h` | Focus pane left |
| `Ctrl-A` `j` | Focus pane down |
| `Ctrl-A` `k` | Focus pane up |
| `Ctrl-A` `l` | Focus pane right |
| `Ctrl-A` `Shift+H` | Resize pane left (5 cells) |
| `Ctrl-A` `Shift+J` | Resize pane down (3 cells) |
| `Ctrl-A` `Shift+K` | Resize pane up (3 cells) |
| `Ctrl-A` `Shift+L` | Resize pane right (5 cells) |
| `Ctrl-A` `x` | Close current pane |
| `Ctrl-A` `z` | Toggle pane zoom |

### Tabs (leader)

| Keys | Action |
|---|---|
| `Ctrl-A` `c` | New tab |
| `Ctrl-A` `n` | New window |
| `Ctrl-A` `[` | Previous tab |
| `Ctrl-A` `]` | Next tab |
| `Ctrl-A` `1-9` | Jump to tab by number |
| `Ctrl-A` `r` | Rename current tab |

### Workspaces (leader)

| Keys | Action |
|---|---|
| `Ctrl-A` `w` | Fuzzy workspace switcher |
| `Ctrl-A` `Shift+W` | Create new named workspace |
| `Ctrl-A` `,` | Previous workspace |
| `Ctrl-A` `.` | Next workspace |
| `Ctrl-A` `p` | Project picker (launches project layout) |
| `Ctrl-A` `m` | Jump to "main" workspace |

### Search & Selection (leader)

| Keys | Action |
|---|---|
| `Ctrl-A` `f` | Search (case-insensitive) |
| `Ctrl-A` `Space` | Quick select (URLs, hashes, paths) |

### Theme (leader)

| Keys | Action |
|---|---|
| `Ctrl-A` `Shift+T` | Cycle color scheme for this window |
| `Ctrl-A` `Backspace` | Reset this window to the default scheme |

### Pass-through

| Keys | Action |
|---|---|
| `Ctrl-A` `Ctrl-A` | Send literal `Ctrl-A` to the terminal |

## Requirements

- [WezTerm](https://wezfurlong.org/wezterm/) (nightly or recent stable)
- [Comic Code Ligatures](https://tosche.net/fonts/comic-code) font
- [Symbols Nerd Font Mono](https://www.nerdfonts.com/) for icons
