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
}
