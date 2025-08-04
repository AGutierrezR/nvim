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
  if target_register == "" or not target_register:match('^[a-zA-Z0-9"%+%-*]$') then
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

function OpenMiniFiles(path)
  local MiniFiles = require("mini.files")

  -- Usa el path actual si no se pasa ninguno
  if not path or path == "" then
    path = vim.fn.expand("%:p")
  end

  -- Si es un archivo, usa su directorio
  local stat = vim.loop.fs_stat(path)
  if stat and stat.type == "file" then
    path = vim.fn.fnamemodify(path, ":h")
  end

  MiniFiles.open(path)
end

vim.api.nvim_create_user_command("MiniFilesOpen", function(opts)
  OpenMiniFiles(opts.args)
end, {
  nargs = "?", -- Optional argument for path
  complete = "file", -- 👈 This allows tab completion for file and directory names
})

-- Add current position to quickfix list
vim.api.nvim_create_user_command("QFAddPosition", function()
  vim.fn.setqflist({
    {
      filename = vim.fn.expand("%:p"),
      lnum = vim.fn.line("."),
      col = vim.fn.col("."),
      text = vim.fn.getline("."),
    },
  }, "a")

  -- Notify the user that the position has been added
  print("Current position added to quickfix list.")
end, {})


vim.api.nvim_create_user_command("QFNew", function()
  vim.fn.setqflist({}, 'r')

  -- Notify the user that the quickfix list has been cleared
  print("Quickfix list cleared.")
end, {})

-- LSP configuration and management
-- https://github.com/ruicsh/nvim-config/blob/b91d45fec2da4eb0a818ec28fec7e1b7a549d5b8/plugin/commands/lsp.lua

vim.api.nvim_create_user_command("LspEnable", function()
	local disabled_servers = vim.fn.env_get_list("LSP_DISABLED_SERVERS")

	local lsp_configs = {}
	for _, f in pairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
		local server_name = vim.fn.fnamemodify(f, ":t:r")
		-- Skip if on the disabled list
		if not vim.tbl_contains(disabled_servers, server_name) then
			table.insert(lsp_configs, server_name)
		end
	end

	vim.lsp.enable(lsp_configs)
end, {})

-- https://www.reddit.com/r/neovim/comments/1kzdd5x/restartlsp_but_for_native_vimlsp/
vim.api.nvim_create_user_command("LspRestart", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	vim.lsp.stop_client(clients, true)

	local timer = vim.uv.new_timer()

	timer:start(500, 0, function()
		for _, _client in ipairs(clients) do
			vim.schedule_wrap(function(client)
				vim.lsp.enable(client.name)

				vim.cmd(":noautocmd write")
				vim.cmd(":edit")
			end)(_client)
		end
	end)
end, {})
