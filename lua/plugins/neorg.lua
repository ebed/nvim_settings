-- Neorg: Organization and note-taking with advanced markup
-- Workspaces: Development notes, daily journal, projects, personal
return {
  "nvim-neorg/neorg",
  lazy = false,
  version = "*",
  dependencies = {
    "nvim-neorg/lua-utils.nvim",
    "pysan3/pathlib.nvim",
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("neorg").setup({
      load = {
        -- Core modules
        ["core.defaults"] = {},
        ["core.concealer"] = {
          config = {
            -- Icon presets: "basic", "diamond", "varied"
            icon_preset = "varied",
            folds = true,
            icons = {
              todo = {
                done = { icon = "✓" },
                pending = { icon = "○" },
                undone = { icon = "✗" },
                uncertain = { icon = "?" },
                on_hold = { icon = "⏸" },
                cancelled = { icon = "⊘" },
                recurring = { icon = "⟲" },
                urgent = { icon = "⚠" },
              },
              heading = {
                icons = { "◉", "◎", "○", "✺", "▶", "⤷" },
              },
              list = {
                icons = { "•", "◦", "▸", "▹" },
              },
            },
          },
        },

        -- Completion
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },

        -- Directories and workspaces
        ["core.dirman"] = {
          config = {
            workspaces = {
              desarrollo = "~/neorg/desarrollo",   -- Development notes, code snippets
              journal = "~/neorg/journal",         -- Daily journal/bitácora
              proyectos = "~/neorg/proyectos",     -- Project documentation
              personal = "~/neorg/personal",       -- Personal notes
            },
            default_workspace = "desarrollo",
            index = "index.norg",  -- Main index file per workspace
          },
        },

        -- Journal/Diary for daily log
        ["core.journal"] = {
          config = {
            workspace = "journal",
            journal_folder = "",  -- Root of workspace
            strategy = "flat",    -- All entries in same folder
            template_name = "template.norg",
            use_template = true,
          },
        },

        -- Export to markdown
        ["core.export"] = {},

        -- Export to markdown specifically
        ["core.export.markdown"] = {
          config = {
            extensions = "all",
          },
        },

        -- Integrate with telescope
        ["core.integrations.telescope"] = {},

        -- Summary/index generation
        ["core.summary"] = {},

        -- TODO/GTD integration
        ["core.qol.todo_items"] = {
          config = {
            -- Create contexts for todos
            create_todo_items = true,
            create_todo_parents = true,
          },
        },

        -- Presenter mode
        ["core.presenter"] = {
          config = {
            zen_mode = "zen-mode",
          },
        },

        -- Text objects for easy navigation
        ["core.itero"] = {},

        -- Keybinds
        ["core.keybinds"] = {
          config = {
            default_keybinds = true,
            neorg_leader = "<Leader>n",
          },
        },
      },
    })

    -- Custom keymaps
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "norg",
      callback = function()
        local map = vim.keymap.set
        local opts = { buffer = true, silent = true }

        -- Workspace navigation
        map("n", "<leader>nw", "<cmd>Neorg workspace<cr>", vim.tbl_extend("force", opts, { desc = "Select workspace" }))
        map("n", "<leader>nd", "<cmd>Neorg workspace desarrollo<cr>", vim.tbl_extend("force", opts, { desc = "Open desarrollo workspace" }))
        map("n", "<leader>nj", "<cmd>Neorg workspace journal<cr>", vim.tbl_extend("force", opts, { desc = "Open journal workspace" }))
        map("n", "<leader>np", "<cmd>Neorg workspace proyectos<cr>", vim.tbl_extend("force", opts, { desc = "Open proyectos workspace" }))

        -- Journal/Bitácora
        map("n", "<leader>njt", "<cmd>Neorg journal today<cr>", vim.tbl_extend("force", opts, { desc = "Today's journal entry" }))
        map("n", "<leader>njy", "<cmd>Neorg journal yesterday<cr>", vim.tbl_extend("force", opts, { desc = "Yesterday's journal" }))
        map("n", "<leader>njm", "<cmd>Neorg journal tomorrow<cr>", vim.tbl_extend("force", opts, { desc = "Tomorrow's journal" }))
        map("n", "<leader>njc", "<cmd>Neorg journal custom<cr>", vim.tbl_extend("force", opts, { desc = "Custom date journal" }))

        -- Index and return
        map("n", "<leader>ni", "<cmd>Neorg index<cr>", vim.tbl_extend("force", opts, { desc = "Open workspace index" }))
        map("n", "<leader>nr", "<cmd>Neorg return<cr>", vim.tbl_extend("force", opts, { desc = "Return to previous file" }))

        -- TODO management
        map("n", "<leader>ntd", "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_done<cr>", vim.tbl_extend("force", opts, { desc = "Mark TODO done" }))
        map("n", "<leader>ntu", "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_undone<cr>", vim.tbl_extend("force", opts, { desc = "Mark TODO undone" }))
        map("n", "<leader>ntp", "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_pending<cr>", vim.tbl_extend("force", opts, { desc = "Mark TODO pending" }))
        map("n", "<leader>ntc", "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_cancelled<cr>", vim.tbl_extend("force", opts, { desc = "Cancel TODO" }))

        -- Telescope integration
        map("n", "<leader>nf", "<cmd>Telescope neorg find_norg_files<cr>", vim.tbl_extend("force", opts, { desc = "Find norg files" }))
        map("n", "<leader>ns", "<cmd>Telescope neorg search_headings<cr>", vim.tbl_extend("force", opts, { desc = "Search headings" }))
        map("n", "<leader>nl", "<cmd>Telescope neorg find_linkable<cr>", vim.tbl_extend("force", opts, { desc = "Find linkable" }))

        -- Export
        map("n", "<leader>ne", "<cmd>Neorg export to-file<cr>", vim.tbl_extend("force", opts, { desc = "Export to file" }))

        -- Create link from visual selection
        map("v", "<leader>nk", ":<C-u>Neorg keybind norg core.esupports.hop.hop-link<cr>", vim.tbl_extend("force", opts, { desc = "Create link" }))

        -- Insert date/time
        map("i", "<C-d>", "<cmd>put =strftime('%Y-%m-%d')<cr>A", vim.tbl_extend("force", opts, { desc = "Insert date" }))
        map("i", "<C-t>", "<cmd>put =strftime('%H:%M')<cr>A", vim.tbl_extend("force", opts, { desc = "Insert time" }))
      end,
    })
  end,
}
