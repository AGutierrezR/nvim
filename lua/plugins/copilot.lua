return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  build = ":Copilot auth",
  opts = {
    server_opts_overrides = {
      settings = {
        telemetry = {
          telemetryLevel = "off",
        },
      },
    },
    suggestion = {
      -- enabled = false,
      auto_trigger = false,
      keymap = {
        accept = false,
        accept_word = false,
        accept_line = false,
        next = "<C-g>", -- '<M-]>'
        prev = "<C-G>", -- '<M-[>'
        dismiss = "<C-e>", -- '<Esc>'
      },
    },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
      yaml = true,
    },
    copilot_node_command = vim.env.HOME .. "/Library/Caches/fnm_multishells/976_1768269005343/bin/node", -- Node.js version must be > 20
  },
  keys = {
    {
      "<Tab>",
      function()
        if require("copilot.suggestion").is_visible() then
          require("copilot.suggestion").accept()
          return
        end
        return "<Tab>" -- Fallback to normal tab.
      end,
      mode = { "i" },
      desc = "Copilot: Accept",
      expr = true,
    },
  },
}
