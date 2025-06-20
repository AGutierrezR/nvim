return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  build = ":Copilot auth",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      -- keymap = {
        -- accept = "<M-l>",
        -- accept_word = "<M-w>",
        -- accept_line = "<M-;>",
        -- next = "<M-]>",
        -- prev = "<M-[>",
        -- dismiss = "<C-]>",
      -- },
    },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
      yaml = true,
    },
    copilot_node_command = vim.env.HOME .. "/.local/state/fnm_multishells/53454_1750406890102/bin/node", -- Node.js version must be > 20
  },
  -- keys = {
  --   { "<leader>cd", ":Copilot disable<CR>", silent = true },
  --   { "<leader>ce", ":Copilot enable<CR>", silent = true },
  -- },
}
