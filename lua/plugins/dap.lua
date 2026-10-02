return {
  "mfussenegger/nvim-dap",
  dependencies = {
    { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" }, opts = {} },
    { "theHamsta/nvim-dap-virtual-text", opts = { commented = true } },
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
    local dapui = require("dapui")

    require("config.dap.node").setup()

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

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ DAP UI Setup                                             │
    -- ╰──────────────────────────────────────────────────────────╯
    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸" },
      mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      -- Expand lines larger than the window
      -- Requires >= 0.7
      expand_lines = vim.fn.has("nvim-0.7"),
      -- Layouts define sections of the screen to place windows.
      -- The position can be "left", "right", "top" or "bottom".
      -- The size specifies the height/width depending on position. It can be an Int
      -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
      -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
      -- Elements are the elements shown in the layout (in order).
      -- Layouts are opened in order so that earlier layouts take priority in window sizing.
      layouts = {
        {
          elements = {
            { id = "watches", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
          },
          size = 40, -- 40 columns
          position = "left",
        },
        {
          elements = {
            "scopes",
            "repl",
          },
          size = 0.25, -- 25% of total lines
          position = "bottom",
        },
      },
      floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        border = "rounded", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      windows = { indent = 1 },
      render = {
        max_type_length = nil, -- Can be integer or nil.
      },
    })
  end,
}
