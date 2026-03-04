return {
  "andythigpen/nvim-coverage",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "BufReadPost",
  opts = {
    auto_reload = true,
    load_coverage_cb = function(ftype)
      vim.notify("Coverage loaded for " .. ftype, vim.log.levels.INFO)
    end,
    lang = {
      go = {
        -- Run `go test -coverprofile=coverage.out ./...` to generate this
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
    { "<leader>tc", "<cmd>Coverage<cr>",        desc = "Load coverage" },
    { "<leader>tC", "<cmd>CoverageToggle<cr>",  desc = "Toggle coverage" },
    { "<leader>ts", "<cmd>CoverageSummary<cr>", desc = "Coverage summary" },
  },
}
