local keys = {
  { "sa", op = "add", desc = "Add Surrounding", mode = { "n", "x" } },
  { "sd", op = "delete", desc = "Delete Surrounding", mode = { "n" } },
  { "sf", op = "find", desc = "Find Right Surrounding", mode = { "n" } },
  { "sr", op = "replace", desc = "Replace Surrounding", mode = { "n" } },
}

return {
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "sa", -- Add surrounding in Normal and Visual modes
        delete = "sd", -- Delete surrounding
        find = "sf", -- Find surrounding (to the right)
        find_left = "", -- Find surrounding (to the left)
        highlight = "", -- Highlight surrounding
        replace = "sr", -- Replace surrounding
        update_n_lines = "", -- Update `n_lines`
      },
      respect_selection_type = true,
    },
    keys = function()
      -- With this function and the `keys` table defined above, we can generate the key mappings specification for the plugin
      -- that can be seen by which-key and also used for lazy loading the plugin when any of the keys is pressed.
      local keys_spec = {}

      -- Build key mappings specification
      for _, key in ipairs(keys) do
        table.insert(keys_spec, { key[1], desc = key.desc, mode = key.mode })
      end

      return keys_spec
    end,
  },
}
