return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	keys = {
		-- Abrir yazi en el directorio del archivo actual
		{
			"<leader>fy",
			"<cmd>Yazi<cr>",
			desc = "Open yazi (file manager)",
		},
		-- Abrir yazi en el directorio de trabajo actual
		{
			"<leader>fY",
			"<cmd>Yazi cwd<cr>",
			desc = "Open yazi in cwd",
		},
		-- Abrir yazi para buscar un archivo y reemplazar el buffer actual
		{
			"<leader>yr",
			"<cmd>Yazi toggle<cr>",
			desc = "Resume last yazi session",
		},
	},
	opts = {
		-- Abrir yazi en lugar de netrw cuando se abre un directorio
		open_for_directories = false, -- Dejamos esto en false para no afectar Oil

		-- Usar el protocolo de tu terminal para mostrar imágenes
		-- wezterm soporta kitty graphics protocol
		yazi_floating_window_border = "rounded",

		-- Configuración de keymaps dentro de yazi
		keymaps = {
			show_help = "<f1>",
			open_file_in_vertical_split = "<c-v>",
			open_file_in_horizontal_split = "<c-x>",
			open_file_in_tab = "<c-t>",
			grep_in_directory = "<c-s>",
			replace_in_directory = "<c-g>",
			cycle_open_buffers = "<tab>",
			copy_relative_path_to_selected_files = "<c-y>",
		},

		-- Integración con otros plugins
		integrations = {
			-- Sincronizar con grep (telescope)
			grep_in_directory = function(directory)
				require("telescope.builtin").live_grep({
					search_dirs = { directory },
				})
			end,
		},

		-- Hooks para personalizar comportamiento
		hooks = {
			yazi_opened = function()
				-- Ocultar lualine cuando yazi está abierto para más espacio
				vim.opt.laststatus = 0
			end,
			yazi_closed_successfully = function()
				-- Restaurar lualine
				vim.opt.laststatus = 3
			end,
		},
	},
}
