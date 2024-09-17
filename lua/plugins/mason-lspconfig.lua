local opts = {
  	-- Whatever language/tech we write inside this block, it will automatically get installed
	ensure_installed = {
		"efm",
		"bashls",
		"ts_ls",
		"solidity",
		"tailwindcss",
		"pyright",
		"emmet_ls",
		"jsonls",
    	"clangd",
    	"dockerls",
		"gopls", 
	},

	automatic_installation = true,
}

return {
	"williamboman/mason-lspconfig.nvim",
	opts = opts,
	event = "BufReadPre",
	lazy = false,
	dependencies = "williamboman/mason.nvim",
	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup(opts)
	end,
}
