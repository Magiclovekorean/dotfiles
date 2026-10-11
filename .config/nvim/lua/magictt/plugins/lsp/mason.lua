return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_enable = true,
      -- list of servers for mason to install
      ensure_installed = {
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
        "ruff",
      },
    },
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "prettier", -- js/ts/html/css/json formatter
        "stylua", -- lua formatter
        "ruff", -- python formatter
        "alejandra", -- nix formatter
      },
    },
    dependencies = {
      "mason-org/mason.nvim",
    },
  },
}
