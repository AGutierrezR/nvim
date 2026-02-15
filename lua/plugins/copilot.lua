return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  build = ":Copilot auth",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = "<Tab>",
        accept_word = false,
        accept_line = false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
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
}
