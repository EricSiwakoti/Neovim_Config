return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    renderer = {
        root_folder_modifier = ":~",
        indent_markers = { enable = true },
        icons = {
            corner = "└ ",
            edge = "│ ",
            none = "  ",
            glyphs = {
                git = {
                    unstaged = "M",
                    staged = "A",
                    unmerged = "",
                    renamed = "R",
                    untracked = "U",
                    deleted = "D",
                    ignored = "I",
                },
            },
        },
    },
    icons = {
      webdev_colors = true,
    },
    actions = {
        use_system_clipboard = true,
     change_dir = {
      enable = true,
      global = false,
      restrict_above_cwd = false,
    },
    },
    modified = {
        enable = true,
    },
    diagnostics = {
        enable = true,
        show_on_dirs = false,
        debounce_delay = 450,
        icons = {
            error = " ",
            warning = " ",
            hint = " ",
            info = " ",
        },
    },
    config = function()
        require("nvim-tree").setup({
        view = {
            adaptive_size = true,
            width = 30,
            signcolumn = "yes",
            side = "left"
       },
        trash = {
             cmd = "powershell Remove-Item -Confirm:$false -Path",
             require_confirm = true
        },
    })
    end,
}
