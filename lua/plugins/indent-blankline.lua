return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    lazy = false,
    config = function()
        require("ibl").setup{
            indent = { char = "|" },
            scope = {
                show_start = false,
                show_end = false,
            },
            exclude = { 
                buftypes = { "terminal", "nofile" },
                filetypes = { "dashboard" }
            },
        }
    end
}