local wezterm = require "wezterm" --[[@as Wezterm]]
local config = wezterm.config_builder()

local tabline = wezterm.plugin.require "https://github.com/michaelbrusegard/tabline.wez"
tabline.setup { options = { theme = "Tomorrow Night Bright" } }
tabline.apply_to_config(config)

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.default_prog = { "pwsh" }
  config.color_scheme = "Campbell (Gogh)"
  config.prefer_egl = true
  config.window_decorations = "TITLE | RESIZE"
end

config.font = wezterm.font "LigaHack Nerd Font"

config.launch_menu = {
  {
    label = "Powershell",
    args = { "pwsh" },
  },
}

config.leader = { key = ",", mods = "CTRL" }
config.keys = {
  {
    key = "c",
    mods = "CTRL",
    action = wezterm.action_callback(function(window, pane)
      local selection_text = window:get_selection_text_for_pane(pane)
      is_selection_active = string.len(selection_text) ~= 0
      if is_selection_active then
        window:perform_action(wezterm.action.CopyTo "ClipboardAndPrimarySelection", pane)
      else
        window:perform_action(wezterm.action.SendKey { key = "c", mods = "CTRL" }, pane)
      end
    end),
  },
  {
    key = "l",
    mods = "LEADER",
    action = wezterm.action.ShowLauncher,
  },
  {
    key = "s",
    mods = "LEADER",
    action = wezterm.action.QuickSelect,
  },
  {
    key = "c",
    mods = "LEADER",
    action = wezterm.action.ActivateCopyMode,
  },
  {
    key = "j",
    mods = "LEADER",
    action = wezterm.action.ActivateCommandPalette,
  },
  {
    key = "v",
    mods = "CTRL",
    action = wezterm.action.PasteFrom "Clipboard",
  },
  {
    key = "w",
    mods = "CTRL",
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
  {
    key = "t",
    mods = "CTRL",
    action = wezterm.action.SpawnTab "CurrentPaneDomain",
  },
}

config.tab_bar_at_bottom = true
return config
