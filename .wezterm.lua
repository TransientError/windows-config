local wezterm = require "wezterm" --[[@as Wezterm]]
local config = wezterm.config_builder()

local tabline = wezterm.plugin.require "https://github.com/michaelbrusegard/tabline.wez"
tabline.setup { options = { theme = "Tomorrow Night Bright" } } ---@diagnostic disable-line: undefined-field
tabline.apply_to_config(config)

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.default_prog = { "pwsh" }
  config.color_scheme = "PaulMillr"
  config.prefer_egl = true
  config.window_decorations = "TITLE | RESIZE"
end

config.font = wezterm.font "LigaHack Nerd Font"

config.launch_menu = {
  {
    label = "Powershell",
    args = { "pwsh" },
  },
  {
    label = "Nushell",
    args = { "nu" },
  },
}

local keys = require("keys")
keys.apply_to_config(config)

config.tab_bar_at_bottom = true
return config
