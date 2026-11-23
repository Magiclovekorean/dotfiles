return {
	"kylechui/nvim-surround",
	event = { "BufReadPre", "BufNewFile" },
	version = "*",
	init = function()
		vim.g.nvim_surround_no_visual_mappings = true
	end,
	config = function()
		require("nvim-surround").setup({})
		vim.keymap.set("x", "<leader>s", "<Plug>(nvim-surround-visual)", { desc = "Surround visual" })
		vim.keymap.set("x", "<leader>S", "<Plug>(nvim-surround-visual-line)", { desc = "Surround visual line" })
	end,
}
