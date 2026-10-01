-- see configurations from https://github.com/rezhaTanuharja/minimalistNVIM/blob/2b50b04cdfd57797940540c51cc63c8c492fb0ac/lua/debug_js.lua

local languages = {
  "javascript",
}

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" }, opts = {} },
    { "theHamsta/nvim-dap-virtual-text", opts = { commented = true } },
    {
      "microsoft/vscode-js-debug",
      version = "1.x",
      build = "rm -rf out/dist && npm ci && npm run compile vsDebugServerBundle && mv dist out",
    },
  },
  keys = {
    {
      "<leader>dd",
      function()
        require("dap").continue()
      end,
      desc = "Debug: continue",
    },
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Debug: breakpoint",
    },
    {
      "<leader>dB",
      function()
        require("dap").set_breakpoint({ condition = vim.fn.input("Breakpoint condition: ") })
      end,
      desc = "Debug: conditional breakpoint",
    },
    {
      "<leader>dp",
      function()
        require("dap").pause()
      end,
      desc = "Debug: pause",
    },
    {
      "<leader>di",
      function()
        require("dap").step_into()
      end,
      desc = "Debug: step into",
    },
    {
      "<leader>do",
      function()
        require("dap").step_over()
      end,
      desc = "Debug: step over",
    },
    {
      "<leader>dO",
      function()
        require("dap").step_out()
      end,
      desc = "Debug: step out",
    },
    {
      "<leader>dl",
      function()
        require("dap").run_last()
      end,
      desc = "Debug: run last",
    },
    {
      "<leader>dt",
      function()
        require("dap").terminate()
      end,
      desc = "Debug: terminate",
    },
    {
      "<leader>dR",
      function()
        require("dap").repl.open()
      end,
      desc = "Debug: REPL",
    },
    {
      "<leader>de",
      function()
        require("dap").eval()
      end,
      mode = { "n", "v" },
      desc = "Debug: evaluate",
    },
    {
      "<leader>du",
      function()
        require("dapui").toggle()
      end,
      desc = "Debug: toggle DAP UI",
    },
  },
  config = function()
    local dap = require("dap")

    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }

    dap.adapters["pwa-chrome"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }

    for _, language in ipairs(languages) do
      dap.configurations[language] = {
        -- Debug single nodejs files
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
        },
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch using Chrome",
          url = function()
            vim.cmd("redraw")
            return vim.fn.input("URL: ", "http://localhost:3000")
          end,
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
        },
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch using Edge",
          url = function()
            vim.cmd("redraw")
            return vim.fn.input("URL: ", "http://localhost:3000")
          end,
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
          runtimeExecutable = "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge",
        },
      }
    end

    dap.listeners.before.attach["dapui_config"] = function()
      require("dapui").open()
    end
    dap.listeners.before.launch["dapui_config"] = function()
      require("dapui").open()
    end
    dap.listeners.after.event_initialized["dapui_config"] = function()
      require("dapui").open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      require("dapui").close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      require("dapui").close()
    end
  end,
}
