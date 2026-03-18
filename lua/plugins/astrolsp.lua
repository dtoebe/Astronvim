-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = true, -- enabled: useful for Go param names, types
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true,
        allow_filetypes = {
          "go",
          "templ",
          "lua",
          "html",
          "javascript",
          "typescript",
          "css",
          "scss",
        },
        ignore_filetypes = {
          -- "python",
        },
      },
      disabled = {
        "lua_ls", -- use stylua instead
        "tsserver", -- use prettier instead
        "vtsls", -- use prettier instead
      },
      timeout_ms = 3000, -- increased: gofumpt/golines can be slow on large files
    },
    -- enable servers that you already have installed without mason
    servers = {
      "htmx", -- no Mason auto-setup, registered manually
    },
    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {
      -- HTMX: attach to html and templ files
      htmx = {
        filetypes = { "html", "templ" },
      },

      -- Emmet: attach to all relevant web filetypes
      emmet_ls = {
        filetypes = {
          "html",
          "css",
          "templ",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
        },
        init_options = {
          html = { options = { ["bem.enabled"] = true } },
        },
      },

      -- Tailwind: include templ files
      tailwindcss = {
        filetypes_include = { "templ" },
        init_options = {
          userLanguages = { templ = "html" },
        },
      },

      -- gopls: full analysis + inlay hints
      gopls = {
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
            gofumpt = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      },
    },
    -- customize how language servers are attached
    handlers = {
      -- function(server, opts) require("lspconfig")[server].setup(opts) end
      -- rust_analyzer = false,
      -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end
    },
    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      lsp_codelens_refresh = {
        cond = "textDocument/codeLens",
        {
          event = { "InsertLeave", "BufEnter" },
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
          end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
          end,
        },
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr)
      -- client.server_capabilities.semanticTokensProvider = nil
      -- Lighten up Inlay Hints for Dracula
      -- Dracula's "Comment" is often too dark for hints.
      -- We'll use a custom light grey/purple.
      vim.api.nvim_set_hl(0, "LspInlayHint", {
        fg = "#6272a4", -- A medium-light grey
        italic = true,
      })

      -- If you want them even lighter/more "Dracula-ish", use this instead:
      -- fg = "#6272a4" (Dracula Comment Purple)
      -- fg = "#f8f8f2" (Dracula Foreground White - very bright)
    end,
  },
}
