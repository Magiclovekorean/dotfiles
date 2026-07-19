return {
  "ajbucci/ipynb.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "neovim/nvim-lspconfig",
    "nvim-tree/nvim-web-devicons",
    "folke/snacks.nvim",
  },
  opts = {
    kernel = {
        python_path = "venv/bin/python",
    },
    shadow = {
      location = "workspace",
      dir = ".ipynb.nvim",
    },
  },
}
