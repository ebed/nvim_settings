return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
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
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn",
					node_incremental = "grn",
					scope_incremental = "grc",
					node_decremental = "grm",
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
				},
			},
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
					"#d65d0e" -- Naranja
				},
			}
		})
		-- Activa el resaltado sintáctico basado en Treesitter.
		-- Configuración del plugin nvim-ts-rainbow para obtener colores en los delimitadores.
	end
}
