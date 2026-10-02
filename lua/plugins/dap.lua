-- https://github.com/mfussenegger/nvim-dap
-- https://github.com/rcarriga/nvim-dap-ui

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui" },
      { "theHamsta/nvim-dap-virtual-text", opts = { commented = true } },
    },
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint({ condition = vim.fn.input("Breakpoint condition: ") }) end, desc = "Conditional breakpoint", },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Breakpoint", },
      { "<leader>dd", function() require("dap").continue() end, desc = "Continue", },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to cursor", },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step into", },
      { "<leader>dj", function() require("dap").down() end, desc = "Down", },
      { "<leader>dk", function() require("dap").up() end, desc = "Up", },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run last", },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step out", },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step over", },
      { "<leader>dP", function() require("dap").pause() end, desc = "Pause", },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "REPL", },
      { "<leader>ds", function() require("dap").session() end, desc = "Session", },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate", },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets", },
    },
    config = function()
      require("config.dap.node").setup()
    end,
  },
    {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "x"} },
      { "<leader>dW", function() require("dapui").elements.watches.add() end, mode = { "n", "v" }, desc = "Watch expression under cursor", },
      { "<leader>dR", function() require("dapui.util").send_to_repl(require("dapui.util").get_current_expr()) end, mode = { "n", "v" }, desc = "Send expression to REPL", }
    },
    opts = {
      layouts = {
        {
          elements = {
            { id = "watches", size = 1 / 3 },
            { id = "breakpoints", size = 1 / 3 },
            { id = "scopes", size = 1 / 3 },
          },
          size = 40, -- 40 columns
          position = "right",
        },
        {
          elements = {
            {id = "repl", size = 0.5},
            {id = "stacks", size = 0.5},
          },
          size = 0.25, -- 25% of total lines
          position = "bottom",
        },
      },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },
}
