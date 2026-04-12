-- lua/plugins/astrolsp.lua

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    features = {
      codelens = true,
      inlay_hints = true,
      semantic_tokens = true,
    },
    formatting = {
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
          "python",
        },
        ignore_filetypes = {},
      },
      disabled = {
        "lua_ls",
        "tsserver",
        "vtsls",
      },
      timeout_ms = 3000,
    },
    servers = {
      "htmx",
    },
    ---@diagnostic disable: missing-fields
    config = {
      htmx = {
        filetypes = { "html", "templ" },
      },
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
      tailwindcss = {
        filetypes_include = { "templ" },
        init_options = {
          userLanguages = { templ = "html" },
        },
      },
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
    handlers = {},
    -- NOTE: autocmds here are buffer-scoped (run on LSP attach), so NO pattern allowed
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
      -- otter_attach removed: now lives in polish.lua as a global autocmd
    },
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
    on_attach = function(client, bufnr)
      vim.api.nvim_set_hl(0, "LspInlayHint", {
        fg = "#6272a4",
        italic = true,
      })
    end,
  },
}
