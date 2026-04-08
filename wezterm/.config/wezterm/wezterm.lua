local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Color scheme: Solarized Light to match Ghostty's iTerm2 Solarized Light
config.color_scheme = "Solarized (light) (terminal.sexy)"

-- Override with exact Solarized Light values for consistency
config.colors = {
  foreground = "#657b83",
  background = "#fdf6e3",
  cursor_bg = "#657b83",
  cursor_fg = "#fdf6e3",
  cursor_border = "#657b83",
  selection_bg = "#eee8d5",
  selection_fg = "#657b83",

  ansi = {
    "#073642", -- black
    "#dc322f", -- red
    "#859900", -- green
    "#b58900", -- yellow
    "#268bd2", -- blue
    "#d33682", -- magenta
    "#2aa198", -- cyan
    "#eee8d5", -- white
  },
  brights = {
    "#002b36", -- bright black
    "#cb4b16", -- bright red
    "#586e75", -- bright green
    "#657b83", -- bright yellow
    "#839496", -- bright blue
    "#6c71c4", -- bright magenta
    "#93a1a1", -- bright cyan
    "#fdf6e3", -- bright white
  },
}

-- Font: match Ghostty config (JetBrainsMono Nerd Font + Sarasa Mono SC fallback)
config.font = wezterm.font_with_fallback({
  {
    family = "JetBrainsMono Nerd Font",
    harfbuzz_features = { "liga=1", "calt=1" },
  },
  { family = "Sarasa Mono SC" },
})
config.font_size = 14.0

-- Window: match Ghostty padding and opacity
config.window_padding = {
  left = 14,
  right = 14,
  top = 12,
  bottom = 12,
}
config.window_background_opacity = 0.96
config.inactive_pane_hsb = {
  brightness = 0.85,
}

-- Cursor: block, no blink (match Ghostty)
config.default_cursor_style = "SteadyBlock"

-- Behavior
config.selection_word_boundary = " \t\n{}[]()\"'`,;:@"
config.scrollback_lines = 10000
config.hide_mouse_cursor_when_typing = true
config.window_close_confirmation = "NeverPrompt"

-- Default shell: PowerShell 7
config.default_prog = { "pwsh", "-NoLogo" }

-- Tab bar styling
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

-- Keybindings similar to Ghostty splits/tabs (adapted for Windows with ALT)
local act = wezterm.action
config.keys = {
  -- Splits
  { key = "d", mods = "ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = "ALT|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "w", mods = "ALT", action = act.CloseCurrentPane({ confirm = false }) },
  -- Navigate splits
  { key = "LeftArrow", mods = "ALT|CTRL", action = act.ActivatePaneDirection("Left") },
  { key = "RightArrow", mods = "ALT|CTRL", action = act.ActivatePaneDirection("Right") },
  { key = "UpArrow", mods = "ALT|CTRL", action = act.ActivatePaneDirection("Up") },
  { key = "DownArrow", mods = "ALT|CTRL", action = act.ActivatePaneDirection("Down") },
  -- Tabs
  { key = "t", mods = "ALT", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "LeftArrow", mods = "ALT|SHIFT", action = act.ActivateTabRelative(-1) },
  { key = "RightArrow", mods = "ALT|SHIFT", action = act.ActivateTabRelative(1) },
  -- Font size
  { key = "=", mods = "CTRL", action = act.IncreaseFontSize },
  { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
  { key = "0", mods = "CTRL", action = act.ResetFontSize },
}

return config
