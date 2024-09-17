return {
  'akinsho/toggleterm.nvim',
  version = "*",
  event = 'BufReadPre',
  lazy = false,
  config = function()
    require("toggleterm").setup({
        size = 10,
        open_mapping = [[<F7>]],
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        close_on_exit = false,
        persist_size = true,
        direction = "float",
        float_opts = {
            border = "curved",
            winblend = 0,
        },
        highlights = {
          border = "Normal",
          background = "Normal",
          FloatBorder = {
            guifg = "#208397"
          }
        },
        shell = "pwsh", 
    })
  end,
}