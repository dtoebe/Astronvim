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
      luasnip.filetype_extend("templ", { "html" }) -- get html snippets in templ files
      require "astronvim.plugins.configs.luasnip"(plugin, opts)
    end,
  },

  -- Friendly snippets: includes Go, HTML, JS/TS, CSS out of the box
  {
    "rafamadriz/friendly-snippets",
    config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
  },

  -- Autopairs: Treesitter-aware, keep your custom rules
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

  -- Go test coverage gutter highlights
  {
    "andythigpen/nvim-coverage",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPost",
    opts = {
      auto_reload = true,
      load_coverage_cb = function(ftype) vim.notify("Coverage loaded for " .. ftype, vim.log.levels.INFO) end,
      lang = {
        go = {
          -- generate with: go test -coverprofile=coverage.out ./...
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

  -- Color preview for CSS / Tailwind classes
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

  -- Render Markdown as rich text in the buffer
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "rmd" }, -- lazy-load on markdown files
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      -- "echasnovski/mini.icons",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- use treesitter to parse markdown
      parser = "markdown",
      -- you can tweak these as you like, this is a safe minimal setup
      render_modes = { "n", "i" }, -- render in normal + insert modes
      heading = {
        enabled = true,
        -- example: style headings with different prefixes
        sign = true,
        icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
      },
      code = {
        enabled = true,
        -- highlight fenced code blocks with treesitter
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
}
