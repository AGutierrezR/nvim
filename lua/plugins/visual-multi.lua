-- Multiple cursors plugin for vim/neovim
return {
	"mg979/vim-visual-multi",
  enabled = false,
  event = { 'BufReadPre', 'BufNewFile' },
}
