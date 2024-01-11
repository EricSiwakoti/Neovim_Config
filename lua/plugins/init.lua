return{
   {
    { "folke/neoconf.nvim", cmd = "Neoconf" },
       "folke/neodev.nvim",
   },
   {
   'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
    require('home.dashboard')
    end,
    dependencies = { {'nvim-tree/nvim-web-devicons'}}
   }
}
