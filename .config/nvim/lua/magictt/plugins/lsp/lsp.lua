return {
  {
    "hrsh7th/cmp-nvim-lsp",
    event = { "BufReadPre", "BufNewFile", "InsertEnter" },
    dependencies = {
      { "antosha417/nvim-lsp-file-operations", config = true },
      { "folke/lazydev.nvim", opts = {} },
      { "neovim/nvim-lspconfig" },
    },
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Servers are installed and enabled by mason (see mason.lua).
      -- Apply the cmp capabilities to every server here.
      vim.lsp.config("*", {
        capabilities = capabilities,
      })
    end,
  },
}
