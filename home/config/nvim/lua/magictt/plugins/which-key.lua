return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {},
  config = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>d", group = "Diagnostics" },
      { "<leader>e", group = "Explorer" },
      { "<leader>f", group = "Find" },
      { "<leader>l", group = "Lazy panels" },
      { "<leader>m", group = "Mason" },
      { "<leader>n", group = "NoHighlight" },
      { "<leader>p", group = "File Explorer" },
      { "<leader>s", group = "Splits" },
      { "<leader>t", group = "Tabs" },
      { "<leader>w", group = "Workspace" },
      { "<leader>x", group = "Trouble" },
    })
  end,
}
