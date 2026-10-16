-- https://github.com/folke/trouble.nvim

return {
  "folke/trouble.nvim",
  opts = {
    modes = {
      lsp_incoming_calls = {
        keys = {
          -- <cr> lands on the *caller's definition* (A), not on the `B()`
          -- call-site line that trouble jumps to by default.
          --
          -- Trouble keeps the raw CallHierarchyItem in `item.item.symbol`,
          -- so for incoming calls that is the caller (A) and its
          -- `uri`/`selectionRange`/`range` point at A's definition.
          ["<cr>"] = function(view, ctx)
            local trouble = require("trouble")
            local item = ctx and ctx.item
            local sym = item and item.item and item.item.symbol

            if sym and sym.uri and (sym.selectionRange or sym.range) then
              local client = item.item.client_id and vim.lsp.get_client_by_id(item.item.client_id) or nil
              local encoding = client and client.offset_encoding or "utf-16"
              -- jump from the main window so focus lands there
              local main = view:main()
              vim.api.nvim_win_call(main.win, function()
                vim.lsp.util.show_document(
                  { uri = sym.uri, range = sym.selectionRange or sym.range },
                  encoding,
                  { focus = true }
                )
              end)
              view:close()
            elseif item then
              view:jump(item)
            else
              trouble.close()
            end
          end,
          -- <S-CR> keeps trouble's default jump: the `B()` call-site line.
          ["<S-CR>"] = "jump",
        },
      },
      -- lsp_outgoing_calls: no override needed. Trouble's default <cr> jumps
      -- to the callee's definition (item.pos = its `selectionRange`).
    },
  },
  cmd = "Trouble",
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
    { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
    { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
    { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
  },
}
