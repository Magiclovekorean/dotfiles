return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        svelte = { "prettier" },
        json = { "prettier" },
        lua = { "stylua" },
        python = { "ruff_organize_imports", "ruff_format" },
        nix = { "alejandra" }
      },
        
    formatters = {
        prettier = {
          prepend_args = { "--tab-width", "4" },
        },
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
        },
    },
},

    config = function(_, opts)
      require("conform").setup(opts)

      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function(args)
          require("conform").format({ bufnr = args.buf })
        end,
      })
    end,
  },
}
