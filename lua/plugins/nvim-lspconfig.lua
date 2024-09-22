local on_attach = require("util.lsp").on_attach
local diagnostic_signs = require("util.icons").diagnostic_signs

local config = function()
    require("neoconf").setup({})
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_registry = require("mason-registry")
    local capabilities = cmp_nvim_lsp.default_capabilities()

    for type, icon in pairs(diagnostic_signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    vim.diagnostic.config({
        virtual_text = true,
        update_in_insert = true,
        underline = true,
        severity_sort = { reverse = false },
        float = {
            focusable = true,
            style = "minimal",
            border = "rounded",
            source = true,
            header = "",
            prefix = "",
        },
    })

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        signs = true,
        underline = true,
        virtual_text = {
            spacing = 5,
            severity = { min = vim.diagnostic.severity.HINT },
        },
        update_in_insert = true,
    })

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        {
            border = "rounded"  -- Options: "single", "double", "rounded", "solid", "shadow"
        }
    )
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        {
            border = "rounded"  -- Options: "single", "double", "rounded", "solid", "shadow"
        }
    )

    vim.keymap.set("n", "dn", vim.diagnostic.goto_next)
    vim.keymap.set("n", "dN", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open diagnostic float" })

    vim.keymap.set("n", "<leader>lh", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }))
    end, { desc = "Toggle inlay hints" })

    vim.cmd([[autocmd FileType * set formatoptions-=ro]])

    -- Json
    lspconfig.jsonls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "json", "jsonc" },
    })

    -- Python
    lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "python" },
        root_dir = lspconfig.util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile"),
        settings = {
            pyright = {
                disableOrganizeImports = false,
                analysis = {
                    useLibraryCodeForTypes = true,
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    autoImportCompletions = true,
                    typeCheckingMode = "basic"
                },
                executionEnvironments = {
                    { root = ".", extraPaths = { "src", "lib", "tests" } }
                },
                reportMissingImports = "none",
                reportMissingModuleSource = "none"
            }
        },
    })

    -- Typescript
	lspconfig.ts_ls.setup({
		on_attach = on_attach,
		capabilities = capabilities,
		filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
	})

    -- Bash
    lspconfig.bashls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "sh", "aliasrc" },
        root_dir = lspconfig.util.root_pattern(".git", ".bashrc", ".zshrc", ".bash_profile", ".bash_aliases", ".bash_history", ".bash_logout", ".bashrc", ".bash_login", ".bash_logout", ".profile", ".zshrc", ".zshenv", ".zprofile", ".zlogin", ".zlogout"),
    })

    -- Solidity
    lspconfig.solidity.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "solidity" },
        root_dir = lspconfig.util.root_pattern("truffle-config.js", "hardhat.config.js", "package.json"),
    })

    -- Emmet
	lspconfig.emmet_ls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = {
			"typescriptreact",
			"javascriptreact",
			"javascript",
			"css",
			"sass",
			"scss",
			"less",
			"svelte",
			"vue",
			"html",
		},
	})

    -- Docker
    lspconfig.dockerls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "dockerfile" },
        root_dir = lspconfig.util.root_pattern("Dockerfile", ".git"),
    })

    -- C/C++
    lspconfig.clangd.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = {
            "clangd",
            "--offset-encoding=utf-16",
        },
        filetypes = { "c", "cpp", "objc", "objcpp" },
    })

    -- Go
    lspconfig.gopls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "go", "gomod" },
        root_dir = lspconfig.util.root_pattern("go.mod", ".git"),
    })

    -- TailwindCSS
    lspconfig.tailwindcss.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_dir = lspconfig.util.root_pattern("tailwind.config.js", "tailwind.config.cjs", "tailwind.config.ts", "tailwind.config.tsx"),
    })

    local function get_tool_config(tool_name)
        if tool_name == 'prettier' then
            return {
                formatCommand = "prettier --stdin-filepath ${INPUT}",
                formatStdin = true,
            }
        elseif tool_name == 'flake8' then
            return {
                lintCommand = "flake8 --stdin-display-name ${INPUT} -",
                lintStdin = true,
                lintFormats = { "%f:%l:%c: %m" },
            }
        elseif tool_name == 'eslint_d' then
            return {
                lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
                lintStdin = true,
                lintFormats = { "%f:%l:%c: %m" },
            }
        elseif tool_name == 'shellcheck' then
            return {
                lintCommand = "shellcheck -f gcc -x",
                lintFormats = { "%f:%l:%c: %m" },
            }
        elseif tool_name == 'hadolint' then
            return {
                lintCommand = "hadolint -f gcc",
                lintFormats = { "%f:%l:%c: %m" },
            }
        elseif tool_name == 'solhint' then
            return {
                lintCommand = "solhint -f unix",
                lintFormats = { "%f:%l:%c: %m" },
            }
        elseif tool_name == 'cpplint' then
            return {
                lintCommand = "cpplint",
                lintFormats = { "%f:%l: %m" },
            }
        elseif tool_name == 'golangci-lint' then
            return {
                lintCommand = "golangci-lint run --out-format=line-number",
                lintFormats = { "%f:%l:%c: %m" },
            }
        elseif tool_name == 'black' then
            return {
                formatCommand = "black --quiet -",
                formatStdin = true,
            }
        elseif tool_name == 'fixjson' then
            return {
                formatCommand = "fixjson",
                formatStdin = true,
            }
        elseif tool_name == 'shfmt' then
            return {
                formatCommand = "shfmt -",
                formatStdin = true,
            }
        elseif tool_name == 'clang-format' then
            return {
                formatCommand = "clang-format -assume-filename=${INPUT}",
                formatStdin = true,
            }
        elseif tool_name == 'goimports' then
            return {
                formatCommand = "goimports",
                formatStdin = true,
            }
        else
            print(string.format("Error: Unable to find config for %s", tool_name))
            return nil
        end
    end

    local function get_tool(category, tool_name)
        local config = get_tool_config(tool_name)
        if config then
            return config
        end

        if mason_registry.is_installed(tool_name) then
            return mason_registry.get_package(tool_name)
        else
            print(string.format("Error: Unable to find %s in category %s", tool_name, category))
            return nil
        end
    end

    local flake8 = get_tool('lint', 'flake8')
    local eslint_d = get_tool('lint', 'eslint_d')
    local shellcheck = get_tool('lint', 'shellcheck')
    local hadolint = get_tool('lint', 'hadolint')
    local solhint = get_tool('lint', 'solhint')
    local cpplint = get_tool('lint', 'cpplint')
    local golangci_lint = get_tool('lint', 'golangci-lint')
    local black = get_tool('format', 'black')
    local fixjson = get_tool('format', 'fixjson')
    local shfmt = get_tool('format', 'shfmt')
    local clang_format = get_tool('format', 'clang-format')
    local goimports = get_tool('format', 'goimports')
    local prettier = get_tool('format', 'prettier')

    local languages = {
        python = { flake8, black },
        typescript = { eslint_d, prettier },
        json = { eslint_d, fixjson },
        jsonc = { eslint_d, fixjson },
        sh = { shellcheck, shfmt },
        javascript = { eslint_d, prettier },
        javascriptreact = { eslint_d, prettier },
        typescriptreact = { eslint_d, prettier },
        svelte = { eslint_d, prettier },
        vue = { eslint_d, prettier },
        markdown = { prettier },
        docker = { hadolint, prettier },
        solidity = { solhint },
        html = { prettier },
        css = { prettier },
        c = { clang_format, cpplint },
        cpp = { clang_format, cpplint },
        go = { goimports, golangci_lint },
    }

    -- Configure efm server
    local efm_config = {
        filetypes = vim.tbl_keys(languages),
        settings = {
            rootMarkers = { '.git/' },
            languages = languages,
        },
        init_options = {
            documentFormatting = true,
            documentRangeFormatting = true,
            hover = true,
            documentSymbol = true,
            codeAction = true,
            completion = true,
        },
    }

    lspconfig.efm.setup(vim.tbl_extend('force', efm_config, {
        capabilities = capabilities,
        on_attach = on_attach,
    }))
end

return {
    "neovim/nvim-lspconfig",
    config = config,
    lazy = false,
    dependencies = {
        "windwp/nvim-autopairs",
        "williamboman/mason.nvim",
        "creativenull/efmls-configs-nvim",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lsp",
    },
}
