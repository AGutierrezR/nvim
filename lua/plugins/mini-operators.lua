return {
  -- Text edit operators
  "echasnovski/mini.operators",
  version = false,
  keys = {
    { "cx", desc = "Exchange text", mode = { "n", "x" } },
    { "cm", desc = "Multiply text", mode = { "n", "x" } },
    { "cr", desc = "Replace text with register", mode = { "n", "x" } },
    { "cs", desc = "Sort text", mode = { "n", "x" } },
  },
  opts = {
    evaluate = {
      prefix = "",
    },

    exchange = {
      -- Exchange text regions
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
  },
}
