return {
  "gbprod/yanky.nvim",
  -- event = "LazyFile",
    keys = {
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } },

    { "[y", "<Plug>(YankyPreviousEntry)", mode = "n", desc = "Yanky: previous entry" },
    { "]y", "<Plug>(YankyNextEntry)", mode = "n", desc = "Yanky: next entry" },
  },
  cmd = { "YankyClearHistory", "YankyRingHistory" },
  lazy = true,
  opts = {
    ring = {
      update_register_on_cycle = true, -- Update the default register on cycle
    },
    system_clipboard = {
      sync_with_ring = false,
    },
    highlight = {
      on_put = false, -- Highlight on put
      on_yank = false, -- Highlight on yank
      timer = 0, -- Duration of highlight
    },
  },
  config = function(_, opts)
    require("yanky").setup(opts)
  end,

  -- config = function(_, opts)
  --   local yanky = require("yanky")
  --   yanky.setup(opts)
  --
  --   vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
  --   vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
  --
  --   vim.keymap.set("n", "[y", "<Plug>(YankyPreviousEntry)", { desc = "Select previous entry through yank history" } )
  --   vim.keymap.set("n", "]y", "<Plug>(YankyNextEntry)", { desc = "Select next entry through yank history" } )
  -- end,
}
