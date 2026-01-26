return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- Instalar parsers necesarios para Elixir
    local ensure_parsers = { "elixir", "heex", "eex" }
    local has_treesitter, ts = pcall(require, "nvim-treesitter.configs")

    if has_treesitter then
      -- Verificar si los parsers están instalados
      for _, parser in ipairs(ensure_parsers) do
        local has_parser = pcall(function()
          return vim.treesitter.language.inspect(parser)
        end)

        if not has_parser then
          vim.cmd("TSInstall " .. parser)
          vim.notify("Instalando parser para " .. parser, vim.log.levels.INFO)
        end
      end
    end

    -- Configurar ElixirLS - si está disponible
    local elixirls_cmd = vim.fn.executable("elixir-ls") == 1 and { "elixir-ls" } or
                        (vim.fn.executable("/opt/homebrew/bin/elixir-ls") == 1 and { "/opt/homebrew/bin/elixir-ls" })

    if elixirls_cmd then
      -- Configuración para ElixirLS
      local elixirls_config = {
        cmd = elixirls_cmd,
        settings = {
          elixirLS = {
            dialyzerEnabled = true,
            fetchDeps = false,
            enableTestLenses = true,
            suggestSpecs = true,
            projectionist = true,
          },
        },
        on_attach = function(client, bufnr)
          -- Verificar explícitamente si el renameProvider está disponible
          if client.server_capabilities.renameProvider then
            vim.notify("ElixirLS tiene soporte de rename disponible", vim.log.levels.INFO)
          else
            vim.notify("ElixirLS no tiene soporte de rename disponible", vim.log.levels.WARN)
          end

          -- Configurar keymaps específicos para Elixir
          vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
          vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
          vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
        end,
        capabilities = (function()
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities.textDocument.completion.completionItem.snippetSupport = true
          -- Asegurar explícitamente que la capacidad de rename esté habilitada
          capabilities.textDocument.rename = {
            dynamicRegistration = true,
            prepareSupport = true,
            prepareSupportDefaultBehavior = 1, -- TextEdit support
            honorsChangeAnnotations = true
          }
          return capabilities
        end)(),
      }

      -- Detectar si estamos en Neovim 0.11+ (con nueva API) o versión anterior
      local use_new_api = vim.fn.has("nvim-0.10.0") == 1 or
                        (type(vim.lsp.config) == "function" and type(vim.lsp.enable) == "function")

      -- Aplicar configuración usando la API apropiada
      if use_new_api then
        -- Nueva API en Neovim 0.11+
        vim.lsp.config("elixirls", elixirls_config)
        vim.lsp.enable("elixirls")
      else
        -- API antigua para versiones anteriores
        local lspconfig = require("lspconfig")
        lspconfig.elixirls.setup(elixirls_config)
      end
    end

    -- Comandos para diagnóstico y solución de problemas
    vim.api.nvim_create_user_command("ElixirStatus", function()
      -- Verificar estado de parsers
      local status = {
        "Elixir Status:",
        "------------",
        "TreeSitter parsers:",
      }

      for _, parser in ipairs(ensure_parsers) do
        local has_parser = pcall(function() return vim.treesitter.language.inspect(parser) end)
        table.insert(status, "  - " .. parser .. ": " .. (has_parser and "✓" or "✗"))
      end

      -- Verificar LSP
      table.insert(status, "")
      table.insert(status, "LSP:")
      if elixirls_cmd then
        table.insert(status, "  - ElixirLS encontrado: " .. elixirls_cmd[1])

        -- Verificar si hay buffers con ElixirLS activo
        local has_active_elixir_client = false
        for _, client in pairs(vim.lsp.get_active_clients()) do
          if client.name == "elixirls" then
            has_active_elixir_client = true
            table.insert(status, "  - ElixirLS activo: ✓")

            -- Verificar capacidades
            if client.server_capabilities.renameProvider then
              table.insert(status, "  - Soporte de rename: ✓")
            else
              table.insert(status, "  - Soporte de rename: ✗")
            end

            break
          end
        end

        if not has_active_elixir_client then
          table.insert(status, "  - ElixirLS activo: ✗ (No hay buffers Elixir abiertos)")
        end
      else
        table.insert(status, "  - ElixirLS no encontrado. Instala con 'brew install elixir-ls'")
      end

      vim.notify(table.concat(status, "\n"), vim.log.levels.INFO)
    end, {})

    vim.api.nvim_create_user_command("ElixirInstallParsers", function()
      for _, parser in ipairs(ensure_parsers) do
        vim.cmd("TSInstall " .. parser)
        vim.notify("Instalando parser para " .. parser, vim.log.levels.INFO)
      end
    end, {})
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter-context",
  },
}