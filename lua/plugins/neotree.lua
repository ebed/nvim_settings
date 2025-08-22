return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  config = function()
  require("neo-tree").setup({
     source_selector = {
            winbar = true,
            statusline = true
        },
      filesystem = {
        filtered_items = {
          visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
          hide_dotfiles = false,
          hide_gitignored = true,
        },
        follow_current_file = {
          enabled = true, -- Reveal the current file in the tree
        },
      },
    components = {
      name = function(config, node, state)
        return {
          text = node.name,
          highlight = config.highlight or "NeoTreeFileName",
        }
      end,
      -- No agregues components de fecha, tamaño, etc.
    },
    renderers = {
      file = {
        { "icon" },
        { "name" },
      },
      directory = {
        { "icon" },
        { "name" },
      },
      },
      window = {
        mappings = {
          ["P"] = {
            "toggle_preview",
            config = {
              use_float = false,
              use_image_nvim = true,
              title = 'Neo-tree Preview',
            },
          },
        }
      }
    })

    -- vim.api.nvim_set_hl(0, "NeoTreeFileNameOpened", { fg = "#FFD700", bold = true })
    -- vim.api.nvim_create_autocmd("VimEnter", {
    --   callback = function()
    --     require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
    --     -- vim.cmd("Alpha")
    --   end,
    -- })
  end
}
