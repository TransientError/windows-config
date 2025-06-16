local utils = require "utils"
local config = require "kvwu-config"

if utils.is_vscode() then
  return {}
end

return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function(bufnr)
        local gs = require "gitsigns"
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal { "]c", bang = true }
          else
            gs.nav_hunk "next"
          end
        end)
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal { "[c", bang = true }
          else
            gs.nav_hunk "prev"
          end
        end)
        map({ "n", "v" }, "<localleader>ghs", gs.stage_hunk, "Stage hunk")
        map({ "n", "v" }, "<localleader>ghr", gs.reset_hunk, "Unstage hunk")
        map("n", "<localleader>gS", gs.stage_buffer, "Stage buffer")
        map("n", "<localleader>gR", gs.reset_buffer, "reset buffer")
      end,
    },
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    cond = utils.not_vscode,
    dependencies = {
      "tpope/vim-repeat",
    },
  },
  {
    "cedarbaum/fugitive-azure-devops.vim",
    cond = config.profiles.work,
    dependencies = {
      "tpope/vim-rhubarb",
    },
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git" },
    keys = {
      {
        "<leader>gC",
        "<cmd>Git commit<cr>",
        silent = true,
        desc = "git commit",
      },
      {
        "<leader>gp",
        "<cmd>Git pull<cr>",
        silent = true,
        desc = "git pull",
      },
      {
        "<leader>gP",
        "<cmd>Git push<cr>",
        silent = true,
        desc = "git push",
      },
      {
        "<leader>gs",
        "<cmd>Git switch -c ",
        silent = true,
        desc = "git new branch",
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
    opts = function()
      return {
        keymaps = {
          file_panel = {
            ["S"] = false,
            { "n", "<leader>gd", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
            { "n", "<leader>wd", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
            { "n", "c", "<cmd>Git commit<cr>", { desc = "git commit" } },
            { "n", "p", "<cmd>Git pull<cr>", { desc = "git pull" } },
            { "n", "P", "<cmd>Git push<cr>", { desc = "git push" } },
          },
          view = {
            { "n", "<leader>gd", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
            { "n", "<leader>wd", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
          },
          file_history_panel = {
            { "n", "<leader>gd", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
            { "n", "<leader>wd", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
          },
        },
      }
    end,
    keys = {
      {
        "<leader>gd",
        "<cmd>DiffviewOpen<cr>",
        desc = "Open Diffview",
      },
      {
        "<leader>gH",
        "<cmd>DiffviewFileHistory<cr>",
        desc = "DiffviewFileHistory",
      },
      {
        "<leader>gh",
        "<cmd>DiffviewFileHistory %<CR>",
        desc = "DiffviewFileHistory file",
      },
    },
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    opts = {
      default_mappings = false,
    },
    dependencies = {
      "nvimtools/hydra.nvim",
    },
    config = function(_, opts)
      require("git-conflict").setup(opts)
      local Hydra = require "hydra"
      Hydra {
        name = "Git Conflict",
        mode = { "n" },
        body = "<leader>gc",
        heads = {
          { "h", "<Plug>(git-conflict-ours)", { desc = "Use ours" } },
          { "l", "<Plug>(git-conflict-theirs)", { desc = "Use theirs" } },
          { "b", "<Plug>(git-conflict-both)", { desc = "Use both" } },
          { "0", "<Plug>(git-conflict-none)", { desc = "Use neither" } },
          { "p", "<Plug>(git-conflict-prev-conflict)", { desc = "Previous conflict" } },
          { "n", "<Plug>(git-conflict-next-conflict)", { desc = "Next conflict" } },
          { "r", "<Plug>(git-conflict-reset)", { desc = "Reset conflict" } },
          { "<Esc>", nil, { exit = true, nowait = true } },
        },
      }
    end,
  },
}
