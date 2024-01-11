local opts = {
  -- Whatever language/tech we write inside this block, it will automatically get installed
	ensure_installed = {
		"efm",
		"bashls",
		"tsserver",
		"solidity",
		"tailwindcss",
		"pyright",
		"emmet_ls",
		"jsonls",
    "clangd",
    "dockerls",
	},

	automatic_installation = true,
}

return {
	"williamboman/mason-lspconfig.nvim",
	opts = opts,
	event = "BufReadPre",
	dependencies = "williamboman/mason.nvim",
}
