return {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup{
        options = {
          mode = "buffers",            -- opciones: buffers o tabs
          numbers = "none",
          close_command = "bdelete! %d", -- comando para cerrar buffer
          indicator = {
            icon = "▎",
            style = "icon",
          },
          modified_icon = "●",
          buffer_close_icon = "",
          left_trunc_marker = "",
          right_trunc_marker = "",
          max_name_length = 18,
          max_prefix_length = 15,
          tab_size = 18,
          diagnostics = "nvim_lsp",
          offsets = {
            {
              filetype = "Neotree",
              text = "File Explorer",
              padding = 1,
            },
          },
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          separator_style = "thin",
        }
      }
    end,
  }

