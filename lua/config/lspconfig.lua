local home = vim.env.HOME
local extra_paths = {
  home .. "/.asdf/shims",
  home .. "/.asdf/bin",
  home .. "/.rbenv/shims",
  home .. "/.rbenv/bin",
}
for _, p in ipairs(extra_paths) do
  if vim.fn.isdirectory(p) == 1 and not string.find(vim.env.PATH or "", p, 1, true) then
    vim.env.PATH = p .. ":" .. vim.env.PATH
  end
end
-- Asegura jdtls aparte si usas Java
pcall(require, "java")

local mason_lspconfig = require("mason-lspconfig")

-- Mason install
mason_lspconfig.setup({
  ensure_installed = { "ruby_lsp", "elixirls", "lua_ls", "pyright", "terraformls", "yamlls", "bashls", "dockerls" },
  automatic_installation = false,
})

-- Capacidades
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Diagnósticos
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
-- Helper para detectar si usar Bundler
local function ruby_cmd()
  local uv = vim.uv or vim.loop
  local in_bundle = uv.fs_stat("Gemfile.lock") ~= nil
  if in_bundle and vim.fn.executable("bundle") == 1 then
    return { "bundle", "exec", "ruby-lsp" }
  end
  return { "ruby-lsp" }
end
-- Logging moderado
vim.lsp.log.set_level(vim.log.levels.ERROR)

-- Formateo permitido por LSP (si usas conform.nvim, déjalo mínimo)
local allow_formatting = {
  lua_ls = true,
  terraformls = true,
}

-- on_attach común
local function on_attach(client, bufnr)
  if not allow_formatting[client.name] then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
  end
  if vim.lsp.inlay_hint then
    pcall(vim.lsp.inlay_hint.enable, bufnr, true)
  end
  -- Keymaps básicos
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end
  map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
  map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
  map("n", "gr", vim.lsp.buf.references, "References")
  map("n", "gi", vim.lsp.buf.implementation, "Implementation")
  map("n", "K", vim.lsp.buf.hover, "Hover")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
  map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
  map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
end

-- Configs por servidor (API nativa 0.11)
local server_configs = {
  ruby_lsp = {
    cmd = ruby_cmd(),
    filetypes = { "ruby" },
    root_dir = function(bufnr)
      return vim.fs.root(bufnr, { ".git", "Gemfile", ".ruby-version" }) or vim.fn.getcwd()
    end,
    init_options = {
      formatter = "auto", -- usa rubocop si está el plugin; si no, syntax_tree
    },
    settings = {},
  },
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            vim.fn.expand("~/.local/share/nvim/lazy/"),
          },
        },
        telemetry = { enable = false },
      },
    },
  },

  pyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic",
          autoImportCompletions = true,
          useLibraryCodeForTypes = true,
        },
      },
    },
  },

  terraformls = {},
  yamlls = {
    settings = {
      yaml = {
        keyOrdering = false,
        format = { enable = true },
        validate = true,
        schemaStore = { enable = true },
        schemas = {
          kubernetes = { "/*.k8s.yaml", "/*-k8s.yaml", "k8s/*.yaml", "manifests/**/*.yaml" },
          ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.yml",
          ["https://json.schemastore.org/github-action.json"] = ".github/actions/**/action.{yml,yaml}",
          ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.{yml,yaml}",
        },
      },
    },
  },
  bashls = {},
  elixirls = {},
  dockerls = {},
}

-- Registro y enable (SIN lspconfig para evitar duplicados)
for name, cfg in pairs(server_configs) do
  vim.lsp.config(
    name,
    vim.tbl_deep_extend("force", {
      capabilities = capabilities,
      on_attach = on_attach,
    }, cfg)
  )
  vim.lsp.enable(name)
end
