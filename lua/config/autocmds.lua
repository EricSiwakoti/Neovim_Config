local autocmd, command, cmd, fn =
  vim.api.nvim_create_autocmd, vim.api.nvim_create_user_command, vim.cmd, vim.fn

-- Auto format on save
local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    group = lsp_fmt_group,
    callback = function()
        local clients = vim.lsp.get_active_clients()
        local has_formatter = false

        for _, client in ipairs(clients) do
            if client.resolved_capabilities.document_formatting then
                vim.lsp.buf.formatting_sync(nil, 1000)
                has_formatter = true
                break
            end
        end

        if not has_formatter then
            local efm = vim.lsp.get_active_clients({ name = "efm" })
            if not vim.tbl_isempty(efm) then
                vim.lsp.buf.format()
            end
        end
    end,
})

-- Highlight on yank
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYankGroup", {})
vim.api.nvim_create_autocmd("TextYankPost", {
	group = highlight_yank_group,
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Automatically close NvimTree if it's the last buffer on window
local nvimtree_close_group = vim.api.nvim_create_augroup("NvimTreeCloseGroup", {})
vim.api.nvim_create_autocmd('QuitPre', {
	group = nvimtree_close_group,
   	callback = function()
    local invalid_win = {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match('NvimTree_') ~= nil then table.insert(invalid_win, w) end
    end
    if #invalid_win == #wins - 1 then
      -- Should quit, so we close all invalid windows.
      for _, w in ipairs(invalid_win) do
        vim.api.nvim_win_close(w, true)
      end
    end
  end,
})

-- Trim trailing whitespace and trailing blank lines on save
local function trim_trailing_whitespace()
  local pos = vim.api.nvim_win_get_cursor(0)
  cmd([[silent keepjumps keeppatterns %s/\s\+$//e]])
  vim.api.nvim_win_set_cursor(0, pos)
end
command('TrimWhitespace', trim_trailing_whitespace, {})

local function trim_trailing_lines()
  local last_line = vim.api.nvim_buf_line_count(0)
  local last_nonblank_line = vim.fn.prevnonblank(last_line)
  if last_nonblank_line < last_line then vim.api.nvim_buf_set_lines(0, last_nonblank_line, last_line, true, {}) end
end
command('TrimTrailingLines', trim_trailing_lines, {})

local function trim()
  if not vim.o.binary and vim.o.filetype ~= 'diff' then
    trim_trailing_lines()
    trim_trailing_whitespace()
  end
end

local trim_on_save_group = vim.api.nvim_create_augroup("TrimOnSaveGroup", {})
autocmd('BufWritePre', {
  group = trim_on_save_group,
  callback = trim,
})
