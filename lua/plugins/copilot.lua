return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      local copilot = require('copilot')
      local suggestion = require('copilot.suggestion')
      local autopairs = require("nvim-autopairs")

      copilot.setup({
        suggestion = {
          auto_trigger = true
        },
        filetypes = {
          ["*"] = true
        }
      })

      vim.keymap.set("i", "<C-u>", function()
        autopairs.disable()
        suggestion.accept()
        autopairs.enable()
      end, { desc = "Accept Copilot suggestion" })
    end
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, 
      { "nvim-lua/plenary.nvim" }, -- For curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    lazy = false, 
    config = function()
      local copilot_chat = require("CopilotChat")

      copilot_chat.setup({
        language = "en", 
        -- Additional configuration options can be added here
      })

      vim.keymap.set('n', '<leader>cc', '<cmd>CopilotChat<CR>',
        { noremap = true, silent = true, desc = "Open Copilot Chat" })

      -- Register copilot-chat source and enable it for copilot-chat filetype
      require("CopilotChat.integrations.cmp").setup()

      -- Quick chat with Copilot
      vim.keymap.set('n', '<leader>ccq', function()
        local input = vim.fn.input("Quick Chat: ")
        if input ~= "" then
          copilot_chat.ask(input, { selection = require("CopilotChat.select").buffer })
        end
      end, { noremap = true, silent = true, desc = "CopilotChat - Quick chat" })

      -- Define custom command
      vim.api.nvim_create_user_command('CopilotChat', function()
        copilot_chat.open()
      end, { desc = "Open Copilot Chat" })
    end,
  },
}