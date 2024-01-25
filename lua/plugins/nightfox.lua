return {
	"EdenEast/nightfox.nvim",
	lazy = false,
	priority = 999,
	config = function ()
		require('nightfox').setup({
				  options = {
					transparent = true,
    				terminal_colors = true,
    				styles = {
      					comments = "italic",
      					keywords = "bold",
						functions = "italic,bold",
      					types = "italic,bold",
   					}
 				}
		})
		vim.cmd("colorscheme carbonfox")
	end
}
