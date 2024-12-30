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

vim.api.nvim_create_user_command("FilePath", function()
  local file_path = vim.fn.expand("%:p")
  print(file_path)
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

vim.api.nvim_create_user_command("CopyFilePathToClipboard", function()
  -- Get the full path of the current file
  local file_path = vim.fn.expand("%:p")
  -- Check if the file has a valid path
  if file_path == "" then
    print("No file path available (unsaved buffer or no file loaded).")
    return
  end
  -- Copy the path to the clipboard
  vim.fn.setreg("+", file_path)
  print(string.format("File path copied to clipboard: %s", file_path))
end, {})

-- Copy relative file path to clipboard
vim.api.nvim_create_user_command("CopyRelativeFilePathToClipboard", function()
  local relative_path = vim.fn.expand("%:.")
  if relative_path == "" then
    print("No relative file path available (unsaved buffer or no file loaded).")
    return
  end
  -- Copy the relative path to the clipboard
  vim.fn.setreg("+", relative_path)
  print(string.format("Relative file path copied to clipboard: %s", relative_path))
end, {})

-- Copy file name to clipboard
vim.api.nvim_create_user_command("CopyFileNameToClipboard", function()
  local file_name = vim.fn.expand("%:t")
  if file_name == "" then
    print("No file name available (unsaved buffer or no file loaded).")
    return
  end
  -- Copy the filename to the clipboard
  vim.fn.setreg("+", file_name)
  print(string.format("File name copied to clipboard: %s", file_name))
end, {})

