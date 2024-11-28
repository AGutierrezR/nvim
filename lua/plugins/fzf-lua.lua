return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- calling `setup` is optional for customization
    require("fzf-lua").setup({
      defaults = {
        git_icons = false,
        file_icons = false,
        color_icons = false
      },
      files = {
        cwd_prompt = false
      },
      lsp = {
        symbols = {
          prompt = "❯ "
        }
      },
      marks = {
        marks = "[a-zA-Z]"
      },
      git = {
        files = {
          prompt = "❯ "
        },
        status = {
          prompt = "❯ "
        }
      },
    })

    vim.keymap.set('n', '<leader><leader>', require('fzf-lua').resume, { desc = 'FZF Resume' })

    vim.keymap.set('n', '<leader>f', require('fzf-lua').files, { desc = 'Search File' })
    vim.keymap.set('n', '<leader>/', require('fzf-lua').live_grep, { desc = 'Search by Grep' })
    vim.keymap.set('v', '<leader>/', require('fzf-lua').grep_visual, { desc = 'Find Selection' })
    vim.keymap.set('n', '<leader>7', require('fzf-lua').grep_cword, { desc = 'Search Word (under cursor)' })
    vim.keymap.set('n', '<leader>b', require('fzf-lua').buffers, { desc = 'Find existing buffers' })
    vim.keymap.set('n', '<leader>R', require('fzf-lua').registers, { desc = 'Registers' })
    vim.keymap.set('n', '<leader>?', require('fzf-lua').commands, { desc = 'Find Commands' })

    -- Git related keymaps 
    vim.keymap.set('n', '<leader>gc', require('fzf-lua').git_bcommits, { desc = 'Browse File Commits' })
    vim.keymap.set('n', '<leader>gC', require('fzf-lua').git_commits, { desc = 'Browse Commits' })
    vim.keymap.set('n', '<leader>gs', require('fzf-lua').git_status, { desc = 'Git Status' })
    vim.keymap.set('n', '<leader>gf', require('fzf-lua').git_files, { desc = 'Git Files' })
    vim.keymap.set('n', '<leader>gS', require('fzf-lua').git_stash, { desc = 'Git Stash' })

    -- Vim features
    vim.keymap.set('n', 'z=', require('fzf-lua').spell_suggest, { desc = 'Spelling suggestions' })
  end
}
