return {
  "sphamba/smear-cursor.nvim",
  opts = function()
    require("snacks").toggle({
      name = "Smear Cursor",
      get = function()
        return require("smear_cursor").enabled
      end,
      set = function(state)
        if state then
          vim.cmd("SmearCursorToggle")
        else
          vim.cmd("SmearCursorToggle")
        end
      end,
    }):map('<leader>uc')


    return {
      enabled = false,
    }
  end,
}
