-- Highlight when yanking (copying) text
-- See `:help vim.highlight.on_yank()`
--
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-hightlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- LSP Attach event
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    -- Uncomment this if you want to enable autocompletion (witout blink or else).
    -- local client = vim.lsp.get_client_by_id(ev.data.client_id)
    -- if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
    --   vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }
    --   vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    --   vim.keymap.set("i", "<C-Space>", function()
    --     vim.lsp.completion.get()
    --   end)
    -- end

    -- Function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("gd", require("snacks").picker.lsp_definitions, "Goto Definition")
    map("gI", require("snacks").picker.lsp_implementations, "Goto Implementation")
    map("gr", require("snacks").picker.lsp_references, "Goto References")
    map("gD", require("snacks").picker.lsp_type_definitions, "Goto Type Definition")
    map("K", vim.lsp.buf.hover, "")
    map("<leader>ca", require("fzf-lua").lsp_code_actions, "Code Action")
    map("<leader>cs", require("fzf-lua").lsp_document_symbols, "Goto Document Symbols")
    map("<leader>ss", require("fzf-lua").lsp_document_symbols, "Goto Document Symbols")
    map("<leader>cS", require("fzf-lua").lsp_live_workspace_symbols, "GoTo Workspace Symbols")
    map("<leader>cr", vim.lsp.buf.rename, "Rename Symbol")
    map("<leader>cd", require("snacks").picker.diagnostics_buffer, "Document Diagnostics")

    vim.keymap.set("n", "<leader>cl", function()
      vim.diagnostic.open_float(0, { scope = "line" })
    end, { desc = "Line Diagnostics" })

    vim.keymap.set("n", "<leader>cm", "<cmd>Manso<cr>", { desc = "Cursor Diagnostics" })

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
        end,
      })
    end

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map("<leader>ct", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, "[T]oggle Inlay Hints")
    end
  end,
})
