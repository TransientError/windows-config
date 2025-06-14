local utils = require "utils"

if utils.is_vscode() then
  return {}
end

return {
  {
    "folke/which-key.nvim",
    opts = {},
    event = "VeryLazy",
  },
  {
    "chentoast/marks.nvim",
    opts = {},
    event = "VeryLazy",
  },
  {
    "Pocco81/auto-save.nvim",
    event = "VeryLazy",
    opts = {
      condition = function(buf)
        local path = vim.fn.expand "%:p"
        local file_name = vim.fn.expand "%:t"
        local configs = { vim.fn.stdpath "config", vim.env.USERPROFILE .. "\\.config\\wezterm" }
        local config_files = { ".wezterm.lua" }
        local is_in_config = vim.tbl_contains(configs, function(v)
          return string.find(path, "^" .. v) ~= nil
        end, { predicate = true })
        local is_config_file = vim.list_contains(config_files, file_name)

        return vim.fn.getbufvar(buf, "&modifiable") == 1 and not (is_in_config or is_config_file)
      end,
    },
  },
  {
    "airblade/vim-rooter",
    init = function()
      vim.g.rooter_patterns = { ".git", "=nvim", "=work", "=utils", "*.sln", "*.csproj" }
    end,
  },
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    cmd = "Mason",
    keys = {
      { "<leader>m", "<cmd>Mason<cr>", desc = "Mason" },
    },
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
  },
  {
    "b0o/SchemaStore",
    ft = { "json", "jsonc", "yaml" },
  },
  {
    "deponian/nvim-base64",
    version = "*",
    keys = {
      { "<localleader>eb", "<Plug>(ToBase64)", mode = "x",desc = "Base64 Encode", buffer = true },
      { "<localleader>db", "<Plug>(FromBase64)", mode = "x", desc = "Base64 Decode", buffer = true },
    },
    ft = { "text", "markdown" },
    config = function()
      require("nvim-base64").setup()
    end,
  },
}
