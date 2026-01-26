-- Neorg: Note-taking and organization tool
-- https://github.com/nvim-neorg/neorg
return {
  "nvim-neorg/neorg",
  lazy = false, -- Load on startup to ensure proper initialization
  version = "*", -- Use latest stable version
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  build = ":Neorg sync-parsers", -- Install parsers after install/update
  config = function()
    -- Ensure treesitter parser directory exists
    local parser_install_dir = vim.fn.stdpath("data") .. "/treesitter-parsers"
    vim.fn.system("mkdir -p " .. vim.fn.shellescape(parser_install_dir))

    require("neorg").setup({
      load = {
        ["core.defaults"] = {}, -- Load default modules
        -- Temporarily disable concealer until parser is installed
        -- ["core.concealer"] = {
        --   config = {
        --     icon_preset = "basic",
        --   },
        -- },
        ["core.dirman"] = { -- Manage notes directories
          config = {
            workspaces = {
              notes = "~/notes",
              work = "~/work-notes",
            },
            default_workspace = "notes",
            index = "index.norg", -- Default index file name
          },
        },
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.keybinds"] = {
          config = {
            default_keybinds = true,
          },
        },
      },
    })

    -- Create workspace directories if they don't exist
    vim.fn.system("mkdir -p ~/notes ~/work-notes")

    -- Create index files if they don't exist
    local index_notes = vim.fn.expand("~/notes/index.norg")
    local index_work = vim.fn.expand("~/work-notes/index.norg")

    if vim.fn.filereadable(index_notes) == 0 then
      vim.fn.writefile({
        "* Welcome to Notes",
        "",
        "  This is your personal notes workspace.",
        "",
      }, index_notes)
    end

    if vim.fn.filereadable(index_work) == 0 then
      vim.fn.writefile({
        "* Welcome to Work Notes",
        "",
        "  This is your work notes workspace.",
        "",
      }, index_work)
    end
  end,
}
