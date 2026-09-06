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

      -- Servers installed via nix(home-manager)
      local servers = {
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "lua_ls",
        "emmet_ls",
        "pyright",
        "texlab",
        "ltex_plus",
        "nixd",
        "ruff"
      }
      for _, server in ipairs(servers) do
        vim.lsp.config(server, {
            capabilities  = capabilities,
        })
        vim.lsp.enable(server)
      end
        
    end
  },
}

