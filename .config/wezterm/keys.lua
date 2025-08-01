local wezterm = require "wezterm"
local M = {}

function M.apply_to_config(config)
  config.leader = { key = ",", mods = "CTRL" }

  config.keys = {
    {
      key = "c",
      mods = "CTRL",
      action = wezterm.action_callback(function(window, pane)
        if pane == nil then
          wezterm.log_error "pane is nil"
          return
        end
        local selection_text = window:get_selection_text_for_pane(pane)
        local is_selection_active = string.len(selection_text) ~= 0
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
    {
      key = "f",
      mods = "CTRL|SHIFT",
      action = wezterm.action.Search { CaseInSensitiveString = "" },
    },
    {
      key = "/",
      mods = "LEADER",
      action = wezterm.action.Search { CaseInSensitiveString = "" },
    },
  }

  for i = 0, 9, 1 do
    table.insert(config.keys, {
      key = tostring(i),
      mods = "LEADER",
      action = wezterm.action.ActivateTab((i - 1) % 10),
    })
  end
end

return M
