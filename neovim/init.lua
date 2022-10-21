vim.g.mapleader = " "
require "plugins"
local utils = require "utils"

local g = vim.g
local opt = vim.opt
local fn = vim.fn
local cmd = vim.cmd
local map = vim.keymap

utils.process_settings {
  opt = {
    expandtab = true,
    smartcase = true,
    shiftwidth = 2,
  },
}

if g.vscode then
  require "vscode"
else
  utils.process_settings {
    opt = {
      number = true,
      relativenumber = true,
      listchars = { tab = "▸▸", trail = "·"},
      colorcolumn = '120',
    },
  }

  map.set("", "<leader>wh", ":wincmd h<CR>")
  map.set("", "<leader>wj", ":wincmd j<CR>")
  map.set("", "<leader>wk", ":wincmd k<CR>")
  map.set("", "<leader>wl", ":wincmd l<CR>")
  map.set("", "<leader>ws", ":wincmd s<CR>")
  map.set("", "<leader>wv", ":wincmd v<CR>")
  map.set("", "<leader>wd", ":q<CR>")
end
