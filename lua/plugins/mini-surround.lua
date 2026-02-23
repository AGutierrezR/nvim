local keys = {
  { "gza", op = "add", desc = "Add Surrounding", mode = { "n", "x" } },
  { "gzd", op = "delete", desc = "Delete Surrounding", mode = { "n" } },
  { "gzf", op = "find", desc = "Find Right Surrounding", mode = { "n" } },
  { "gzr", op = "replace", desc = "Replace Surrounding", mode = { "n" } },
}

return {
  {
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
  {
    "mattn/emmet-vim",
    ft = { "html", "css", "vue", "blade", "javascript", "typescript" },
    init = function()
      vim.g.user_emmet_settings = { variables = { lang = "ja" } }
      vim.g.user_emmet_leader_key = "<C-E>" --change to <C-e> to avoid conflict with completion
      vim.g.user_emmet_mode = "a" -- enable Emmet in all modes (default is only in normal and visual)
      vim.g.user_emmet_install_global = 0
      vim.keymap.set("i", "<C-L>", "<C-E>,", { remap = true })
      vim.keymap.set("v", "<C-L>", "<C-E>,", { remap = true })
    end,
    config = function()
      if vim.fn.exists(":EmmetInstall") == 2 then
        vim.cmd("EmmetInstall")
      end
    end,
  },
}
