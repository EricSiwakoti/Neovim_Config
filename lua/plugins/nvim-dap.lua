return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local keymap = vim.keymap.set

      -- Key mappings for DAP
      keymap("n", "<F10>", '<cmd>lua require"dap".step_into()<CR>', { desc = "DAP step into" })
      keymap("n", "<F11>", '<cmd>lua require"dap".step_over()<CR>', { desc = "DAP step over" })
      keymap("n", "<F12>", '<cmd>lua require"dap".step_out()<CR>', { desc = "DAP step out" })
      keymap("n", "<F5>", function()
        if vim.fn.filereadable(".vscode/launch.json") == 1 then
          require("dap.ext.vscode").load_launchjs()
        end
        require("dap").continue()
      end, { desc = "DAP continue" })
      keymap("n", "<leader>du", '<cmd>lua require"dapui".toggle()<CR>', { desc = "DAP toggle UI" })
      keymap("n", "<leader>dr", function()
        local dapui = require("dapui")
        dapui.close()
        dapui.open({ reset = true })
      end, { desc = "DAP reset UI" })
      keymap("n", "<leader>de", '<cmd>lua require"dapui".eval()<CR>', { desc = "DAP eval" })
      keymap("n", "<leader>db", '<cmd>lua require"dap".toggle_breakpoint()<CR>', { desc = "DAP toggle breakpoint" })
      keymap("n", "<leader>dc", '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', { desc = "DAP set breakpoint with condition" })

      -- Custom command to disconnect DAP
      vim.api.nvim_create_user_command("DapDisconnect", function()
        require("dap").disconnect()
        require("dapui").close()
      end, {})

      -- Custom icons for breakpoints
      vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })

      -- DAP adapters and configurations
      local dap_config = {
        python = {
          adapter = { type = "executable", command = "python", args = { "-m", "debugpy.adapter" } },
          configurations = {
            {
              type = "python",
              request = "launch",
              name = "Launch file",
              program = "${file}",
              pythonPath = function() return "python" end,
            },
          },
        },

        go = {
          adapter = { type = "executable", command = "dlv", args = { "dap" }, name = "Delve" },
          configurations = {
            { type = "go", name = "Debug", request = "launch", program = "${file}" },
          },
        },

        bash = {
          adapter = { type = 'executable', command = 'bash-debug-adapter', name = 'bashdb' },
          configurations = {
            {
              type = 'bashdb',
              request = 'launch',
              name = 'Launch file',
              showDebugOutput = true,
              file = "${file}",
              program = "${file}",
              cwd = '${workspaceFolder}',
              pathBashdb = vim.fn.exepath('bashdb'),
              pathBashdbLib = vim.fn.exepath('bashdb') .. '/lib',
              trace = true,
              terminalKind = "integrated",
              pathCat = vim.fn.exepath('cat'),
              pathBash = vim.fn.exepath('bash'),
              pathMkfifo = vim.fn.exepath('mkfifo'),
              pathPkill = vim.fn.exepath('pkill'),
            },
          },
        },

        c = {
          adapter = {
            type = 'server',
            port = "${port}",
            executable = {
              command = vim.fn.exepath("codelldb"),
              args = { "--port", "${port}" },
            },
          },
          configurations = {
            {
              name = "Launch",
              type = "codelldb",
              request = "launch",
              program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
              end,
              cwd = "${workspaceFolder}",
              stopOnEntry = false,
              args = {},
            },
          },
        },

        javascript = {
          adapter = {
            type = 'executable',
            command = 'node',
            args = { vim.fn.exepath('vscode-node-debug2/out/src/nodeDebug.js') },
          },
          configurations = {
            {
              type = 'node2',
              request = 'launch',
              name = 'Launch file',
              program = '${file}',
              cwd = vim.fn.getcwd(),
            },
          },
        },

        typescript = {
          configurations = {
            {
              type = 'node2',
              request = 'launch',
              name = 'Launch file',
              program = '${file}',
              cwd = vim.fn.getcwd(),
              sourceMaps = true,
              protocol = 'inspector',
              skipFiles = { '<node_internals>/**' },
            },
          },
        },
      }

      -- Set DAP configurations
      dap.adapters.python = dap_config.python.adapter
      dap.configurations.python = dap_config.python.configurations

      dap.adapters.go = dap_config.go.adapter
      dap.configurations.go = dap_config.go.configurations

      dap.adapters.bashdb = dap_config.bash.adapter
      dap.configurations.sh = dap_config.bash.configurations

      dap.adapters.codelldb = dap_config.c.adapter
      dap.configurations.c = dap_config.c.configurations

      dap.adapters.node2 = dap_config.javascript.adapter
      dap.configurations.javascript = dap_config.javascript.configurations
      dap.configurations.typescript = dap_config.typescript.configurations
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    lazy = false,
    config = function()
      require("mason").setup()
      require("mason-nvim-dap").setup({
        ensure_installed = { "python", "delve", "codelldb", "bashdb", "node2" },
        automatic_installation = true,
      })
    end,
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
    config = function() require("nvim-dap-virtual-text").setup() end,
  },
}
