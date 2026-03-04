---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      -- Go
      "go",
      "gomod",
      "gosum",
      "gowork",

      -- Templ
      "templ",
      "gotmpl",

      -- Web
      "html",
      "css",
      "javascript",
      "typescript",
      "tsx",
      "json",
      "jsonc",

      -- General
      "lua",
      "vim",
      "vimdoc",
      "markdown",
      "markdown_inline",
      "bash",
      "yaml",
      "toml",
      "just",
    },
  },
}
