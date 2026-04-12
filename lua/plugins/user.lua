-- plugins/user.lua

---@type LazySpec
return {

  -- == Removed example plugins (presence.nvim, lsp_signature, better-escape) ==

  -- Dashboard header
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            " █████  ███████ ████████ ██████   ██████ ",
            "██   ██ ██         ██    ██   ██ ██    ██",
            "███████ ███████    ██    ██████  ██    ██",
            "██   ██      ██    ██    ██   ██ ██    ██",
            "██   ██ ███████    ██    ██   ██  ██████ ",
            "",
            "███    ██ ██    ██ ██ ███    ███",
            "████   ██ ██    ██ ██ ████  ████",
            "██ ██  ██ ██    ██ ██ ██ ████ ██",
            "██  ██ ██  ██  ██  ██ ██  ██  ██",
            "██   ████   ████   ██ ██      ██",
          }, "\n"),
        },
      },
    },
  },

  -- LuaSnip: extend filetypes for JS/TS/Templ
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
      luasnip.filetype_extend("typescript", { "typescriptreact" })
      luasnip.filetype_extend("templ", { "html" })
      require "astronvim.plugins.configs.luasnip"(plugin, opts)
    end,
  },

  -- Friendly snippets
  {
    "rafamadriz/friendly-snippets",
    config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts)
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules({
        Rule("$", "$", { "tex", "latex" })
          :with_pair(cond.not_after_regex "%%")
          :with_pair(cond.not_before_regex("xxx", 3))
          :with_move(cond.none())
          :with_del(cond.not_after_regex "xx")
          :with_cr(cond.none()),
      }, Rule("a", "a", "-vim"))
    end,
  },

  -- Go test coverage
  {
    "andythigpen/nvim-coverage",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPost",
    opts = {
      auto_reload = true,
      load_coverage_cb = function(ftype) vim.notify("Coverage loaded for " .. ftype, vim.log.levels.INFO) end,
      lang = {
        go = {
          coverage_file = vim.fn.getcwd() .. "/coverage.out",
        },
      },
      signs = {
        covered = { hl = "CoverageCovered", text = "▎" },
        uncovered = { hl = "CoverageUncovered", text = "▎" },
        partial = { hl = "CoveragePartial", text = "▎" },
      },
    },
    keys = {
      { "<leader>tc", "<cmd>Coverage<cr>", desc = "Load coverage" },
      { "<leader>tC", "<cmd>CoverageToggle<cr>", desc = "Toggle coverage highlights" },
      { "<leader>ts", "<cmd>CoverageSummary<cr>", desc = "Coverage summary" },
      {
        "<leader>tg",
        function()
          vim.notify("Running go test coverage...", vim.log.levels.INFO)
          vim.fn.jobstart("go test -coverprofile=coverage.out ./...", {
            on_exit = function(_, code)
              if code == 0 then
                vim.notify("Coverage generated!", vim.log.levels.INFO)
                vim.cmd "Coverage"
              else
                vim.notify("go test failed (exit " .. code .. ")", vim.log.levels.ERROR)
              end
            end,
          })
        end,
        desc = "Generate Go coverage",
      },
    },
  },

  -- Color preview
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      user_default_options = {
        tailwind = true,
        css = true,
        html = true,
      },
    },
  },

  -- Render Markdown
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "rmd" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      parser = "markdown",
      render_modes = { "n", "i" },
      heading = {
        enabled = true,
        sign = true,
        icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
      },
      code = {
        enabled = true,
        sign = true,
      },
      bullet = {
        enabled = true,
      },
    },
  },

  -- Dadbod
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-completion",
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function() vim.g.db_ui_use_nerd_fonts = 1 end,
  },

  -- Jupytext
  {
    "GCBallesteros/jupytext.nvim",
    opts = {
      style = "percent",
      output_extension = "py",
      force_ft = "python",
    },
    config = true,
  },

  -- Molten
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    dependencies = { "3rd/image.nvim" },
    init = function()
      vim.g.molten_use_border_highlights = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_auto_open_output = false
    end,
  },

  -- Image rendering
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty",
      editor_only_render_when_focused = true,
      tmux_show_only_in_active_window = true,
      integrations = {
        markdown = { enabled = true },
        neorg = { enabled = false },
      },
      max_width = 1000,
      max_height = 250,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },

  -- Quarto
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      lspFeatures = {
        languages = { "python", "r", "julia" },
        chunks = "all",
        diagnostics = { enabled = true, triggers = { "BufWritePost" } },
        completion = { enabled = true },
      },
    },
  },

  -- Otter
  { "jmbuhr/otter.nvim", opts = {} },

  -- Mason LSP install
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "pyright" },
    },
  },

  -- AstroLSP
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      servers = { "pyright" },
    },
  },

  -- Aerial fix for Neovim 0.12
  {
    "stevearc/aerial.nvim",
    opts = function(_, opts) opts.backends = { "lsp", "markdown", "man", "asciidoc" } end,
  },
  {
    "Saghen/blink.cmp",
    opts = {
      appearance = {
        use_nvim_cmp_as_default = false,
      },
      completion = {
        keyword = {
          -- Don't use treesitter for keyword range detection
          range = "prefix",
        },
        documentation = {
          treesitter_highlighting = false,
        },
      },
    },
  },
}
