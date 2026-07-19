return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- Install parsers
    local treesitter = require("nvim-treesitter")
    
    -- Install required parsers asynchronously
    treesitter.install({ 
      "json",
      "javascript",
      "typescript",
      "tsx",
      "jsx",
      "yaml",
      "html",
      "css",
      "prisma",
      "markdown",
      "markdown_inline",
      "svelte",
      "graphql",
      "bash",
      "lua",
      "vim",
      "dockerfile",
      "gitignore",
      "query",
      "vimdoc",
      "c",
      "astro",
    })

    -- Enable treesitter features for supported filetypes
    vim.api.nvim_create_autocmd('FileType', {
      pattern = {
        'json', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'tsx',
        'yaml', 'html', 'css', 'prisma', 'markdown',
        'svelte', 'graphql', 'bash', 'lua', 'vim',
        'dockerfile', 'gitignore', 'c', 'astro'
      },
      callback = function(args)
        -- Enable syntax highlighting
        vim.treesitter.start()
        
        -- Enable treesitter-based indentation
        vim.bo[args.buf].indentexpr = 'v:lua.vim.treesitter.foldexpr()'
      end,
    })

    -- Enable autotag
    require("nvim-ts-autotag").setup()
  end,
}
