vim.g.mapleader = " "
vim.g.maplocalleader = ","

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
  require "kvwu-vscode"
else
  if g.neovide or g.nvy then
    opt.guifont = "LigaHack Nerd Font:h12"

    map.set("n", "<leader>qr", function()
      cmd "!start neovide"
      cmd "qa!"
    end)
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
  map.set("n", "<Esc><Esc>", ":noh<CR>", { noremap = true })
  map.set("n", "<leader>wh", ":wincmd h<CR>", { noremap = true })
  map.set("n", "<leader>wj", ":wincmd j<CR>", { noremap = true })
  map.set("n", "<leader>wk", ":wincmd k<CR>", { noremap = true })
  map.set("n", "<leader>wl", ":wincmd l<CR>", { noremap = true })
  map.set("n", "<leader>wH", ":wincmd H<CR>", { noremap = true })
  map.set("n", "<leader>wJ", ":wincmd J<CR>", { noremap = true })
  map.set("n", "<leader>wK", ":wincmd K<CR>", { noremap = true })
  map.set("n", "<leader>wL", ":wincmd L<CR>", { noremap = true })
  map.set("n", "<leader>ws", ":wincmd s<CR>", { noremap = true })
  map.set("n", "<leader>wv", ":wincmd v<CR>", { noremap = true })
  map.set("n", "<leader>w=", ":wincmd =<CR>", { noremap = true })
  map.set("n", "<leader>wd", ":close<CR>", { noremap = true })
  map.set("n", "<leader>wo", ":wincmd o<CR>", { noremap = true })
  map.set("n", "<leader>qq", ":qa!<CR>", { noremap = true })
  map.set("n", "<leader>ot", ":split term://fish<CR>", { noremap = true })
  map.set("n", "<leader>bl", "<C-o>", { noremap = true })
  map.set("n", "<leader>bh", "<C-i>", { noremap = true })
  map.set("n", "<leader>bd", ":bdelete<cr>", { noremap = true })
  map.set("n", "<leader>bn", ":vnew<cr>", { noremap = true })
  map.set("n", "<leader>hs", ":new ++ff=lua<cr>", { noremap = true })
  map.set("n", "<leader>fp", ":cd ~/AppData/Local/nvim<CR>:e ~/AppData/Local/nvim/init.lua<CR>", { noremap = true })
  map.set("n", "<leader>l", ":Lazy<CR>", { noremap = true })
  map.set("i", "<C-z>", "<Esc>zzi<Tab>", { noremap = true, silent = true })
  map.set("n", "<leader>tN", ":tabnew<CR>", { noremap = true })
  map.set("n", "<leader>te", ":tabedit %<CR>", { noremap = true })
  map.set("n", "<leader>td", ":tabclose<CR>", { noremap = true })
  map.set("n", "<leader>tn", ":tabnext<CR>", { noremap = true })
  map.set("n", "<leader>tp", ":tabprev<CR>", { noremap = true })

  vim.api.nvim_create_autocmd("VimResized", { pattern = "*", command = "wincmd =" })
  vim.api.nvim_create_autocmd("FileType", { pattern = "help", command = "wincmd L" })
end

require "config.lazy"
