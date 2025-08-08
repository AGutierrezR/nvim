return {
  {
    "backdround/improved-search.nvim",
    event = "VeryLazy",
    enabled = true,
    config = function()
      local search = require("improved-search")

      -- vim.keymap.set({ "n", "x", "o" }, "n", search.stable_next, { noremap = true, silent = true, desc = "Next search result" })
      -- vim.keymap.set({ "n", "x", "o" }, "N", search.stable_previous, { noremap = true, silent = true, desc = "Previous search result" })

      vim.keymap.set({ "n" }, "!", search.current_word, { noremap = true, silent = true, desc = "Search for current word" })
      vim.keymap.set({ "n" }, "g!", search.current_word_strict, { noremap = true, silent = true, desc = "Search for current word (strict)" })

      -- vim.keymap.set({ "n" }, "#", search.current_word_strict, { noremap = true, silent = true, desc = "Search for current word (strict)" })
      -- vim.keymap.set({ "n" }, "g#", search.current_word, { noremap = true, silent = true })

      vim.keymap.set({ "x" }, "!", search.in_place, { noremap = true, silent = true, desc = "Search in place for current selection" })
      vim.keymap.set({ "x" }, "g!", search.in_place_strict, { noremap = true, silent = true, desc = "Search in place for current selection (strict)" })
      vim.keymap.set({ "x" }, "*", search.forward, { noremap = true, silent = true, desc = "Search forward for selection" })
      vim.keymap.set({ "x" }, "g*", search.forward_strict, { noremap = true, silent = true, desc = "Search forward for selection (strict)" })
      vim.keymap.set({ "x" }, "#", search.backward, { noremap = true, silent = true, desc = "Search backward for selection" })
      vim.keymap.set({ "x" }, "g#", search.backward_strict, { noremap = true, silent = true, desc = "Search backward for selection (strict)" })
    end,
  },
}
