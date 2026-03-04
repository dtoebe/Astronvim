if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- install language servers
        "lua-language-server",

        -- install formatters
        "stylua",

        -- install debuggers
        "debugpy",

        -- install any other package
        "tree-sitter-cli",
        "gopls",
        "gofumpt",
        "golines",
        "gomodifytags",
        "gotests",
        "impl",
        "delve",
        "golangci-lint",

        -- Templ
        "templ",

        -- HTML / CSS / Emmet
        "html-lsp",
        "css-lsp",
        "emmet-ls",
        "hugo-lsp",

        -- JS / TS
        "vtsls",
        "prettier",
        "eslint-lsp",

        -- Tailwind
        "tailwindcss-language-server",

        -- HTMX (no community pack — manual install)
        "htmx-lsp",

        -- JSON
        "jsonls",

        -- JUST
        "just",
      },
    },
  },
}
