return {
	"toppair/peek.nvim",
	event = { "VeryLazy" },
	build = function()
		-- Build peek con deno
		vim.fn.system("cd " .. vim.fn.stdpath("data") .. "/lazy/peek.nvim && deno task --quiet build:fast")
		-- Fix para __VERSION__ bug en el bundle (reemplazo específico)
		vim.fn.system("cd " .. vim.fn.stdpath("data") .. "/lazy/peek.nvim && sed -i '' 's/Ln1 = __VERSION__/Ln1 = \"dev\"/g' public/main.bundle.js")
	end,
	keys = {
		{
			"<leader>mp",
			function()
				local peek = require("peek")
				if peek.is_open() then
					peek.close()
				else
					peek.open()
				end
			end,
			desc = "Peek (Markdown Preview)",
		},
	},
	opts = {
		-- Configuración de peek.nvim
		auto_load = true, -- Auto abrir cuando se entra a un archivo markdown
		close_on_bdelete = true, -- Cerrar preview al cerrar el buffer
		syntax = true, -- Habilitar syntax highlighting en code blocks
		theme = "dark", -- Tema: 'dark' o 'light'
		update_on_change = true, -- Actualizar en tiempo real mientras escribes

		-- Configuración de la ventana del preview
		app = "webview", -- 'webview', 'browser' o ruta a navegador específico
		-- app = 'browser', -- Descomentar para usar navegador por defecto
		-- app = '/Applications/Firefox.app/Contents/MacOS/firefox', -- Ejemplo navegador específico

		filetype = { "markdown" }, -- Tipos de archivo soportados

		-- Puerto del servidor (se asigna automáticamente si está en uso)
		-- port = 8765,

		-- Throttle para actualizaciones (ms) - más bajo = más responsivo pero más CPU
		throttle_at = 200000, -- Caracteres antes de throttling
		throttle_time = "auto", -- 'auto' o número en ms
	},
	config = function(_, opts)
		require("peek").setup(opts)

		-- Comando personalizado para toggle rápido
		vim.api.nvim_create_user_command("PeekToggle", function()
			local peek = require("peek")
			if peek.is_open() then
				peek.close()
			else
				peek.open()
			end
		end, { desc = "Toggle Peek markdown preview" })

		-- Comando para abrir
		vim.api.nvim_create_user_command("PeekOpen", function()
			require("peek").open()
		end, { desc = "Open Peek markdown preview" })

		-- Comando para cerrar
		vim.api.nvim_create_user_command("PeekClose", function()
			require("peek").close()
		end, { desc = "Close Peek markdown preview" })
	end,
}
