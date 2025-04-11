return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
          ensure_installed = { "bash",
              "c",
              "javascript",
                "regex",
                "diff",
              "json",
              "lua",
              "python",
              "typescript",
              "tsx",
              "css",
              "rust",
              "ruby",
              "java",
              "yaml"
          },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },
          auto_install = true,
          modules = {},
          ignore_install = {},
          rainbow = {
            enable = true,
            extended_mode = true, -- También se resaltan otros delimitadores además de paréntesis.
            max_file_lines = nil, -- Se desactiva la limitación para archivos muy grandes.
            -- Opcional: define una lista de colores personalizados para los delimitadores.
            colors = {
              "#cc241d", -- Rojo
              "#d79921", -- Amarillo
              "#458588", -- Azul
              "#b16286", -- Violeta
              "#689d6a", -- Verde
              "#7c6f64", -- Gris
              "#d65d0e"  -- Naranja
            },
        }
     })
     -- Activa el resaltado sintáctico basado en Treesitter.
     -- Configuración del plugin nvim-ts-rainbow para obtener colores en los delimitadores.
    end
 }
