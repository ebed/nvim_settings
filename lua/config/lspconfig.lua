pcall(require, "java") -- Esto asegura que el módulo esté cargado

local mason_lspconfig = require("mason-lspconfig")

-- Lista de servidores a instalar y configurar
local servers = {
	"solargraph", -- Ruby
	-- "elixirls", -- Elixir
	-- "nextls",
	"emmylua_ls",
	"expert",
	"pyright", -- Python
	"terraformls", -- Terraform
	"yamlls", -- YAML
}

-- Configuración de capacidades del cliente LSP
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}

-- Add explicit workspace folder support
capabilities.workspace = capabilities.workspace or {}
capabilities.workspace.workspaceFolders = {
	supported = true,
	changeNotifications = true
}
capabilities.textDocument.codeAction = {
	dynamicRegistration = false,
	codeActionLiteralSupport = {
		codeActionKind = {
			valueSet = {
				"",
				"quickfix",
				"refactor",
				"refactor.extract",
				"refactor.inline",
				"refactor.rewrite",
				"source",
				"source.organizeImports",
			},
		},
	},
}

--
-- Configuración de Mason para instalar servidores automáticamente
mason_lspconfig.setup({
	ensure_installed = servers,
})

-- Configuración específica para cada servidor
local server_configs = {
	solargraph = {
		settings = {
			solargraph = {
				diagnostics = true,
				formatting = true,
				completion = true,
				useBundler = false,
			},
		},
	},
	emmylua_ls = {
		settings = {
			Lua = {
				library = {
					vim.env.VIMRUNTIME,
					vim.fn.expand("~/.local/share/nvim/lazy/"),
				},
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
	},
	-- jdtls = {},
	lua_ls = {
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
					path = vim.split(package.path, ";"),
				},
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					-- library = vim.api.nvim_get_runtime_file("", true),
					library = {
						vim.env.VIMRUNTIME,
						vim.fn.expand("~/.local/share/nvim/lazy/"),
					},
					checkThirdParty = false,
				},
				telemetry = {
					enable = false,
				},
				format = {
					enable = true,
					defaultConfig = {
						indent_style = "space",
						indent_size = "2",
					},
				},
			},
		},
	},
	pyright = {
		settings = {
			python = {
				analysis = {
					typeCheckingMode = "basic", -- Cambia a "off" para desactivar la verificación de tipos
					autoImportCompletions = true,
					useLibraryCodeForTypes = true,
				},
			},
		},
	},
	expert = {
		env = {
			MIX_ENV = "test"
		},
		-- Asegúrate de que detecte la raíz del proyecto correctamente
		-- root_dir = lspconfig.util.root_pattern("mix.exs", ".git"),
	},
	-- elixirls = {
	-- 	cmd = { "/opt/homebrew/bin/elixir-ls" },
	-- 	settings = {
	-- 		elixirLS = {
	-- 			dialyzerEnabled = true,
	-- 			fetchDeps = false,
	-- 			enableTestLenses = true,
	-- 			suggestSpecs = true,
	-- 			projectionist = true,
	--
	-- 		},
	-- 	},
	-- },
}

-- Función común para configurar keymaps al adjuntar un cliente LSP
local function on_attach(client, bufnr)
	-- Verify buffer exists and is loaded
	if not vim.api.nvim_buf_is_valid(bufnr) then
		vim.notify("LSP tried to attach to invalid buffer: " .. bufnr, vim.log.levels.WARN)
		return
	end

	client.server_capabilities.documentFormattingProvider = true
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end
-- Configure LSP logging level
-- Use one of the following:
-- vim.lsp.log.set_level(vim.log.levels.OFF)   -- Turn off logging
-- vim.lsp.log.set_level(vim.log.levels.ERROR) -- Only errors
-- vim.lsp.log.set_level(vim.log.levels.WARN)  -- Warnings and errors
-- vim.lsp.log.set_level(vim.log.levels.INFO)  -- Info, warnings, and errors
-- vim.lsp.log.set_level(vim.log.levels.DEBUG) -- Debug and all above

-- Use ERROR level for everyday use
vim.lsp.log.set_level(vim.log.levels.ERROR)
-- Configuración genérica para todos los servidores
for server, config in pairs(server_configs) do
	vim.lsp.config(server, vim.tbl_deep_extend('force', {
		capabilities = capabilities,
		on_attach = on_attach,
	}, config))
	vim.lsp.enable(server)
end
