-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.colorscheme.dracula-nvim" },

  { import = "astrocommunity.pack.lua" },

  -- HTML, CSS, Emmet
  { import = "astrocommunity.pack.prettier" },
  { import = "astrocommunity.pack.html-css" },

  -- JavaScript / TypeScript (vtsls, neotest-jest)
  { import = "astrocommunity.pack.typescript" },

  -- Tailwind CSS (useful with Templ + HTMX/Datastar stacks)
  { import = "astrocommunity.pack.tailwindcss" },

  -- Config (config files, package.json, etc.)
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.xml" },

  -- Docker
  { import = "astrocommunity.docker.lazydocker" },
  { import = "astrocommunity.pack.docker" },

  -- Go
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.golangci-lint" },
  { import = "astrocommunity.pack.templ" },

  -- Just
  { import = "astrocommunity.pack.just" },

  -- Kubernetes
  { import = "astrocommunity.pack.helm" },

  -- SQL
  { import = "astrocommunity.pack.sql" },
}
