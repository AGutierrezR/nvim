local filetypes = {
  { text = "markdown" },
  { text = "javascript" },
  { text = "html" },
  { text = "css" },
  { text = "typescript" },
  { text = "go" },
  { text = "json" },
  { text = "lua" },
  { text = "typescriptreact" },
  { text = "javascriptreact" },
}

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = {
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "/", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          {
            icon = " ",
            key = "r",
            desc = "Recent Files",
            action = ":lua Snacks.picker.recent({ filter = { cwd = true } })",
          },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { icon = " ", title = "Recent Files", cwd = true, section = "recent_files", indent = 0, padding = 2 },
        { section = "startup" },
      },
    },
    explorer = {
      enabled = true,
    },
    indent = { enabled = false },
    input = { enabled = false },
    picker = {
      layouts = {
        default = {
          layout = {
            box = "horizontal",
            width = 0.82,
            min_width = 120,
            height = 0.8,
            {
              box = "vertical",
              border = "rounded",
              title = "{title} {live} {flags}",
              { win = "input", height = 1, border = "bottom" },
              { win = "list", border = "none" },
            },
            { win = "preview", title = "{preview}", border = "rounded", width = 0.6 },
          },
        },
      },

      sources = {
        explorer = {
          auto_close = true,
          win = {
            list = {
              keys = {
                ["-"] = "explorer_up",
              },
            },
          },
          layout = { layout = { position = "right" } },
        },
      },
      win = {
        input = {
          keys = {
            -- to close the picker on ESC instead of going to normal mode,
            -- add the following keymap to your config
            -- ["<Esc>"] = { "close", mode = { "n", "i" } },
            ["<c-n>"] = { "history_forward", mode = { "i", "n" } },
            ["<c-p>"] = { "history_back", mode = { "i", "n" } },
            -- ["<a-s>"] = { "flash", mode = { "n", "i" } },
            -- ["s"] = { "flash" },
          },
        },
      },
      -- actions = {
      --   flash = function(picker)
      --     require("flash").jump({
      --       pattern = "^",
      --       label = { after = { 0, 0 } },
      --       search = {
      --         mode = "search",
      --         exclude = {
      --           function(win)
      --             return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
      --           end,
      --         },
      --       },
      --       action = function(match)
      --         local idx = picker.list:row2idx(match.pos[1])
      --         picker.list:_move(idx, true, true)
      --       end,
      --     })
      --   end,
      -- },
      formatters = {
        file = { filename_first = true, truncate = 999 },
      },
    },
    notifier = { enabled = false },
    quickfile = { enabled = true },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
  },
  keys = {
    {
      "<leader>/",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep",
    },
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>bb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers List",
    },
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>bk",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>bo",
      function()
        Snacks.bufdelete.other()
      end,
      desc = "Delete Other Buffers",
    },
    {
      "<leader>b/",
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = "Grep Buffers",
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent({ filter = { cwd = true } })
      end,
      desc = "Recent",
    },
    {
      "<leader>fe",
      function()
        Snacks.picker.explorer()
      end,
      desc = "Explorer",
    },
    {
      "<leader>fc",
      function()
        Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Config Files",
    },
    {
      "<leader>fz",
      function()
        Snacks.picker.zoxide()
      end,
      desc = "Zoxide",
    },
    {
      "<leader>fp",
      function()
        Snacks.picker.projects({
          win = {
            input = {
              keys = {
                ["<CR>"] = { { "tcd", "picker_files" }, mode = { "n", "i" } },
              }
            }
          }
        })
      end,
      desc = "Projects",
    },

    -- { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },

    -- Search
    {
      "<leader>sl",
      function()
        Snacks.picker.lines()
      end,
      desc = "Buffer lines",
    },
    {
      "<leader>sb",
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = "Grep Buffers",
    },
    {
      "<leader>sc",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command History",
    },
    {
      "<leader>:",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command History",
    },
    {
      "<leader>sC",
      function()
        Snacks.picker.commands()
      end,
      desc = "Commands",
    },
    {
      "<leader>sd",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "Buffer Diagnostics",
    },
    {
      "<leader>sD",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "Diagnostics",
    },
    {
      "<leader>sg",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep",
    },
    {
      "<leader>sj",
      function()
        Snacks.picker.jumps()
      end,
      desc = "Jumps",
    },
    {
      "<leader>sk",
      function()
        Snacks.picker.keymaps({
          layout = "vertical",
        })
      end,
      desc = "Keymaps",
    },
    {
      "<leader>sm",
      function()
        Snacks.picker.marks({
          global = false,
        })
      end,
      desc = "Marks",
    },
    {
      "<leader>sq",
      function()
        Snacks.picker.qflist()
      end,
      desc = "Quickfix List",
    },
    {
      "<leader>sR",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume",
    },
    {
      "<leader><Space>",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume",
    },
    {
      "<leader>sw",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "Search word",
      mode = { "n", "x" },
    },
    {
      '<leader>s"',
      function()
        Snacks.picker.registers()
      end,
      desc = "Registers",
    },
    {
      "<leader>s/",
      function()
        Snacks.picker.search_history()
      end,
      desc = "Search History",
    },

    -- Yanky
    {
      "<leader>sy",
      function()
        Snacks.picker.yanky()
      end,
      desc = "Yanky Ring History",
    },

    -- Undo
    {
      "<leader>su",
      function()
        Snacks.picker.undo()
      end,
      desc = "Undo History",
    },

    -- Scratchs
    -- {
    --   "<leader>.",
    --   function()
    --     require("config.snacks.scratch").new_scratch(filetypes)
    --   end,
    --   desc = "Toggle Scratch Buffer",
    -- },
    -- {
    --   "<leader>S",
    --   function()
    --     require("config.snacks.scratch").select_scratch()
    --   end,
    --   desc = "Select Scratch Buffer",
    -- },

    -- Spelling
    {
      "z=",
      function()
        Snacks.picker.spelling()
      end,
      desc = "Spelling suggestions",
    },

    {
      "<leader>gb",
      function()
        Snacks.picker.git_branches()
      end,
      desc = "Branches",
    },
    {
      "<leader>gc",
      function()
        Snacks.picker.git_log_file()
      end,
      desc = "Browse File Commits",
    },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log_line()
      end,
      desc = "Git Log line",
    },
    {
      "<leader>gC",
      function()
        Snacks.picker.git_log()
      end,
      desc = "Browse Commits",
    },
    {
      "<leader>gs",
      function()
        Snacks.picker.git_status()
      end,
      desc = "Branches",
    },
    {
      "<leader>gf",
      function()
        Snacks.picker.git_files()
      end,
      desc = "Git Files",
    },
    {
      "<leader>gS",
      function()
        Snacks.picker.git_stash()
      end,
      desc = "Git Stash",
    },
  },
}
