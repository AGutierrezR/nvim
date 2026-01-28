-- local keys = {
--   { "gza", op = "add", desc = "Add Surrounding", mode = { "n", "x" } },
--   { "gzd", op = "delete", desc = "Delete Surrounding", mode = { "n" } },
--   { "gzf", op = "find", desc = "Find Right Surrounding", mode = { "n" } },
--   { "gzr", op = "replace", desc = "Replace Surrounding", mode = { "n" } },
-- }

return {
  "echasnovski/mini.surround",
  opts = {
    mappings = {
      add = "gza", -- Add surrounding in Normal and Visual modes
      delete = "gzd", -- Delete surrounding
      find = "gzf", -- Find surrounding (to the right)
      find_left = "", -- Find surrounding (to the left)
      highlight = "", -- Highlight surrounding
      replace = "gzr", -- Replace surrounding
      update_n_lines = "", -- Update `n_lines`
    },
  },
  keys = { "gz" }
  -- keys = function ()
  --   local keys_spec = {}
  --
  --   -- Build key mappings specification
  --   for _, key in ipairs(keys) do
  --     table.insert(keys_spec, { key[1], desc = key.desc, mode = key.mode })
  --   end
  --
  --   return keys_spec
  -- end,
}
