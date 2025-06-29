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
      },
      window = {
        mappings = {
          ["P"] = {
            "toggle_preview",
            config = {
              use_float = false,
              -- use_image_nvim = true,
              -- title = 'Neo-tree Preview',
            },
          },
        }
      }
    })
  end
}
