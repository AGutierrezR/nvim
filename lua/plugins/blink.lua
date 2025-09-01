-- Configuration base on https://github.com/linkarzu/dotfiles-latest/blob/24923656b83aafa9490e966106cb22d0443e1561/neovim/neobean/lua/plugins/blink-cmp.lua

-- NOTE: Specify the trigger character(s) used for luasnip
local trigger_text = ";"

return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "1.*",
    dependencies = {
      -- Snippet Engine
      {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            "rafamadriz/friendly-snippets",
            config = function()
              -- Load snippets from the `friendly-snippets` package and from my custom snippets
              require("luasnip.loaders.from_vscode").lazy_load({ 
                paths = { vim.fn.expand("~/.config/nvim/snippets") } 
              })
            end,
          },
        },
        opts = {},
      },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = "default" },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
      },
      signature = { enabled = true },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = {
          "lsp",
          "path",
          "buffer",
          "snippets",
        },

        providers = {
          lsp = {
            name = "LSP",
            module = "blink.cmp.sources.lsp",
            score_offset = 150, -- the higher the number, the higher the priority
            -- Filter text items from the LSP provider, since we have the buffer provider for that
          },
          path = {
            name = "Path",
            module = "blink.cmp.sources.path",
            score_offset = 25,
            fallbacks = { "snippets", "buffer" },
            opts = {
              trailing_slash = false,
              label_trailing_slash = true,
              show_hidden_files_by_default = true,
            },
            -- enabled = function()
            --   -- Disable path completions in the copilot-chat filetype
            --   return vim.bo.filetype ~= "copilot-chat"
            -- end,
          },
          buffer = {
            name = "Buffer",
            module = "blink.cmp.sources.buffer",
            min_keyword_length = 2,
            score_offset = 15, -- the higher the number, the higher the priority
          },
          snippets = {
            name = "Snippets",
            module = "blink.cmp.sources.snippets",
            min_keyword_length = 2,
            score_offset = 60, -- the higher the number, the higher the priority
            -- Only show snippets if I type the trigger_text characters, so
            -- to expand the "cl" snippet, if the trigger_text is ";" I have to
            should_show_items = function()
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
              -- NOTE: remember that `trigger_text` is modified at the top of the file
              return before_cursor:match(trigger_text .. "%w*$") ~= nil
            end,
            -- After accepting the completion, delete the trigger_text characters
            -- from the final inserted text
            transform_items = function(_, items)
              local line = vim.api.nvim_get_current_line()
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local before_cursor = line:sub(1, col)
              local start_pos, end_pos = before_cursor:find(trigger_text .. "[^" .. trigger_text .. "]*$")
              if start_pos then
                for _, item in ipairs(items) do
                  if not item.trigger_text_modified then
                    ---@diagnostic disable-next-line: inject-field
                    item.trigger_text_modified = true
                    item.textEdit = {
                      newText = item.insertText or item.label,
                      range = {
                        start = { line = vim.fn.line(".") - 1, character = start_pos - 1 },
                        ["end"] = { line = vim.fn.line(".") - 1, character = end_pos },
                      },
                    }
                  end
                end
              end
              return items
            end,
          },
        },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "lua" },

      -- By default, blink.cmp enabled cmdline completions (cmdline.enabled = true),
      -- By default, the completion menu will not be shown automatically.
      -- You may set cmdline.completion.menu.auto_show = true to have it appear automatically.
      cmdline = {
        keymap = {
          -- recommended, as the default keymap will only show and select the next item
          ["<Tab>"] = { "show", "accept" },
        },
        completion = {
          menu = {
            -- You may want to only show the menu only when writing commands, and not when searching or using other input menus.
            auto_show = function(ctx)
              return vim.fn.getcmdtype() == ":"
              -- enable for inputs as well, with:
              -- or vim.fn.getcmdtype() == '@'
            end,
          },
        },
      },
    },
    opts_extend = { "sources.default" },
  },
  -- Faster LuaLS setup for Neovim (it configures LuaLS for Neovim config editing)
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
