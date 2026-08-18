return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },

  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()
    require("telescope").load_extension("harpoon")
    require("which-key").add({
      { "<leader>h", group = "Harpoon" },
    })

    -- Basic keymaps
    vim.keymap.set("n", "<leader>ha", function()
      harpoon:list():add()
    end, { desc = "Harpoon: Add file" })
    vim.keymap.set("n", "<C-e>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon: Toggle menu" })
    vim.keymap.set("n", "<C-p>", function()
      harpoon:list():prev()
    end, { desc = "Harpoon: Previous file" })
    vim.keymap.set("n", "<C-n>", function()
      harpoon:list():next()
    end, { desc = "Harpoon: Next file" })

    vim.keymap.set('n', '<leader>fh', function() require("telescope").extensions.harpoon.marks(harpoon:list()) end, { desc = "Telescope harpoon" })

    -- NEW: Remove current file from Harpoon list
    vim.keymap.set("n", "<leader>hr", function()
      harpoon:list():remove()
    end, { desc = "Harpoon: Remove current file" })
  end,
}
