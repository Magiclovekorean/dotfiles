return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- source for file system paths
    {
      "L3MON4D3/LuaSnip",
      -- follow latest release.
      version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      -- install jsregexp (optional!).
      build = "make install_jsregexp",
    },
    "saadparwaiz1/cmp_luasnip", -- for autocompletion
    "rafamadriz/friendly-snippets", -- useful snippets
    "onsails/lspkind.nvim", -- vs-code like pictograms
    { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
  },
  config = function()
    local cmp = require("cmp")

    local luasnip = require("luasnip")

    local t = require("luasnip.nodes.textNode").T

    local lspkind = require("lspkind")

    local compare = require("cmp.config.compare")

    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

    -- qmlls only completes the properties of the type under the cursor, never the
    -- QML keywords themselves
    luasnip.add_snippets("qml", {
      luasnip.s("id", { t("id ${1:name}") }),
    })

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),

        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(), -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = "nvim_lsp"},
        { name = "luasnip" }, -- snippets
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
      }),

      -- qmlls answers with every name in scope at once: 276 items inside a
      -- PanelWindow, 152 of them type names, plus its own "property type name;"
      -- style snippets. cmp's default order puts snippets first, so an empty
      -- keyword opened the menu on "Text snippet"/"signal name;" instead of
      -- the properties. Rank the qmlls kinds, leaving typed matches first.
      sorting = {
        comparators = {
          compare.offset,
          compare.exact,
          compare.score,
          function(entry1, entry2)
            if entry1.source.name ~= "nvim_lsp" or entry2.source.name ~= "nvim_lsp" then return nil end
            local kind = cmp.lsp.CompletionItemKind
            local function tier(entry)
              local name = kind[entry.completion_item.kind]
              if name == "Property" or name == "Field" then return 0 end
              if name == "Method" then return 1 end
              if name == "Snippet" then return 2 end
              return 3
            end
            local tier1, tier2 = tier(entry1), tier(entry2)
            if tier1 ~= tier2 then return tier1 < tier2 end
            return nil
          end,
          compare.recently_used,
          compare.locality,
          compare.kind,
          compare.sort_text,
          compare.length,
          compare.order,
        },
      },

      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
        format = function(entry, item)
          local lspkind_format = lspkind.cmp_format({ mode = "symbol_text" })
          local formatted = lspkind_format(entry, item)
          return require("tailwindcss-colorizer-cmp").formatter(entry, formatted)
        end,
      },
    })
  end,

}
