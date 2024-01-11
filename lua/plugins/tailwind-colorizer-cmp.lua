return {
	"roobert/tailwindcss-colorizer-cmp.nvim",
	-- Optionally, override the default options:
	config = function()
		require("tailwindcss-colorizer-cmp").setup({
			color_square_width = 2,
		})
	end,
}
