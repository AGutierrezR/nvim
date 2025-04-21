return {
	"jsongerber/nvim-px-to-rem",
  event = { 'BufReadPre', 'BufNewFile' },
	config = true,
	--If you need to set some options replace the line above with:
	-- config = function()
	--     require('nvim-px-to-rem').setup()
	-- end,
}
