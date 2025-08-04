-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/emmet_language_server.lua
-- https://github.com/ruicsh/nvim-config/blob/b91d45fec2da4eb0a818ec28fec7e1b7a549d5b8/lsp/emmet-language-server.lua

return {
  cmd = { "emmet-language-server", "--stdio" },
  filetypes = {
    "css",
    "eruby",
    "html",
    "htmldjango",
    "javascriptreact",
    "less",
    "pug",
    "sass",
    "scss",
    "typescriptreact",
    "htmlangular",
  },
  root_markers = { ".git" },
}
