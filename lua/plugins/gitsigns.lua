-- Add git related signs to the gutter, as well as utilities to managing changes
return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' }
    },
    current_line_blame = true,
  },
  config = function (_, opts)
    require('gitsigns').setup(opts)

    vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', { desc = 'Preview hunk', silent = true })
    vim.keymap.set('n', '<leader>gt', ':Gitsigns toggle_current_line_blame<CR>', { desc = 'Toggle line blame', silent = true })
    vim.keymap.set('n', '<leader>gd', ':Gitsigns reset_hunk<CR>', { desc = 'Discard hunk', silent = true })
    vim.keymap.set('v', '<leader>gd', ':Gitsigns reset_hunk<CR>', { desc = 'Discard hunk', silent = true })
    vim.keymap.set('n', '<leader>gD', ':Gitsigns reset_buffer<CR>', { desc = 'Discard buffer changes', silent = true })
    vim.keymap.set('n', '<leader>gk', ':Gitsigns prev_hunk<CR>', { desc = 'Prev hunk', silent = true })
    vim.keymap.set('n', '<leader>gj', ':Gitsigns next_hunk<CR>', { desc = 'Next hunk', silent = true })

    vim.keymap.set('n', '<leader>ga', ':Gitsigns stage_buffer<CR>', { desc = 'Stage Buffer', silent = true })
    vim.keymap.set('n', '<leader>g+', ':Gitsigns stage_hunk<CR>', { desc = 'Stage hunk', silent = true })
    vim.keymap.set('v', '<leader>g+', ':Gitsigns stage_hunk<CR>', { desc = 'Stage hunk', silent = true })
    vim.keymap.set('n', '<leader>g-', ':Gitsigns undo_stage_hunk<CR>', { desc = 'Unstage hunk', silent = true })
  end
}
