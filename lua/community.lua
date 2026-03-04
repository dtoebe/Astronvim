-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.colorscheme.dracula-nvim" },

  { import = "astrocommunity.pack.lua" },
  -- import/override with your plugins folder
  { import = "astrocommunity.pack.golangci-lint" },

  -- Templ (Go HTML templating engine)
  { import = "astrocommunity.pack.templ" },

  -- HTML, CSS, Emmet
  { import = "astrocommunity.pack.html-css" },

  -- JavaScript / TypeScript (vtsls, neotest-jest)
  { import = "astrocommunity.pack.typescript" },

  -- Tailwind CSS (useful with Templ + HTMX/Datastar stacks)
  { import = "astrocommunity.pack.tailwindcss" },

  -- JSON (config files, package.json, etc.)
  { import = "astrocommunity.pack.json" },

  -- Docker
  { import = "astrocommunity.docker.lazydocker" },
  { import = "astrocommunity.pack.docker" },

  -- Go
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.golangci-lint" },

  -- Just
  { import = "astrocommunity.pack.just" },

  -- Kubernetes
  { import = "astrocommunity.pack.helm" },
}
