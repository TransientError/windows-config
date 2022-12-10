local kvwu_navigation = {}

function kvwu_navigation.setup(use, not_vscode)
  use {
    "nvim-tree/nvim-tree.lua",
    cond = not_vscode,
    config = function()
      require("nvim-tree").setup {
        update_focused_file = {
          enable = true,
        },
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        view = {
          mappings = {
            custom_only = false,
            list = {
              { key = "l", action = "cd" },
            },
          },
        },
      }
      vim.keymap.set({ "n", "v" }, "<leader>op", ":NvimTreeToggle<CR>")
    end,
    cmd = { "NvimTreeToggle" },
    keys = "<leader>op",
    ft = ""
  }
end

return kvwu_navigation
