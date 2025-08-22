pcall(require, "java") -- Esto asegura que el módulo esté cargado

local home = os.getenv("HOME")
local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
local lombok_jar = home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar"
local config_dir = "/Users/ralbertomerinocolipe/.cache/jdtls/config"
local workspace_dir = "/Users/ralbertomerinocolipe/.cache/jdtls/workspace"
local mason_path = vim.fn.stdpath("data") .. "/mason"
local bundles = {
  mason_path .. "/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar",
  mason_path .. "/share/java-test/*.jar",
}
-- local lombok_jar = home .. "/workspaces/utils/lombok-edge.jar"
-- require('java').setup()
-- Lista de servidores a instalar y configurar
local servers = {
  "solargraph",     -- Ruby
  "elixirls",       -- Elixir
 -- "nextls",
  "pyright",        -- Python
  -- "jdtls",          -- Java
  "terraformls",    -- Terraform
  "yamlls",         -- YAML
}

-- Configuración de capacidades del cliente LSP
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" }
}
capabilities.textDocument.codeAction = {
  dynamicRegistration = false,
  codeActionLiteralSupport = {
    codeActionKind = {
      valueSet = {
        "", "quickfix", "refactor", "refactor.extract", "refactor.inline", "refactor.rewrite", "source", "source.organizeImports"
      }
    }
  }
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

lspconfig.jdtls.setup({
    cmd = {
        "jdtls",
        '-Djava.home=/Users/ralbertomerinocolipe/.asdf/installs/java/zulu-21.42.19/zulu-21.jdk/Contents/Home',
        "-javaagent:" .. lombok_jar,
        "-configuration", config_dir,
        "-data", workspace_dir,
    },
  settings = {
    java = {
      autobuild = { enabled = false },
      referencesCodeLens = { enabled = false },
      implementationsCodeLens = { enabled = false },
      checkstyle = { enabled = false },
      signatureHelp = { enabled = true },
      format = { enabled = false },
      contentProvider = { preferred = "fernflower" },
    },
  },
  -- init_options = {
  --   bundles = bundles,
  -- },
  -- filetypes = { 'java' },
  root_dir = require('lspconfig.util').root_pattern('pom.xml', 'build.gradle', '.git'),
  -- handlers = {
  --   -- By assigning an empty function, you can remove the notifications
  --   -- printed to the cmd
  --   ["$/progress"] = function(_, result, ctx) end,
  -- },
  })


--   capabilities = capabilities,
--   settings = {
--     java = {
--       signatureHelp = { enabled = true },
--       contentProvider = { preferred = 'fernflower' },
--       completion = {
--         favoriteStaticMembers = {
--           "org.hamcrest.MatcherAssert.assertThat",
--           "org.hamcrest.Matchers.*",
--           "org.hamcrest.CoreMatchers.*",
--           "org.junit.jupiter.api.Assertions.*",
--           "java.util.Objects.requireNonNull",
--           "java.util.Objects.requireNonNullElse",
--           "org.mockito.Mockito.*"
--         }
--       },
--       sources = {
--         organizeImports = {
--           starThreshold = 9999,
--           staticStarThreshold = 9999,
--         },
--       },
--       codeGeneration = {
--         toString = {
--           template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
--         }
--       }
--     }
--   }
-- }

-- lspconfig["spring-boot-tools"].setup {
--   filetypes = { "yaml", "jproperties" },
-- }
-- Configuración de Mason para instalar servidores automáticamente
mason_lspconfig.setup({
  ensure_installed = servers
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
  -- spring_boot = {
  --  filetypes = { "yaml", "jproperties" },
  -- },
  -- nextls ={
  --   cmd = {"nextls", "--stdio"},
  --   spitfire = false, -- defaults to false
  --   init_options = {
  --     extensions = {
  --       credo = { enable = true }
  --     },
  --     experimental = {
  --       completions = { enable = true }
  --     }
  --   }
  -- },
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
    cmd = {"/opt/homebrew/bin/elixir-ls"},
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
