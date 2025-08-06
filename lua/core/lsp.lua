-- lsp
--------------------------------------------------------------------------------
-- See https://gpanders.com/blog/whats-new-in-neovim-0-11/ for a nice overview
-- of how the lsp setup works in neovim 0.11+.

-- This actually just enables the lsp servers.
-- The configuration is found in the lsp folder inside the nvim config folder,
-- so in ~.config/lsp/lua_ls.lua for lua_ls, for example.
vim.lsp.enable({
  "lua_ls",
  "ts_ls",
  "html",
  "cssls",
  "jsonls",
  "custom_elements_ls",
  "emmet-language-server",
  "eslint",
})

-- Diagnostics
vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      [vim.diagnostic.severity.WARN] = "WarningMsg",
    },
  },
})

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

local function lsp_info()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  print("═══════════════════════════════════")
  print("           LSP INFORMATION          ")
  print("═══════════════════════════════════")
  print("")

  -- Basic info
  print("󰈙 Language client log: " .. vim.lsp.get_log_path())
  print("󰈔 Detected filetype: " .. vim.bo.filetype)
  print("󰈮 Buffer: " .. bufnr)
  print("󰈔 Root directory: " .. (vim.fn.getcwd() or "N/A"))
  print("")

  if #clients == 0 then
    print("󰅚 No LSP clients attached to buffer " .. bufnr)
    print("")
    print("Possible reasons:")
    print("  • No language server installed for " .. vim.bo.filetype)
    print("  • Language server not configured")
    print("  • Not in a project root directory")
    print("  • File type not recognized")
    return
  end

  print("󰒋 LSP clients attached to buffer " .. bufnr .. ":")
  print("─────────────────────────────────")

  for i, client in ipairs(clients) do
    print(string.format("󰌘 Client %d: %s", i, client.name))
    print("  ID: " .. client.id)
    print("  Root dir: " .. (client.config.root_dir or "Not set"))
    print("  Command: " .. table.concat(client.config.cmd or {}, " "))
    print("  Filetypes: " .. table.concat(client.config.filetypes or {}, ", "))

    -- Server status
    if client.is_stopped() then
      print("  Status: 󰅚 Stopped")
    else
      print("  Status: 󰄬 Running")
    end

    -- Workspace folders
    if client.workspace_folders and #client.workspace_folders > 0 then
      print("  Workspace folders:")
      for _, folder in ipairs(client.workspace_folders) do
        print("    • " .. folder.name)
      end
    end

    -- Attached buffers count
    local attached_buffers = {}
    for buf, _ in pairs(client.attached_buffers or {}) do
      table.insert(attached_buffers, buf)
    end
    print("  Attached buffers: " .. #attached_buffers)

    -- Key capabilities
    local caps = client.server_capabilities
    local key_features = {}
    if caps.completionProvider then
      table.insert(key_features, "completion")
    end
    if caps.hoverProvider then
      table.insert(key_features, "hover")
    end
    if caps.definitionProvider then
      table.insert(key_features, "definition")
    end
    if caps.documentFormattingProvider then
      table.insert(key_features, "formatting")
    end
    if caps.codeActionProvider then
      table.insert(key_features, "code_action")
    end

    if #key_features > 0 then
      print("  Key features: " .. table.concat(key_features, ", "))
    end

    print("")
  end

  -- Diagnostics summary
  local diagnostics = vim.diagnostic.get(bufnr)
  if #diagnostics > 0 then
    print("󰒡 Diagnostics Summary:")
    local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }

    for _, diagnostic in ipairs(diagnostics) do
      local severity = vim.diagnostic.severity[diagnostic.severity]
      counts[severity] = counts[severity] + 1
    end

    print("  󰅚 Errors: " .. counts.ERROR)
    print("  󰀪 Warnings: " .. counts.WARN)
    print("  󰋽 Info: " .. counts.INFO)
    print("  󰌶 Hints: " .. counts.HINT)
    print("  Total: " .. #diagnostics)
  else
    print("󰄬 No diagnostics")
  end

  print("")
  print("Use :LspLog to view detailed logs")
  print("Use :LspCapabilities for full capability list")
end

-- Create command
vim.api.nvim_create_user_command("LspInfo", lsp_info, { desc = "Show comprehensive LSP information" })
