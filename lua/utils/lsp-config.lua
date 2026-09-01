local M = {}

M.lsp_info_buffer = function()
  vim.cmd(":lua vim.print(vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({ bufnr = 0 })))")
end

M.lsp_restart = function()
  local clients = vim.lsp.get_clients()

  if #clients == 0 then
    vim.notify("No hay LSP activos", vim.log.levels.WARN)
    return
  end

  vim.ui.select(clients, {
    prompt = "Reiniciar LSP:",
    format_item = function(client)
      return client.name
    end,
  }, function(client)
    if not client then
      return
    end

    vim.cmd("lsp restart " .. client.name)
  end)
end

return M
