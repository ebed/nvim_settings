local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
require('java').setup()
-- Lista de servidores a instalar y configurar
local servers = {
  "solargraph",     -- Ruby
  "elixirls",       -- Elixir
  "nextls",
  "pyright",        -- Python
  "jdtls",          -- Java
  "terraformls",    -- Terraform
  "yamlls",         -- YAML
}

-- Configuración de capacidades del cliente LSP
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" }
}

-- Función común para configurar keymaps al adjuntar un cliente LSP
local function on_attach(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "lgd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "lgD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "lK", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>lrn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>lca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>lfm", function() vim.lsp.buf.format { async = true } end, opts)
end

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
  nextls ={
    cmd = {"nextls", "--stdio"},
    init_options = {
      extensions = {
        credo = { enable = true }
      },
      experimental = {
        completions = { enable = true }
      }
    }
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
    settings = {
      elixirLS = {
        dialyzerEnabled = true,
        fetchDeps = false,
        suggestSpecs = true,
      },
    },
  },
}

vim.lsp.log.set_level(vim.log.levels.OFF)
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
