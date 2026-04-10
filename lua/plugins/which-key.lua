return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = {
    preset = "helix",
    delay = 300,
    spec = {
      { "<leader>g", group = "+Git" },
      { "<leader>gh", group = "hunks" },
      { "[`", desc = "Prev mark" },
      { "]`", desc = "Next mark" },
      { "<leader>a", group = "+AI" },
      { "<leader>o", group = "+Opencode" },
      { "<leader>fy", group = "+yank filepath" },
      { "<leader>c", group = "+Code" },
      { "<leader>cl", group = "+LSP" },
      { "<leader>s", group = "+Search" },
      { "<leader>u", group = "+UI" },
      { "<leader>w", group = "+Wiki" },
      { "<leader><Tab>", group = "+Tabs" },
      { "<leader>f", group = "+Files/Find" },
      { "<leader>b", group = "+Buffers" },
      { "<leader>x", group = "+diagnostics/quickfix" },
      { "<leader>q", group = "+quit/session" },
      { "<leader>h", group = "+haunt" },
      { "[", group = "prev" },
      { "]", group = "next" },
      { "g", group = "goto" },
      { "gz", group = "+Surround" },
      { "z", group = "fold" },
    },
    win = {
      height = {
        max = math.huge,
      },
    },
    plugins = {
      spelling = {
        enabled = false,
      },
    },
    icons = {
      rules = false,
      breadcrumb = "",
      separator = "󱦰",
      group = "󰹍 ",
    },
  },
  keys = {},
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
  end,
}
