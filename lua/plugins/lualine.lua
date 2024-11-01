return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'yavorski/lualine-macro-recording.nvim'
  },
  opts = {
    sections = {
      lualine_c = { 'filename', 'macro_recording' },
      lualine_x = { 'encoding', 'filetype' },
    }
  },
  config = function(_, opts)
    require('lualine').setup(opts)
  end
}
