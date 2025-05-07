vim.g.mapleader = " "
local utils = require "utils"

local g = vim.g
local opt = vim.opt
local fn = vim.fn
local cmd = vim.cmd
local map = vim.keymap

utils.process_settings {
  opt = {
    expandtab = true,
    ignorecase = true,
    smartcase = true,
    shiftwidth = 2,
  },
}

if g.vscode then
  require "vscode"
else
  if g.neovide or g.nvy then
    opt.guifont = "LigaHack Nerd Font:h12"
  end
  utils.process_settings {
    opt = {
      number = true,
      relativenumber = true,
      listchars = { tab = "▸▸", trail = "·" },
      colorcolumn = "120",
    },
  }

  map.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })
  map.set("n", "<leader>wh", ":wincmd h<CR>", { noremap = true })
  map.set("n", "<leader>wj", ":wincmd j<CR>", { noremap = true })
  map.set("n", "<leader>wk", ":wincmd k<CR>", { noremap = true })
  map.set("n", "<leader>wl", ":wincmd l<CR>", { noremap = true })
  map.set("n", "<leader>ws", ":wincmd s<CR>", { noremap = true })
  map.set("n", "<leader>wv", ":wincmd v<CR>", { noremap = true })
  map.set("n", "<leader>w=", ":wincmd =<CR>", { noremap = true })
  map.set("n", "<leader>wd", ":close<CR>", { noremap = true })
  map.set("n", "<leader>qq", ":qa!<CR>", { noremap = true })
  map.set("n", "<leader>ot", ":split term://fish<CR>", { noremap = true })
  map.set("n", "<leader>bl", "<C-o>", { noremap = true })
  map.set("n", "<leader>fp", ":cd ~/AppData/Local/nvim<CR>:e ~/AppData/Local/nvim/init.lua<CR>", { noremap = true })
  map.set("n", "<leader>l", ":Lazy<CR>", { noremap = true })
  map.set("n", "<ldeader>m", ":Mason<CR>", { noremap = true })

  vim.api.nvim_create_autocmd("VimResized", { pattern = "*", command = "wincmd =" })
end

require "config.lazy"
