-- Rainbow-ize your indents in Neovim today!
return {
  'lukas-reineke/indent-blankline.nvim',
  event = "LazyFile",
  dependencies = {
    'TheGLander/indent-rainbowline.nvim'
  },
  main = 'ibl',
  opts = {},
  config = function (_, opts)
    require('ibl').setup(require('indent-rainbowline').make_opts({}))
  end
}
