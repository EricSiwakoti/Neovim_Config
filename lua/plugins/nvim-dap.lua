return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local keymap = vim.keymap.set

      -- Key mappings for DAP
      keymap("n", "<F10>", function() dap.step_into() end, { desc = "DAP step into" })
      keymap("n", "<F11>", function() dap.step_over() end, { desc = "DAP step over" })
      keymap("n", "<F12>", function() dap.step_out() end, { desc = "DAP step out" })
      keymap("n", "<F5>", function()
        if vim.fn.filereadable(".vscode/launch.json") == 1 then
          require("dap.ext.vscode").load_launchjs()
        end
        dap.continue()
      end, { desc = "DAP continue" })
      keymap("n", "<leader>du", function() require("dapui").toggle() end, { desc = "DAP toggle UI" })
      keymap("n", "<leader>dr", function()
        local dapui = require("dapui")
        dapui.close()
        dapui.open({ reset = true })
      end, { desc = "DAP reset UI" })
      keymap("n", "<leader>de", function() require("dapui").eval() end, { desc = "DAP eval" })
      keymap("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "DAP toggle breakpoint" })
      keymap("n", "<leader>dc", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "DAP set breakpoint with condition" })

      -- Custom command to disconnect DAP
      vim.api.nvim_create_user_command("DapDisconnect", function()
        dap.disconnect()
        require("dapui").close()
      end, {})

      -- Custom icons for breakpoints
      vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })

      -- DAP adapters and configurations
      local dap_config = {
        python = {
          adapter = { 
            type = "executable", 
            command = "python", -- You can use `python3` depending on your system setup
            args = { "-m", "debugpy.adapter" } 
          },
          configurations = {
            {
              type = "python",
              request = "launch",
              name = "Launch file",
              program = "${file}",
              pythonPath = function()
                -- Use the Python interpreter from a virtual environment if available
                local venv_path = vim.fn.getenv("VIRTUAL_ENV")
                if venv_path and vim.fn.executable(venv_path .. "/bin/python") == 1 then
                  return venv_path .. "/bin/python"
                elseif vim.fn.executable(venv_path .. "/Scripts/python.exe") == 1 then
                  -- For Windows compatibility
                  return venv_path .. "/Scripts/python.exe"
                else
                  -- Fallback to the system Python
                  return vim.fn.exepath("python") or "python"
                end
              end,
            },
          },
        },

        go = {
          adapter = {
            type = "executable",
            command = function()
              -- Use the 'dlv' from a virtual environment or workspace if available
              local dlv_path = vim.fn.exepath("dlv")
              if dlv_path and vim.fn.executable(dlv_path) == 1 then
                return dlv_path
              else
                -- Fallback to system-level 'dlv'
                return "dlv"
              end
            end,
            args = { "dap" },
            name = "Delve",
          },
          configurations = {
            {
              type = "go",
              name = "Debug",
              request = "launch",
              program = "${file}", -- Debug the current file
              cwd = vim.fn.getcwd(), -- Set current working directory to the workspace folder
              dlvToolPath = vim.fn.exepath("dlv"), -- Optional: specify the dlv path explicitly
            },
          },
        },

        bash = {
          adapter = { 
            type = 'executable', 
            command = vim.fn.exepath('bash-debug-adapter'), -- Just use exepath to find the adapter
            name = 'bashdb',
          },
          configurations = {
            {
              type = 'bashdb',
              request = 'launch',
              name = 'Launch file',
              showDebugOutput = true,
              file = "${file}",
              program = "${file}",
              cwd = '${workspaceFolder}',
              -- Directly use exepath for required binaries
              pathBashdb = vim.fn.exepath('bashdb'),
              pathBashdbLib = vim.fn.exepath('bashdb') .. '/lib',
              pathCat = vim.fn.exepath('cat'),
              pathBash = vim.fn.exepath('bash'),
              pathMkfifo = vim.fn.exepath('mkfifo'),
              pathPkill = vim.fn.exepath('pkill'),
              trace = true,
              terminalKind = "integrated",
            },
          },
        },

        c = {
          adapter = {
            type = 'server',
            port = "${port}",
            executable = {
              command = vim.fn.exepath("codelldb"), -- Dynamically resolve the codelldb path
              args = { "--port", "${port}" },
            },
          },
          configurations = {
            {
              name = "Launch",
              type = "codelldb",
              request = "launch",
              program = function()
                -- Prompt the user to input the path to the executable
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
              end,
              cwd = "${workspaceFolder}",  
              stopOnEntry = false,         
              args = {},                   
            },
          },
        },

        cpp = {
          adapter = {
            type = 'executable',
            command = vim.fn.exepath('codelldb'), 
            args = {},                                
          },
          configurations = {
            {
              type = 'cpp',
              request = 'launch',
              name = 'Launch C++',
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
              program = "${file}",         -- Debug the current file
              cwd = vim.fn.getcwd(),       -- Set current working directory to the project folder
              sourceMaps = true,           -- Enable source maps for better debugging
              protocol = 'inspector',      -- Use the inspector protocol for debugging
              skipFiles = { "<node_internals>/**" },  -- Skip internal Node.js modules during debugging
            },
          },
        },

        typescript = {
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
              program = "${file}",          
              cwd = vim.fn.getcwd(),        
              sourceMaps = true,            
              protocol = 'inspector',       
              skipFiles = { "<node_internals>/**" }, 
              outFiles = { "${workspaceFolder}/dist/**/*.js" }, -- Define where the transpiled JS files are located
            },
          },
        },
      }

      -- Set DAP configurations
      -- Python
      dap.adapters.python = dap_config.python.adapter
      dap.configurations.python = dap_config.python.configurations

      -- Go
      dap.adapters.go = dap_config.go.adapter
      dap.configurations.go = dap_config.go.configurations

      -- Bash
      dap.adapters.bashdb = dap_config.bash.adapter
      dap.configurations.sh = dap_config.bash.configurations

      -- C
      dap.adapters.codelldb = dap_config.c.adapter
      dap.configurations.c = dap_config.c.configurations

      -- C++
      dap.adapters.cpp = dap_config.cpp.adapter
      dap.configurations.cpp = dap_config.cpp.configurations

      -- JavaScript
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
      local mason = require("mason")
      local mason_nvim_dap = require("mason-nvim-dap")

      mason.setup()
      mason_nvim_dap.setup({
        ensure_installed = { 
          "debugpy", 
          "delve", 
          "codelldb", 
          "node-debug2-adapter", 
          "bash-debug-adapter", 
        },
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
