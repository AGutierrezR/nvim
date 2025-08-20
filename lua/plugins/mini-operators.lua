return {
  -- Text edit operators
  "echasnovski/mini.operators",
  event = { "BufReadPost", "BufNewFile" },
  version = false,
  config = function()
    -- Each entry configures one operator.
    require("mini.operators").setup({
      -- Evaluate text and replace with output
      evaluate = {
        prefix = "",
      },

      -- Exchange text regions
      exchange = {
        prefix = "cx",

        -- Whether to reindent new text to match previous indent
        reindent_linewise = true,
      },

      -- Multiply (duplicate) text
      multiply = {
        prefix = "cm",

        -- Function which can modify text before multiplying
        func = nil,
      },

      -- Replace text with register
      replace = {
        prefix = "cr",

        -- Whether to reindent new text to match previous indent
        reindent_linewise = true,
      },

      -- Sort text
      sort = {
        prefix = "cs",

        -- Function which does the sort
        func = nil,
      },
    })
  end,
}
