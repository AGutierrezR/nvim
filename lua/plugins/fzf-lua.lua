return {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
  -- optional for icon support
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- calling `setup` is optional for customization
    require("fzf-lua").setup({
      defaults = {
        git_icons = false,
        file_icons = false,
        color_icons = false,
        formatter = "path.filename_first",
      },
      keymap = {
        fzf = {
          ["ctrl-q"] = "select-all+accept",
        },
      },
      oldfiles = {
        cwd_only = true,
        include_current_session = true,
      },
      files = {
        cwd_prompt = false,
      },
      lsp = {
        symbols = {
          prompt = "❯ ",
        },
      },
      marks = {
        marks = "[a-zA-Z]",
      },
      git = {
        files = {
          prompt = "❯ ",
        },
        status = {
          prompt = "❯ ",
        },
      },
      winopts = {
        on_create = function ()
          vim.keymap.set("t", "<C-r>", [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true, buffer = true })
        end
      }
    })
    -- -- use `fzf-lua` for replace vim.ui.select
    -- require("fzf-lua").register_ui_select()

    -- Search Keymaps
    vim.keymap.set("n", "<leader>sb", require("fzf-lua").lgrep_curbuf, { desc = "Buffer Lines" })
    vim.keymap.set("n", "<leader>sc", require("fzf-lua").command_history, { desc = "Command History" })
    vim.keymap.set("n", "<leader>sC", require("fzf-lua").commands, { desc = "Commands" })
    vim.keymap.set("n", "<leader>sd", require("fzf-lua").diagnostics_document, { desc = "Buffer Diagnostics" })
    vim.keymap.set("n", "<leader>sD", require("fzf-lua").diagnostics_workspace, { desc = "Diagnostics" })
    vim.keymap.set("n", "<leader>sg", require("fzf-lua").live_grep, { desc = "Grep" })
    vim.keymap.set("n", "<leader>sj", require("fzf-lua").jumps, { desc = "Jumps" })
    vim.keymap.set("n", "<leader>sk", require("fzf-lua").keymaps, { desc = "Keymaps" })
    vim.keymap.set("n", "<leader>sm", require("fzf-lua").marks, { desc = "Marks" })
    vim.keymap.set("n", "<leader>sq", require("fzf-lua").quickfix, { desc = "Quickfix List" })
    vim.keymap.set("n", "<leader>sR", require("fzf-lua").resume, { desc = "Resume" })
    vim.keymap.set("n", "<leader>sw", require("fzf-lua").grep_cword, { desc = "Search Word" })
    vim.keymap.set("v", "<leader>sw", require("fzf-lua").grep_visual, { desc = "Search Word" })
    vim.keymap.set("n", '<leader>s"', require("fzf-lua").registers, { desc = "Registers" })
    vim.keymap.set("n", "<leader>s/", require("fzf-lua").search_history, { desc = "Search History" })

    -- File Keymaps
    vim.keymap.set("n", "<leader>f", require("fzf-lua").files, { desc = "Search File" })
    vim.keymap.set("n", "<leader>F", require("fzf-lua").oldfiles, { desc = "Search File" })
    vim.keymap.set("n", "<leader>/", require("fzf-lua").live_grep, { desc = "Search by Grep" })
    vim.keymap.set("v", "<leader>/", require("fzf-lua").grep_visual, { desc = "Find Selection" })
    vim.keymap.set("n", "<leader>7", require("fzf-lua").grep_cword, { desc = "Search Word (under cursor)" })
    vim.keymap.set("n", "<leader>b", require("fzf-lua").buffers, { desc = "Find existing buffers" })
    vim.keymap.set("n", "<leader>R", require("fzf-lua").registers, { desc = "Registers" })
    vim.keymap.set("n", "<leader>?", require("fzf-lua").commands, { desc = "Find Commands" })
    vim.keymap.set("n", "<leader>z", require("fzf-lua").lgrep_curbuf, { desc = "Find on current buffer" })
    vim.keymap.set("n", "<leader>m", require("fzf-lua").marks, { desc = "Marks" })

    -- Git related keymaps
    vim.keymap.set("n", "<leader>gb", require("fzf-lua").git_branches, { desc = "Branches" })
    vim.keymap.set("n", "<leader>gc", require("fzf-lua").git_bcommits, { desc = "Browse File Commits" })
    vim.keymap.set("n", "<leader>gC", require("fzf-lua").git_commits, { desc = "Browse Commits" })
    vim.keymap.set("n", "<leader>gs", require("fzf-lua").git_status, { desc = "Git Status" })
    vim.keymap.set("n", "<leader>gf", require("fzf-lua").git_files, { desc = "Git Files" })
    vim.keymap.set("n", "<leader>gS", require("fzf-lua").git_stash, { desc = "Git Stash" })

    -- Vim features
    vim.keymap.set("n", "z=", require("fzf-lua").spell_suggest, { desc = "Spelling suggestions" })
  end,
}
