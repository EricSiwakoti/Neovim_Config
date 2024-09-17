require("config")
vim.o.history = 0
vim.o.shell = "pwsh"
vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
vim.o.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
vim.o.shellquote = ""
vim.o.shellxquote = ""

vim.api.nvim_set_keymap('n', '<F8>', ':split |terminal<CR>', {noremap = true, silent = true})
vim.cmd([[
  autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no
  autocmd TermOpen * startinsert
]])