return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("noice").setup({
        -- Configuración de cómo se muestran los mensajes de LSP
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        -- Presets para adaptar la interfaz a tus necesidades
        presets = {
          bottom_search = true,        -- Usa la ubicación clásica en la parte inferior para la búsqueda
          command_palette = true,      -- Rediseña el cmdline para comandos
          long_message_to_split = true,-- Las notificaciones largas se muestran en un panel separado
          inc_rename = false,          -- Deshabilitar en caso de que no se use inc-rename
        },
        -- Configuraciones adicionales según tus preferencias
        routes = {
          { view = "notify", filter = { event = "msg_showmode" } },
        },
      })
    end,
  }
