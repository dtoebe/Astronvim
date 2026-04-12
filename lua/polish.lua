-- lua/polish.lua
return function()
  -- 1. Filetype associations
  vim.filetype.add {
    extension = {
      templ = "templ",
    },
  }

  -- 2. Options
  vim.opt.relativenumber = true
  vim.opt.number = true

  -- 3. Colorscheme
  vim.cmd.colorscheme "dracula"

  -- 4. Inlay hint highlight
  vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#949494", italic = true })

  -- Wordwrap
  vim.opt.wrap = true
  vim.opt.linebreak = true
  vim.opt.breakindent = true
  vim.opt.showbreak = "↪ "

  vim.keymap.set(
    "n",
    "<leader>um",
    function() require("render-markdown").toggle() end,
    { desc = "Toggle Markdown rendering" }
  )

  -- 5. HTML/Templ comment style
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "html", "templ" },
    callback = function() vim.bo.commentstring = "<​!-- %s -->" end,
  })

  -- 6. Go formatting (tabs, not spaces)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
      vim.opt_local.expandtab = false
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
    end,
  })

  -- Hugo filetype detection
  vim.filetype.add {
    extension = {
      hugo = "hugo",
    },
    pattern = {
      [".*/layouts/.*%.html"] = "gotmpl",
      [".*/archetypes/.*%.html"] = "gotmpl",
    },
  }

  -- 7. Generate Go coverage file + auto-load highlights
  vim.keymap.set("n", "<leader>tg", function()
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
  end, { desc = "Generate Go coverage" })

  -- Open Go test file in a vertical split
  vim.keymap.set("n", "<leader>to", function()
    local file = vim.fn.expand "%:p"
    local test_file

    if file:match "_test%.go$" then
      test_file = file:gsub("_test%.go$", ".go")
    else
      test_file = file:gsub("%.go$", "_test.go")
    end

    if vim.fn.filereadable(test_file) == 1 then
      vim.cmd("vsplit " .. test_file)
    else
      vim.ui.select({ "Yes", "No" }, { prompt = "Test file not found. Create it?" }, function(choice)
        if choice == "Yes" then
          vim.cmd("vsplit " .. test_file)
          vim.cmd "write"
        end
      end)
    end
  end, { desc = "Toggle Go test/impl file in vsplit" })

  -- 8. Jupyter / Molten setup
  -- Activate Otter LSP (Pyright) inside .ipynb notebook cells
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    pattern = "*.ipynb",
    callback = function()
      local ok, otter = pcall(require, "otter")
      if ok then otter.activate({ "python" }, true, true, nil) end
    end,
  })

  -- MoltenEvaluateOperator must use expr = true
  vim.keymap.set("n", "<leader>me", "v:lua.require'molten.utils'.operatorfunc(v:false)", {
    desc = "Molten evaluate operator",
    silent = true,
    expr = true,
    callback = function() vim.o.operatorfunc = "v:lua.require'molten.utils'.operatorfunc" end,
  })

  -- Python/notebook keymaps (scoped to python buffers)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
      local opts = { buffer = true, silent = true }

      -- Evaluate current cell (inner paragraph = between # %% markers)
      vim.keymap.set("n", "<leader>mr", function()
        vim.cmd "MoltenEvaluateOperator"
        vim.api.nvim_feedkeys("ip", "n", false)
      end, vim.tbl_extend("force", opts, { desc = "Molten run cell" }))

      -- Navigate cells
      vim.keymap.set(
        "n",
        "]j",
        [[/^\s*#\s*%%<CR>:nohlsearch<CR>]],
        vim.tbl_extend("force", opts, { desc = "Next cell" })
      )
      vim.keymap.set(
        "n",
        "[j",
        [[?^\s*#\s*%%<CR>:nohlsearch<CR>]],
        vim.tbl_extend("force", opts, { desc = "Prev cell" })
      )

      -- Insert new cell below cursor
      vim.keymap.set("n", "<leader>mc", "o# %%<CR>", vim.tbl_extend("force", opts, { desc = "New cell below" }))
    end,
  })
end
