local autocmd, command, cmd, fn = vim.api.nvim_create_autocmd, vim.api.nvim_create_user_command, vim.cmd, vim.fn

-- Auto format on save
local function format_buffer()
    local clients = vim.lsp.get_active_clients()
    local has_formatter = false

    -- Check if any active LSP clients provide formatting
    for _, client in ipairs(clients) do
        if client.server_capabilities and client.server_capabilities.documentFormattingProvider then
            vim.lsp.buf.format({ async = true, client_id = client.id })
            has_formatter = true
            vim.notify("Formatting buffer with " .. client.name, vim.log.levels.INFO, { title = "LSP" })
            break
        end
    end

    -- Check if "efm" client exists and can format
    if not has_formatter then
        local efm_clients = vim.lsp.get_active_clients({ name = "efm" })
        if #efm_clients > 0 then
            vim.lsp.buf.format({ async = true })
            has_formatter = true
        end
    end
end

-- Create groups and autocmds
local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    group = lsp_fmt_group,
    callback = format_buffer,
})

-- Highlight on yank
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYankGroup", {})
vim.api.nvim_create_autocmd("TextYankPost", {
    group = highlight_yank_group,
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
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
    local last_line = vim.api.nvim_buf_line_count(0)
    pos[1] = math.min(pos[1], last_line)
    vim.api.nvim_win_set_cursor(0, pos)
end
command('TrimWhitespace', trim_trailing_whitespace, {})

local function trim_trailing_lines()
    local last_line = vim.api.nvim_buf_line_count(0)
    local last_nonblank_line = vim.fn.prevnonblank(last_line)
    if last_nonblank_line < last_line then
        vim.api.nvim_buf_set_lines(0, last_nonblank_line, last_line, true, {})
    end
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
