-- =============================================================================
-- MARKDOWN LINKS NAVIGATION
-- =============================================================================
-- Navegación inteligente de enlaces en archivos markdown
-- Soporta: URLs, archivos locales, enlaces wiki [[]], enlaces markdown [](url)

return {
	-- Plugin para mejorar gx (abrir enlaces)
	{
		"chrishrb/gx.nvim",
		keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
		cmd = { "Browse" },
		init = function()
			vim.g.netrw_nogx = 1 -- Deshabilitar gx por defecto de netrw
		end,
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("gx").setup({
				open_browser_app = "open", -- macOS: 'open', Linux: 'xdg-open'
				open_browser_args = {}, -- Argumentos adicionales si es necesario
				handlers = {
					plugin = true, -- Abrir URLs de plugins
					github = true, -- Detectar URLs de GitHub
					brewfile = true, -- Detectar Brewfile
					package_json = true, -- Detectar package.json URLs
					search = true, -- Buscar en Google si no es URL válida
				},
				handler_options = {
					search_engine = "google", -- Buscador por defecto
				},
			})
		end,
	},

	-- Configuración personalizada para markdown
	{
		"epwalsh/obsidian.nvim",
		-- Ya está configurado en obsidian.lua, solo agregamos mappings adicionales
		enabled = true,
	},
}
