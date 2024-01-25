require("config")
vim.o.history = 0
vim.o.shell = 'pwsh'

-- Open terminal in a bottom horizontal split
vim.api.nvim_set_keymap('n', '<leader>tm', ':split | terminal<CR>', { noremap = true, silent = true })

-- Resize the terminal window
vim.cmd([[
  autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no
  autocmd TermOpen * resize 12
]])
