pcall(require, "java") -- Esto asegura que el módulo esté cargado

local home = os.getenv("HOME")
local jdk21 = home .. "/.asdf/installs/java/zulu-21.42.19"
local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
local lombok_jar = home .. "/workspaces/utils/lombok-edge.jar"
local config_dir = "/Users/ralbertomerinocolipe/.cache/jdtls/config"
-- local workspace_dir = "/Users/ralbertomerinocolipe/.cache/jdtls/workspace"
local mason_path = vim.fn.stdpath("data") .. "/mason"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name
local bundles = {
	mason_path .. "/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar",
	mason_path .. "/share/java-test/*.jar",
}
-- local lombok_jar = home .. "/workspaces/utils/lombok-edge.jar"
-- require('java').setup()
-- Lista de servidores a instalar y configurar
local servers = {
	"solargraph", -- Ruby
	"elixirls", -- Elixir
	-- "nextls",
	"pyright", -- Python
	-- "jdtls",          -- Java
	"terraformls", -- Terraform
	"yamlls", -- YAML
}

-- Configuración de capacidades del cliente LSP
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
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

-- Función común para configurar keymaps al adjuntar un cliente LSP
local function on_attach(_, bufnr)
	client.server_capabilities.documentFormattingProvider = false
end
lspconfig.jdtls.setup({
	root_dir = function(fname)
		local root = require("lspconfig.util").root_pattern(".git")(fname)
		print("[JDTLS] Detected root_dir: " .. (root or "nil"))
		return root
	end,
})
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
	lua_ls = {
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
					path = vim.split(package.path, ";"),
				},
				diagnostics = {
					globals = { "vim" }, -- Evita falsos positivos en configuraciones de Neovim
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				telemetry = {
					enable = false, -- Desactiva telemetría
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
	elixirls = {
		cmd = { "/opt/homebrew/bin/elixir-ls" },
		settings = {
			elixirLS = {
				dialyzerEnabled = true,
				fetchDeps = false,
				enableTestLenses = true,
				suggestSpecs = true,
			},
		},
	},
}

-- vim.lsp.log.set_level(vim.log.levels.OFF)
vim.lsp.log.set_level(vim.log.levels.DEBUG)
-- Configuración genérica para todos los servidores
for _, server in ipairs(servers) do
	local opts = {
		on_attach = on_attach,
		flags = { debounce_text_changes = 150 },
		capabilities = capabilities,
	}
	-- Aplica configuraciones específicas si existen
	if server_configs[server] then
		opts = vim.tbl_deep_extend("force", opts, server_configs[server])
	end

	lspconfig[server].setup(opts)
end
