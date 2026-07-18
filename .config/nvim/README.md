# Current nvim setup

## Requirements

### Core

- **Neovim** >= 0.11 (uses `vim.lsp.config`, `vim.lsp.enable`, `vim.diagnostic.jump`)
- **git** - plugin manager (`lazy.nvim`), nvim-tree git integration, `99` plugin
- **make** - builds for `telescope-fzf-native.nvim` and `LuaSnip`
- **C compiler** (`gcc` or `clang`) - compiles treesitter parsers and telescope-fzf-native

### Node.js

- **node / npm** - required by nearly all LSP servers and tools below
  - LSPs: `ts_ls`, `html`, `cssls`, `tailwindcss`, `svelte`, `graphql`, `emmet_ls`, `prismals`, `pyright`, `eslint`
  - Tools: `prettier`, `eslint_d`, `LuaSnip` jsregexp build

### Python

- **python3 / pip** - required by:
  - `black` (formatter)
  - `isort` (import sorting)
  - `pylint` (linter)
  - `ipynb.nvim` (Jupyter notebooks, expects a `venv/bin/python` per-project)

### CLI tools

- **lazygit** - used by `lazygit.nvim`
- **tmux** - used by `vim-tmux-navigator`
- **xclip** or **xsel** - clipboard provider (`clipboard = "unnamedplus"`)
- **opencode** - used by `99v`(ai integration)
 

### Treesitter parsers (compiled from source, need C compiler)

json, javascript, typescript, tsx, jsx, yaml, html, css, prisma, markdown, markdown_inline, svelte, graphql, bash, lua, vim, dockerfile, gitignore, query, vimdoc, c, astro

### Mason-managed formatters/linters

- **prettier** (Node.js) - JS/TS/HTML/CSS/Svelte/JSON
- **stylua** - Lua
- **isort** / **black** / **pylint** - Python (via pip)
- **eslint_d** - JS/TS linting daemon
```
