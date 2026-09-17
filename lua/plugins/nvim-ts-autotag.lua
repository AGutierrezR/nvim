-- https://github.com/windwp/nvim-ts-autotag

return {
  'windwp/nvim-ts-autotag',
  event = "LazyFile",
  ft = {
    'html',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact'
  },
  config = function ()
    require( 'nvim-ts-autotag').setup()
  end
}
