local obsidian_root = vim.fn.expand "~/Obsidian"

local workspaces = {
  {
    name = "personal",
    path = obsidian_root .. "/Personal",
  },
}

local function workspace_names()
  return vim.tbl_map(function(workspace) return workspace.name end, workspaces)
end

return {
  {
    "obsidian-nvim/obsidian.nvim",
    cmd = { "Obsidian" },
    event = {
      "BufReadPre " .. obsidian_root .. "/**.md",
      "BufNewFile " .. obsidian_root .. "/**.md",
    },

    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function() vim.opt_local.conceallevel = 2 end,
      })
    end,

    keys = {
      { "<leader>oo", "<cmd>Obsidian open<cr>", desc = "Open in Obsidian app" },
      { "<leader>oq", "<cmd>Obsidian quick_switch<cr>", desc = "Quick switch note" },
      { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search notes" },
      { "<leader>od", "<cmd>Obsidian today<cr>", desc = "Today's daily note" },
      { "<leader>oy", "<cmd>Obsidian yesterday<cr>", desc = "Yesterday's daily note" },
      { "<leader>oD", "<cmd>Obsidian tomorrow<cr>", desc = "Tomorrow's daily note" },
      { "<leader>ot", "<cmd>Obsidian template<cr>", desc = "Insert template" },
      { "<leader>op", "<cmd>Obsidian paste_img<cr>", desc = "Paste image" },
      { "<leader>or", "<cmd>Obsidian rename<cr>", desc = "Rename note" },
      { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
      {
        "<leader>ow",
        function()
          vim.ui.select(workspace_names(), { prompt = "Obsidian workspace" }, function(choice)
            if choice then vim.cmd("Obsidian workspace " .. choice) end
          end)
        end,
        desc = "Switch workspace",
      },
      {
        "<leader>on",
        function()
          vim.ui.input({ prompt = "New note title: " }, function(input)
            if input and input ~= "" then vim.cmd("Obsidian new " .. vim.fn.fnameescape(input)) end
          end)
        end,
        desc = "New note",
      },
    },

    opts = function(_, opts)
      opts = opts or {}

      -- REQUIRED
      opts.workspaces = workspaces

      -- remove deprecated keys from older preset config
      opts.follow_url_func = nil
      opts.note_frontmatter_func = nil

      opts.legacy_commands = false

      opts.daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        template = "daily.md",
      }

      opts.templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      }

      opts.attachments = opts.attachments or {}
      opts.attachments.img_folder = nil
      opts.attachments.folder = "assets/imgs"

      opts.frontmatter = {
        func = function(note)
          local out = {
            id = note.id,
            aliases = note.aliases,
            tags = note.tags,
          }

          if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
            for k, v in pairs(note.metadata) do
              out[k] = v
            end
          end

          return out
        end,
      }

      opts.ui = {
        enable = true,
      }

      return opts
    end,
  },
}
