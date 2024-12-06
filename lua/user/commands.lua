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

-- Util function for YankToClipboard and MoveYankToRegister 
local function move_yank_to_register(target_register)
  -- Validate the target register
  if target_register == "" or not target_register:match("^[a-zA-Z0-9\"%+%-*]$") then
    print("Invalid register. Operation canceled.")
    return
  end
  -- Get the content and type of the yank register
  local yank_content = vim.fn.getreg("0")
  local yank_type = vim.fn.getregtype("0")
  -- Move the content to the specified register
  vim.fn.setreg(target_register, yank_content, yank_type)
  -- Clear the yank register
  vim.fn.setreg("0", "")
  print(string.format("Text moved to register '%s'.", target_register))
end

vim.api.nvim_create_user_command("YankToClipboard", function()
  move_yank_to_register("+")
end, {})

vim.api.nvim_create_user_command("MoveYankToRegister", function(opts)
  -- Determine the target register: use the argument if provided, otherwise prompt the user
  local target_register = opts.args ~= "" and opts.args or vim.fn.input("Move yank to register: ")

  move_yank_to_register(target_register)
end, {
  nargs = "?", -- Optional argument
})


