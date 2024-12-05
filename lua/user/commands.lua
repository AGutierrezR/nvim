vim.api.nvim_create_user_command("BufOnly", function()
  -- Create z mark, close all buffers, restore current, go to z marks and delete z mark
  vim.cmd([[
    mark z
    %bd
    e#
    bd#
    normal `z
    delmarks z
  ]])
end, {})

