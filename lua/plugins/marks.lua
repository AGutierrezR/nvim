return {
  "chentoast/marks.nvim",
  event = "VeryLazy",
  opts = {},
  config = function ()
    require('marks').setup({
      mappings = {
        next = ']`',
        prev = '[`',
        next_bookmark = false,
        prev_bookmark = false,
      }
    })
  end
}
