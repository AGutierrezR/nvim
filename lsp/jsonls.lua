-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/jsonls.lua
-- https://github.com/ruicsh/nvim-config/blob/b91d45fec2da4eb0a818ec28fec7e1b7a549d5b8/lsp/jsonls.lua

return {
	cmd = {
		"vscode-json-language-server",
		"--stdio",
	},
	filetypes = {
		"json",
		"jsonc",
	},
	root_markers = {
		".git",
	},

	init_options = { provideFormatter = true },
	single_file_support = true,
}
