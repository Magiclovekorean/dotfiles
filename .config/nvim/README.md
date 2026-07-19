# Current nvim setup

## Requirements

| Dependency | Purpose |
|---|---|
| **Neovim** >= 0.11 | `vim.lsp.config`, `vim.lsp.enable`, `vim.diagnostic.jump` |
| **git** | `lazy.nvim`, nvim-tree, `99` plugin |
| **make** | Builds `telescope-fzf-native.nvim`, `LuaSnip` |
| **C compiler** (`gcc`/`clang`) | Treesitter parsers, `telescope-fzf-native` |
| **node / npm** | LSPs, `prettier`, `eslint_d`, `LuaSnip` jsregexp |
| **python3 / pip** | `black`, `isort`, `pylint`, `ipynb.nvim` |
| **lazygit** | `lazygit.nvim` |
| **tmux** | `vim-tmux-navigator` |
| **xclip / xsel** | Clipboard (`unnamedplus`) |
| **opencode** | `99v` AI integration |

### Treesitter parsers

json, javascript, typescript, tsx, jsx, yaml, html, css, prisma, markdown, markdown_inline, svelte, graphql, bash, lua, vim, dockerfile, gitignore, query, vimdoc, c, astro

### Mason-managed formatters/linters

- **prettier** - JS/TS/HTML/CSS/Svelte/JSON
- **stylua** - Lua
- **isort** / **black** / **pylint** - Python
- **eslint_d** - JS/TS
