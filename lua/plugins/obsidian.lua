-- Obsidian.nvim: Integration with Obsidian vaults
-- Markdown-based note-taking with backlinks, daily notes, and templates
return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  cmd = {
    "ObsidianOpen",
    "ObsidianNew",
    "ObsidianQuickSwitch",
    "ObsidianFollowLink",
    "ObsidianBacklinks",
    "ObsidianToday",
    "ObsidianYesterday",
    "ObsidianTomorrow",
    "ObsidianTemplate",
    "ObsidianSearch",
    "ObsidianLink",
    "ObsidianLinkNew",
    "ObsidianWorkspace",
    "ObsidianPasteImg",
    "ObsidianRename",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "vault",
        path = "~/Vault",
      },
    },

    -- Notes subdirectory
    notes_subdir = "notes",

    -- Daily notes configuration
    daily_notes = {
      folder = "daily",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      -- template = nil, -- Deshabilitado: Templater maneja los templates automáticamente
    },

    -- Templates
    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      -- Substitutions for templates
      substitutions = {},
    },

    -- Completion settings
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },

    -- New note location
    new_notes_location = "notes_subdir",

    -- Note ID generation (optional, uses title by default)
    note_id_func = function(title)
      -- Use title as filename (kebab-case)
      if title ~= nil then
        return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- Random suffix if no title
        return tostring(os.time())
      end
    end,

    -- Note frontmatter customization
    note_frontmatter_func = function(note)
      -- Start with existing frontmatter
      local out = { id = note.id, aliases = note.aliases, tags = note.tags }

      -- Add custom fields
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      return out
    end,

    -- Follow link behavior
    follow_url_func = function(url)
      -- Open URL in browser (only for http/https URLs)
      if url:match("^https?://") then
        vim.fn.jobstart({"open", url})
      else
        vim.notify("URL no es http/https: " .. url, vim.log.levels.WARN)
      end
    end,

    -- UI settings
    ui = {
      enable = false,  -- Disable UI rendering to avoid colored backgrounds
      update_debounce = 200,
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
      },
      bullets = { char = "•", hl_group = "ObsidianBullet" },
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      hl_groups = {
        ObsidianTodo = { bold = true, fg = "#f78c6c" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianBullet = { bold = true, fg = "#89ddff" },
        ObsidianRefText = { underline = true, fg = "#c792ea" },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#75662e" },
      },
    },

    -- Attachments
    attachments = {
      img_folder = "attachments",
    },

    -- Picker (Telescope)
    picker = {
      name = "telescope.nvim",
      mappings = {
        new = "<C-x>",
        insert_link = "<C-l>",
      },
    },

    -- Disable wiki links (use markdown links [[]])
    disable_frontmatter = false,

    -- Preferred link style
    preferred_link_style = "wiki",
  },

  config = function(_, opts)
    require("obsidian").setup(opts)

    -- Keymaps for Obsidian
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        local map = vim.keymap.set
        local bufopts = { buffer = true, silent = true }

        -- Quick actions
        map("n", "<leader>on", "<cmd>ObsidianNew<cr>", vim.tbl_extend("force", bufopts, { desc = "New note" }))
        map("n", "<leader>ot", "<cmd>ObsidianToday<cr>", vim.tbl_extend("force", bufopts, { desc = "Today's daily note" }))
        map("n", "<leader>oy", "<cmd>ObsidianYesterday<cr>", vim.tbl_extend("force", bufopts, { desc = "Yesterday's note" }))
        map("n", "<leader>om", "<cmd>ObsidianTomorrow<cr>", vim.tbl_extend("force", bufopts, { desc = "Tomorrow's note" }))

        -- Search and navigation
        map("n", "<leader>of", "<cmd>ObsidianQuickSwitch<cr>", vim.tbl_extend("force", bufopts, { desc = "Quick switch (find note)" }))
        map("n", "<leader>os", "<cmd>ObsidianSearch<cr>", vim.tbl_extend("force", bufopts, { desc = "Search in vault" }))
        map("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", vim.tbl_extend("force", bufopts, { desc = "Show backlinks" }))
        map("n", "<leader>ol", "<cmd>ObsidianFollowLink<cr>", vim.tbl_extend("force", bufopts, { desc = "Follow link under cursor" }))

        -- Links and references
        map("n", "<leader>ok", "<cmd>ObsidianLink<cr>", vim.tbl_extend("force", bufopts, { desc = "Link to note" }))
        map("v", "<leader>ok", "<cmd>ObsidianLink<cr>", vim.tbl_extend("force", bufopts, { desc = "Link selection to note" }))
        map("n", "<leader>oK", "<cmd>ObsidianLinkNew<cr>", vim.tbl_extend("force", bufopts, { desc = "Create new note and link" }))
        map("v", "<leader>oK", "<cmd>ObsidianLinkNew<cr>", vim.tbl_extend("force", bufopts, { desc = "Create note from selection" }))

        -- Templates
        map("n", "<leader>oT", "<cmd>ObsidianTemplate<cr>", vim.tbl_extend("force", bufopts, { desc = "Insert template" }))

        -- Workspace
        map("n", "<leader>oo", function()
          -- Check if Obsidian app is installed
          local obsidian_app = "/Applications/Obsidian.app"
          if vim.fn.isdirectory(obsidian_app) == 1 then
            vim.cmd("ObsidianOpen")
          else
            vim.notify(
              "Obsidian app no está instalada en /Applications/\n" ..
              "Puedes descargarla de: https://obsidian.md/download\n" ..
              "O simplemente usar Neovim para editar tus notas markdown.",
              vim.log.levels.WARN
            )
          end
        end, vim.tbl_extend("force", bufopts, { desc = "Open in Obsidian app (if installed)" }))
        map("n", "<leader>op", "<cmd>ObsidianPasteImg<cr>", vim.tbl_extend("force", bufopts, { desc = "Paste image from clipboard" }))

        -- TODO toggle
        map("n", "<leader>oc", function()
          return require("obsidian").util.toggle_checkbox()
        end, vim.tbl_extend("force", bufopts, { desc = "Toggle checkbox", expr = true }))

        -- Rename note
        map("n", "<leader>or", "<cmd>ObsidianRename<cr>", vim.tbl_extend("force", bufopts, { desc = "Rename note" }))
      end,
    })
  end,
}
