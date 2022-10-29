local map = vim.keymap

vim.opt.clipboard = 'unnamed'

map.set("n", "gi", "<Cmd>call VSCodeNotify('editor.action.goToImplementation')<CR>")