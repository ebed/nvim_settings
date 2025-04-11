local dap = require("dap")

-- Para Ruby on Rails (requiere tener instalado ruby-debug-ide/rdbg)
dap.adapters.ruby = {
  type = 'executable',
  command = 'rdbg',  -- Asegúrate de que 'rdbg' esté en tu PATH (gem ruby-debug-ide o ruby 3.1+ debug)
  args = {"--open", "--port", "38698", "--", "ruby"}
}

dap.configurations.ruby = {
  {
    type = "ruby",
    request = "launch",
    name = "Debug current file",
    program = "${file}",
    cwd = vim.fn.getcwd(),  -- o especifica el directorio raíz de tu proyecto Rails
  },
}

-- Para Elixir (Nota: el soporte de dap para Elixir puede ser experimental.
-- Puede requerirse un adapter específico o integrarse con el servidor ElixirLS)
dap.adapters.elixir = {
  type = "executable",
  command = "path/to/elixir-debug-adapter",  -- Debes indicar la ruta correcta al adaptador de Elixir si lo tienes
  args = {},
}

dap.configurations.elixir = {
  {
    type = "elixir",
    request = "launch",
    name = "Debug current file",
    program = "${file}",
    cwd = vim.fn.getcwd(),
  },
}

-- Para Java (requiere tener configurado y ejecutándose un servidor de debug, por ejemplo con vscode-java-debug)
dap.adapters.java = {
  type = 'server',
  host = '127.0.0.1',
  port = 5005,  -- Asegúrate de que el proceso Java se inicie en modo debug en este puerto
}

dap.configurations.java = {
  {
    type = 'java',
    request = 'attach',
    name = "Attach to Java process",
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
