# Arquitectura de Configuración Neovim

## 📋 Índice
- [Overview](#overview)
- [Estructura de Directorios](#estructura-de-directorios)
- [Flujo de Carga](#flujo-de-carga)
- [Gestión de LSPs](#gestión-de-lsps)
- [Sistema de Plugins](#sistema-de-plugins)
- [Keymaps Organization](#keymaps-organization)
- [Decisiones Arquitectónicas](#decisiones-arquitectónicas)
- [Cómo Agregar Features](#cómo-agregar-features)

---

## Overview

Esta configuración de Neovim está diseñada para desarrollo multi-lenguaje profesional con enfoque en:
- **LSP nativo** usando API de Neovim 0.11+
- **Debugging integrado** (DAP) para múltiples lenguajes
- **Modularidad** y mantenibilidad
- **Performance** mediante lazy loading
- **Git workflow** completo

### Lenguajes Soportados
- Ruby (ruby_lsp + debugging)
- Elixir (elixirls + debugging)
- Java (JDTLS + debugging)
- Lua (lua_ls)
- Python (pyright)
- Terraform, YAML, Bash, Docker

---

## Estructura de Directorios

```
~/.config/nvim/
├── init.lua                    # Entry point principal
├── lazy-lock.json             # Plugin version lockfile
│
├── lua/
│   ├── config/
│   │   ├── base_settings.lua  # Opciones básicas de Vim
│   │   ├── basics.lua         # Cursor, highlights
│   │   ├── lazy.lua           # Plugin manager setup
│   │   ├── lspconfig.lua      # LSP servers configuration
│   │   ├── cmp.lua            # Autocompletion
│   │   ├── dap.lua            # Debugging adapters
│   │   ├── telescope.lua      # Fuzzy finder
│   │   ├── gitsigns.lua       # Git integration
│   │   └── mappings/          # Keymaps (modular)
│   │       ├── init.lua       # Carga todos los módulos
│   │       ├── general.lua    # Save, quit, navigation
│   │       ├── telescope.lua  # File/content search
│   │       ├── git.lua        # Git operations
│   │       ├── lsp.lua        # LSP actions
│   │       ├── dap.lua        # Debugging
│   │       ├── plugins.lua    # Plugin-specific
│   │       ├── java.lua       # JDTLS specific
│   │       └── testing.lua    # Neotest, HTTP
│   │
│   ├── plugins/               # Plugin definitions (lazy.nvim)
│   │   ├── core-plugins.lua   # LSP, Mason, Treesitter, CMP
│   │   ├── jdtls.lua         # Java LSP (unified)
│   │   ├── elixir.lua        # Elixir LSP
│   │   ├── neorg.lua         # Note-taking
│   │   ├── telescope.lua     # Fuzzy finder config
│   │   ├── copilot.lua       # AI assistance
│   │   ├── copilotchat.lua   # AI chat integration
│   │   └── ...               # ~87 plugins total
│   │
│   ├── autocmds/             # Autocommands
│   │   └── init.lua          # FileType events, etc.
│   │
│   └── utils/                # Utility functions
│       ├── cache_maintenance.lua  # Prevent ENOSPC errors
│       └── db_sql_maps.lua        # Database helpers
│
├── after/
│   └── ftplugin/            # Filetype-specific configs
│       ├── sql.lua
│       ├── ruby.lua
│       └── ...
│
├── archive/                  # Old/unused configurations
│   ├── jdtls-old/           # Previous JDTLS versions
│   └── ...                  # Commented/deprecated plugins
│
├── ARCHITECTURE.md          # Este archivo
├── JDTLS_COMMANDS.md       # Comandos Java disponibles
├── MANTENIMIENTO_CACHE.md  # Guía de mantenimiento
└── README.md               # Overview general
```

---

## Flujo de Carga

### 1. init.lua (Entry Point)
```lua
require("config.base_settings")  -- Opciones básicas Vim
vim.cmd("colorscheme desert")    -- Tema visual
require("config.lazy")           -- Inicializa lazy.nvim
require("config.basics")         -- Cursor, highlights
require("config.cmp")            -- Autocompletado
require("config.dap")            -- Debugging
require("config.gitsigns")       -- Git signs
require("config.telescope")      -- Fuzzy finder
require("config.mappings")       -- Keymaps (modular)
require("config.lspconfig")      -- LSP servers
require("utils.cache_maintenance").setup()  -- Prevención ENOSPC
```

### 2. Lazy.nvim Plugin Loading
- **Lazy load** por evento (`BufReadPre`, `BufNewFile`)
- **Lazy load** por comando (`:Neotree`, `:LazyGit`)
- **Lazy load** por filetype (`ft = "java"`, `ft = "ruby"`)
- **Priority loading** para plugins críticos (colorscheme, treesitter)

### 3. LSP Initialization
- **Mason** instala LSP servers
- **lspconfig.lua** configura y activa servers
- **on_attach** agrega keymaps específicos por buffer
- **Capabilities** extendidas con nvim-cmp

---

## Gestión de LSPs

### API Nativa de Neovim (0.11+)

**Decisión:** Usamos `vim.lsp.config()` + `vim.lsp.enable()` en lugar de `lspconfig.setup()`

**Ventajas:**
- API oficial de Neovim
- Menos dependencias externas
- Configuración más explícita
- Mejor control sobre capabilities

**Ejemplo:**
```lua
vim.lsp.config("ruby_lsp", {
  cmd = ruby_cmd(),
  capabilities = capabilities,
  on_attach = on_attach,
  settings = { ... }
})
vim.lsp.enable("ruby_lsp")
```

### Formato de Configuración

Cada LSP en `lua/config/lspconfig.lua` sigue esta estructura:

```lua
local server_configs = {
  <server_name> = {
    cmd = { "command", "args" },  -- Opcional, detectado automáticamente
    filetypes = { "filetype" },   -- Opcional
    root_dir = function(bufnr)    -- Función de detección de proyecto
      return vim.fs.root(bufnr, { ".git", "Gemfile" })
    end,
    settings = {                  -- Configuración específica del server
      [server_name] = { ... }
    },
  }
}
```

### Path Management

LSPs requieren acceso a shims/binaries de version managers:

```lua
local extra_paths = {
  home .. "/.asdf/shims",
  home .. "/.asdf/bin",
  home .. "/.rbenv/shims",
  home .. "/.rbenv/bin",
}
-- Agregado al PATH antes de inicializar LSPs
```

### LSPs Disponibles

| Lenguaje   | LSP Server | Formatter      | Linter     | DAP Support |
|------------|-----------|----------------|------------|-------------|
| Ruby       | ruby_lsp  | rubocop        | rubocop    | ✅          |
| Elixir     | elixirls  | mix format     | credo      | ✅          |
| Java       | jdtls     | google-java    | built-in   | ✅          |
| Lua        | lua_ls    | stylua         | -          | ❌          |
| Python     | pyright   | black+isort    | ruff       | ❌          |
| Terraform  | terraformls| terraform fmt | -          | ❌          |
| YAML       | yamlls    | yamlfmt        | -          | ❌          |
| Bash       | bashls    | shfmt          | shellcheck | ❌          |
| Docker     | dockerls  | -              | hadolint   | ❌          |

---

## Sistema de Plugins

### Gestión con lazy.nvim

Plugins organizados en archivos individuales en `lua/plugins/`:

**Core plugins** (`core-plugins.lua`):
- Mason (LSP/DAP installer)
- nvim-lspconfig
- nvim-cmp + sources
- nvim-treesitter

**Feature plugins** (archivos separados):
- `telescope.lua` - Fuzzy finder
- `neotree.lua` - File explorer
- `lazygit.lua` - Git TUI
- `copilot.lua` + `copilotchat.lua` - AI assistance
- `jdtls.lua` - Java LSP (configuración compleja)

### Lazy Loading Strategy

```lua
return {
  "plugin/name",
  event = { "BufReadPre", "BufNewFile" },  -- Carga al abrir archivo
  cmd = { "CommandName" },                 -- Carga al ejecutar comando
  ft = { "lua", "python" },                -- Carga por filetype
  keys = { "<leader>ff" },                 -- Carga al presionar tecla
  dependencies = { "required/plugin" },    -- Dependencias
  config = function()
    require("plugin").setup({ ... })
  end,
}
```

---

## Keymaps Organization

### Estructura Modular

Los keymaps están organizados en `lua/config/mappings/` por categoría:

| Archivo       | Contenido                                    | Leader Keys      |
|---------------|----------------------------------------------|------------------|
| general.lua   | Save, quit, navigation, buffers, windows     | `<leader>w/q/e`  |
| telescope.lua | File/content search                          | `<leader>f[fgbhr]` |
| git.lua       | LazyGit, git branches/commits/status         | `<leader>g[gbcs]` |
| lsp.lua       | Go to definition, references, rename, etc.   | `gd/gr/gi`, `<leader>ca/rn` |
| dap.lua       | Debugging: breakpoints, step, continue       | `<F5-F12>`, `<leader>d[br]` |
| plugins.lua   | CopilotChat, Snacks, Bookmarks, Markdown     | `<leader>c[cpd]`, `<leader>s[dpen]` |
| java.lua      | JDTLS: organize imports, extract, refactor   | `<A-o>`, `cr[vmc]` |
| testing.lua   | Neotest, HTTP/REST client                    | `<leader>T[eacs]` |

### Convenciones

- **`<leader>`** = Espacio (por defecto)
- **`g`** prefix = "Go to" navigation (LSP)
- **`<leader>f`** = "Find" (Telescope)
- **`<leader>g`** = "Git" operations
- **`<leader>c`** = "Copilot/Code" AI assistance
- **`<leader>d`** = "Debug" o "Diagnostics"
- **`<leader>T`** = "Test" (mayúscula para distinguir de terminal)

---

## Decisiones Arquitectónicas

### 1. API Nativa LSP vs nvim-lspconfig

**Elegido:** API nativa (`vim.lsp.config` + `vim.lsp.enable`)

**Razones:**
- API oficial de Neovim 0.11+
- Elimina capa de abstracción innecesaria
- Configuración más explícita y transparente
- Mejor control sobre el ciclo de vida del LSP

### 2. Modularización de Keymaps

**Elegido:** Directorio `mappings/` con archivos por categoría

**Razones:**
- Mantenibilidad: fácil encontrar/modificar keymaps
- Escalabilidad: agregar nuevos módulos sin tocar existentes
- Claridad: un archivo de 585 líneas → 8 archivos de ~20-80 líneas
- Eliminación de código comentado (75% del archivo original)

### 3. Plugin Manager: lazy.nvim

**Elegido:** lazy.nvim

**Razones:**
- Lazy loading automático e inteligente
- UI moderna para gestión de plugins
- Lockfile para reproducibilidad
- Perfomance superior a packer.nvim

### 4. JDTLS en Plugin Separado

**Elegido:** `lua/plugins/jdtls.lua` independiente

**Razones:**
- Configuración compleja (~570 líneas)
- Setup de debugging y bundles específico
- Comandos custom (JavaInfo, JavaClean, JavaRestart)
- Isolación de lógica Java

### 5. Formateo con conform.nvim

**Elegido:** conform.nvim + disable LSP formatting

**Razones:**
- Formatters más rápidos (no requieren LSP activo)
- Mayor control sobre formatters (rubocop, prettier, etc.)
- Evita conflictos entre LSP y formatters externos

### 6. Cache Maintenance System

**Elegido:** `utils/cache_maintenance.lua` auto-cleanup

**Razones:**
- Previene errores ENOSPC en macOS
- Limpieza automática de:
  - Mason cache
  - Lazy.nvim cache
  - Neovim state files
- Ejecutado cada 7 días automáticamente

---

## Cómo Agregar Features

### Agregar un Nuevo LSP

1. **Instalar el LSP** (opcional si está en Mason):
   ```bash
   :Mason
   # Buscar e instalar el LSP
   ```

2. **Configurar en `lspconfig.lua`**:
   ```lua
   local server_configs = {
     -- ... LSPs existentes
     new_lsp = {
       settings = {
         new_lsp = {
           -- Configuración específica
         }
       }
     }
   }
   ```

3. **Registrar y activar**:
   ```lua
   for name, cfg in pairs(server_configs) do
     vim.lsp.config(name, vim.tbl_deep_extend("force", {
       capabilities = capabilities,
       on_attach = on_attach,
     }, cfg))
     vim.lsp.enable(name)
   end
   ```

### Agregar un Nuevo Plugin

1. **Crear archivo en `lua/plugins/`**:
   ```lua
   -- lua/plugins/mi-plugin.lua
   return {
     "author/plugin-name",
     event = { "BufReadPre" },  -- Lazy load
     config = function()
       require("plugin-name").setup({
         -- Configuración
       })
     end,
   }
   ```

2. **Lazy.nvim lo detectará automáticamente**

3. **Ejecutar**:
   ```vim
   :Lazy sync
   ```

### Agregar Keymaps Nuevos

1. **Elegir módulo apropiado** en `lua/config/mappings/`
   - `general.lua` para operaciones básicas
   - `plugins.lua` para plugins específicos
   - Crear nuevo módulo si es categoría nueva

2. **Agregar keymaps**:
   ```lua
   vim.keymap.set("n", "<leader>mp", "<cmd>MyPlugin<CR>", {
     desc = "My Plugin Action"
   })
   ```

3. **Si es nuevo módulo, agregarlo a `init.lua`**:
   ```lua
   require("config.mappings.nuevo_modulo")
   ```

### Agregar Debugging (DAP) para Nuevo Lenguaje

1. **Instalar adapter**:
   ```bash
   :Mason
   # Buscar e instalar debug adapter
   ```

2. **Configurar en `lua/config/dap.lua`**:
   ```lua
   local dap = require('dap')
   dap.adapters.new_language = {
     type = 'server',
     host = '127.0.0.1',
     port = 5678,
   }
   dap.configurations.new_language = {
     {
       type = 'new_language',
       request = 'launch',
       name = 'Launch file',
       program = '${file}',
     }
   }
   ```

3. **Keymaps genéricos ya funcionarán** (`<F5>`, `<F10>`, etc.)

---

## Mantenimiento

### Limpiar Cache Manualmente

```vim
:lua require('utils.cache_maintenance').cleanup_all()
```

### Verificar Salud del Sistema

```vim
:checkhealth
```

### Actualizar Plugins

```vim
:Lazy update
```

### Verificar LSPs Activos

```vim
:LspInfo
```

### Ver Logs de LSP

```vim
:LspLog
```

### Comandos Java Específicos

```vim
:JavaInfo          " Información de configuración
:JavaClean         " Limpiar workspace
:JavaRestart       " Reiniciar JDTLS
:JavaNewProject    " Crear proyecto Maven
:JavaOrganizeImports
```

---

## Troubleshooting

### LSP no se inicia

1. Verificar que el LSP está instalado:
   ```vim
   :Mason
   ```

2. Verificar logs:
   ```vim
   :LspLog
   ```

3. Verificar PATH:
   ```vim
   :echo $PATH
   ```

### Formateo no funciona

1. Verificar que `conform.nvim` está configurado
2. Verificar formatter instalado:
   ```bash
   which rubocop
   which prettier
   ```

### Debugging no funciona

1. Verificar adapter instalado en Mason
2. Verificar configuración en `dap.lua`
3. Ver si hay breakpoints:
   ```vim
   :lua require('dap').list_breakpoints()
   ```

### Performance Issues

1. Ejecutar profile:
   ```vim
   :profile start profile.log
   :profile func *
   :profile file *
   " Realizar operaciones lentas
   :profile pause
   :noautocmd qall!
   ```

2. Limpiar cache:
   ```vim
   :lua require('utils.cache_maintenance').cleanup_all()
   ```

---

## Referencias

- [Neovim LSP Documentation](https://neovim.io/doc/user/lsp.html)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [Mason.nvim](https://github.com/williamboman/mason.nvim)
- [JDTLS Documentation](https://github.com/eclipse/eclipse.jdt.ls)
