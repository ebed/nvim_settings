local dap = require("dap")
local current_path = os.getenv("PATH")
dap.set_log_level('TRACE')
-- Para Ruby on Rails (requiere tener instalado ruby-debug-ide/rdbg)
dap.adapters.ruby = {
	type = 'executable',
	command = 'rdbg', -- Asegúrate de que 'rdbg' esté en tu PATH (gem ruby-debug-ide o ruby 3.1+ debug)
	args = { "--open", "--port", "38698", "--", "ruby" }
}

dap.configurations.ruby = {
	{
		type = "ruby",
		request = "launch",
		name = "Debug current file",
		program = "${file}",
		cwd = vim.fn.getcwd(), -- o especifica el directorio raíz de tu proyecto Rails
	},
}

--
-- vim.notify("Loaded adapters")
-- if not dap.adapters["mix_task"] then
-- 	vim.notify("Not Loaded adapter mix_task")
--
--   local ok, elixir = pcall(require, "elixir")
--   if ok and type(elixir) == "table" and elixir.setup then
--     -- Attempt to register the adapter via elixir-tools
--     elixir.setup({
--       dap = { enable = true },
--     })
--   end
-- end
dap.adapters.elixir = {
	type = 'executable',
	command = "/opt/homebrew/Cellar/elixir-ls/0.30.0/libexec/debug_adapter.sh", -- Replace with the actual path
	args = { '--port', '${port}' }
}
dap.adapters.mix_task = {
	type = 'executable',
	command = "/opt/homebrew/Cellar/elixir-ls/0.30.0/libexec/debug_adapter.sh",
	args = { '--port', '${port}' },
}

dap.configurations.elixir = {
	{
		type = "mix_task",
		name = "mix test (current file)",
		request = "launch",
		task = "test",
		task_args = { "${file}", "--trace" },
		mixEnv = "test",
		startApps = false,
		exitAfterTaskReturns = false,
		projectDir = ".",
	},
	{
		type = "mix_task",
		name = "mix test (all)",
		request = "launch",
		task = "test",
		task_args = {},
		mixEnv = 'test',
		cwd = function()
			return vim.fn.getcwd()
		end,
		startApps = false,
		exitAfterTaskReturns = false,
		projectDir = vim.fn.getcwd(),
	},
	-- ,
	-- 	{
	-- 		type = "mix_task",
	-- 		name = "mix test current file",
	-- 		task = "test",
	-- 		taskArgs = { "${file}", "--trace" },
	-- 		request = "launch",
	-- 		startApps = true,
	-- 		projectDir = "${workspaceFolder}",
	-- 		requireFiles = {
	-- 			"test/**/test_helper.exs",
	-- 			"${file}"
	-- 		}
	-- 	},
	-- 	{
	-- 		type = "elixir",
	-- 		name = "Debug (current file)",
	-- 		request = "launch",
	-- 		program = "${file}",
	-- 		cwd = "${workspaceFolder}",
	-- 		stopOnEntry = false
	-- 	},

}
-- Para Java (requiere tener configurado y ejecutándose un servidor de debug, por ejemplo con vscode-java-debug)
dap.adapters.java = function(callback, config)
	-- FIXME:
	-- Here a function needs to trigger the `vscode.java.startDebugSession` LSP command
	-- The response to the command must be the `port` used below
	callback({
		type = 'server',
		host = '127.0.0.1',
		port = config.port,
	})
end

dap.configurations.java = {
	{
		type = 'java',
		request = 'launch',
		name = "Debug (Launch) - Current File",
		mainClass = function()
			return vim.fn.input('Main class > ')
		end,
		projectName = function()
			return vim.fn.input('Project name > ')
		end,
	},
	{
		type = 'java',
		request = 'attach',
		name = "Debug (Attach) - Remote",
		hostName = "127.0.0.1",
		port = 5005,
	},
}


local dapui = require("dapui")
dapui.setup({
	icons = { expanded = "▾", collapsed = "▸" },
	mappings = {
		-- Mappings propios de dap-ui
		expand = { "<CR>", "<2-LeftMouse>" },
		open = "o",
		remove = "d",
		edit = "e",
		repl = "r",
	},
	layouts = {
		{
			elements = {
				"scopes",
				"breakpoints",
				"stacks",
				"watches",
			},
			size = 40, -- ancho de la ventana
			position = "left",
		},
		{
			elements = {
				"repl",
				"console",
			},
			size = 10, -- alto de la ventana
			position = "bottom",
		},
	},
	controls = {
		enabled = true,
		element = "repl",
	},
})

-- Abrir o cerrar dapui junto con el inicio/fin de una sesión de depuración
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
