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
-- Helper para ruby-lsp
-- Si hay Gemfile.lock, usa bundle exec (ruby-lsp en Gemfile)
-- Sino, usa versión global
local function ruby_cmd()
  local uv = vim.uv or vim.loop
  if uv.fs_stat("Gemfile.lock") ~= nil and vim.fn.executable("bundle") == 1 then
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
    filetypes = { "ruby", "eruby" },
    root_dir = function(bufnr)
      local root = vim.fs.root(bufnr, { ".git", "Gemfile", ".ruby-version" })
      if not root then
        root = vim.fn.getcwd()
      end
      return root
    end,
    init_options = {
      formatter = "rubocop",
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
  if name ~= "ruby_lsp" then
    -- Otros LSPs usan el método normal
    vim.lsp.config(
      name,
      vim.tbl_deep_extend("force", {
        capabilities = capabilities,
        on_attach = on_attach,
      }, cfg)
    )
    vim.lsp.enable(name)
  end
end

-- Ruby LSP: inicio automático con FileType
-- Track de buffers procesados para evitar duplicados
local ruby_lsp_initialized = {}

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "ruby", "eruby" },
  callback = function(ev)
    local bufnr = ev.buf

    -- Evitar duplicados - verificar si ya procesamos este buffer
    if ruby_lsp_initialized[bufnr] then
      return
    end
    ruby_lsp_initialized[bufnr] = true

    -- Verificar si ya hay un cliente ruby_lsp en este buffer
    local clients = vim.lsp.get_clients({ name = "ruby_lsp", bufnr = bufnr })
    if #clients > 0 then
      return
    end

    -- Detectar root del proyecto
    local root = vim.fs.root(bufnr, { ".git", "Gemfile", ".ruby-version" }) or vim.fn.getcwd()
    local cmd = ruby_cmd()

    -- Iniciar ruby_lsp
    vim.lsp.start({
      name = "ruby_lsp",
      cmd = cmd,
      filetypes = { "ruby", "eruby" },
      root_dir = root,
      capabilities = capabilities,
      on_attach = on_attach,
      init_options = {
        formatter = "rubocop",
      },
    })

    -- Limpiar tracking cuando se cierra el buffer
    vim.api.nvim_create_autocmd("BufDelete", {
      buffer = bufnr,
      once = true,
      callback = function()
        ruby_lsp_initialized[bufnr] = nil
      end,
    })
  end,
})
