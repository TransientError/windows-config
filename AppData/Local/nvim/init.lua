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
      cmd "!start nvy"
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
  map.set("n", "<leader><leader>", ":", { noremap = true })
  map.set("n", "<C-v>", '"+p', { noremap = true })
  map.set("i", "<C-v>", '<Esc>"+pa', { noremap = true })
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

  local function set_dap_dll()
    local projects = require("kvwu-config").projects or {}
    if vim.fn.glob "*.{sln,csproj}" ~= "" then
      local project_files = vim.fn.glob("*.{sln,csproj}", false, true)
      for _, file in ipairs(project_files) do
        local project_name = vim.fn.fnamemodify(file, ":t:r")
        for project_key, dll_pattern in pairs(projects) do
          if project_name:find(project_key, 1, true) then
            vim.g.dap_dll = dll_pattern
            return
          end
        end
      end
    end
  end

  vim.api.nvim_create_autocmd("DirChanged", {
    pattern = "global",
    callback = set_dap_dll,
  })
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = set_dap_dll,
  })
end

vim.g.material_style = "darker"
require "config.lazy"
