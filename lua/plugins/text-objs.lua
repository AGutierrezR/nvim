return {
  "chrisgrieser/nvim-various-textobjs",
  config = function()
    -- default config
    require("various-textobjs").setup({
      -- set to 0 to only look in the current line
      lookForwardSmall = 2,
      lookForwardBig = 0,
      -- use suggested keymaps (see overview table in README)
      useDefaultKeymaps = false,
      -- disable only some default keymaps, e.g. { "ai", "ii" }
      disabledKeymaps = {},
    })

    vim.keymap.set({ 'o', 'x' }, 'ie', '<cmd>lua require("various-textobjs").entireBuffer()<CR>')
    vim.keymap.set({ 'o', 'x' }, 'il', '<cmd>lua require("various-textobjs").lineCharacterwise("inner")<CR>')

  end
}
