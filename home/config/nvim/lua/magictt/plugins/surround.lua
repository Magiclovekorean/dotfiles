return {
	"kylechui/nvim-surround",
	event = { "BufReadPre", "BufNewFile" },
	version = "*",
	config = function()
		require("nvim-surround").setup({
			keymaps = {
				visual = "<leader>s",
				visual_line = "<leader>S",
			},
		})
	end,
}
