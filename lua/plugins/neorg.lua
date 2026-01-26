-- Neorg: Note-taking and organization tool
-- https://github.com/nvim-neorg/neorg
return {
  "nvim-neorg/neorg",
  build = ":Neorg sync-parsers",
  dependencies = { "nvim-lua/plenary.nvim" },
  ft = "norg", -- Lazy load on .norg files
  cmd = "Neorg", -- Lazy load on :Neorg commands
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {}, -- Load default modules
        ["core.concealer"] = { -- Add icons and formatting
          config = {
            icon_preset = "basic",
          },
        },
        ["core.dirman"] = { -- Manage notes directories
          config = {
            workspaces = {
              notes = "~/notes",
              work = "~/work-notes",
            },
            default_workspace = "notes",
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
  end,
}
