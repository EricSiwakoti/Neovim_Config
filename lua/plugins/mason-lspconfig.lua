local lsp_opts = {
    ensure_installed = {
        'bashls',  
        'clangd',
        'dockerls', 
        'efm',
        'emmet_ls',  
        'gopls',
        'jsonls',  
        'pyright',
        'solidity',  
        'tailwindcss', 
        'ts_ls',  
    },
    automatic_installation = true,
}

local tool_opts = {
    ensure_installed = {
        'black',
        'clang-format',
        'cpplint',
        'eslint_d',
        'fixjson',
        'flake8',
        'goimports',
        'golangci-lint',
        'hadolint',
        'prettier',
        'shellcheck',
        'shfmt',
        'solhint',
    },
    automatic_installation = true,
}

return {
    {
        "williamboman/mason-lspconfig.nvim",
        opts = lsp_opts,
        event = "BufReadPre",
        lazy = false,
        dependencies = "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup(lsp_opts)
        end,
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = tool_opts,
        event = "BufReadPre",
        lazy = false,
        dependencies = "williamboman/mason.nvim",
        config = function()
            require("mason-tool-installer").setup(tool_opts)
        end,
    },
}
