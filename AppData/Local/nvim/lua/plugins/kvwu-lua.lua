if require("utils").is_vscode() then
  return {}
end

return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        "lazy.nvim",
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    },
    dependencies = {
      { "TransientError/wezterm-types", lazy = true },
    },
  },
  {
    "rafcamlet/nvim-luapad",
    cmd = { "Luapad", "LuaRun" },
  },
}
