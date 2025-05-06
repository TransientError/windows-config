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
    g = {
      neoformat_enabled_cs = { "csharpier" },
    },
  }

  map.set("t", "<Esc>", "<C-\\><C-n>")
  map.set("", "<leader>wh", ":wincmd h<CR>")
  map.set("", "<leader>wj", ":wincmd j<CR>")
  map.set("", "<leader>wk", ":wincmd k<CR>")
  map.set("", "<leader>wl", ":wincmd l<CR>")
  map.set("", "<leader>ws", ":wincmd s<CR>")
  map.set("", "<leader>wv", ":wincmd v<CR>")
  map.set("", "<leader>w=", ":wincmd =<CR>")
  map.set("", "<leader>wd", ":close<CR>")
  map.set("", "<leader>qq", ":qa!<CR>")
  map.set("", "<leader>ot", ":split term://fish<CR>")
  map.set("", "<leader>bl", "<C-o>")
  map.set("", "<leader>hr", ":source ~/AppData/Local/nvim/init.lua<CR>:PackerCompile<CR>")

  map.set("", "<leader>fp", ":cd ~/AppData/Local/nvim<CR>:e ~/AppData/Local/nvim/init.lua<CR>")
  map.set("", "<leader>l", ":Lazy<CR>")

  vim.api.nvim_create_autocmd("VimResized", { pattern = '*', command = "wincmd ="})
end

require "config.lazy"
