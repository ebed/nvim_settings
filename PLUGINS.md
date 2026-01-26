# Plugins Overview

## 📦 Lista Completa de Plugins

### 🔧 Core Development

| Plugin | Propósito | Comandos Principales |
|--------|-----------|---------------------|
| **lazy.nvim** | Plugin manager | `:Lazy`, `:Lazy sync`, `:Lazy update` |
| **mason.nvim** | LSP/DAP installer | `:Mason`, `:MasonUpdate` |
| **nvim-lspconfig** | LSP configuration | `:LspInfo`, `:LspLog`, `:LspRestart` |
| **nvim-treesitter** | Syntax highlighting | `:TSUpdate`, `:TSInstall <lang>` |
| **nvim-cmp** | Autocompletion | N/A (automático) |
| **LuaSnip** | Snippet engine | N/A (con <Tab>) |

---

### 💡 LSP & Language Support

| Plugin | Lenguaje | Features |
|--------|----------|----------|
| **nvim-jdtls** | Java | LSP + DAP + Refactoring |
| **elixir.lua** | Elixir | LSP + TreeSitter |
| **ruby_lsp** | Ruby | LSP (via Mason) |
| **lazydev.lua** | Lua | Neovim API completions |

---

### 🐛 Debugging

| Plugin | Propósito |
|--------|-----------|
| **nvim-dap** | Debug Adapter Protocol |
| **nvim-dap-ui** | UI para debugging |
| **nvim-dap-virtual-text** | Texto virtual en debug |

---

### 🔍 Search & Navigation

| Plugin | Propósito | Comandos |
|--------|-----------|----------|
| **telescope.nvim** | Fuzzy finder | `:Telescope <picker>` |
| **neo-tree.nvim** | File explorer | `:Neotree` |
| **flash.nvim** | Enhanced f/t motions | `s`, `S` |
| **leap.nvim** | Motion plugin | `s`, `S`, `R` |
| **harpoon** | Quick file marks | `<C-e>` |

---

### 🌿 Git Integration

| Plugin | Propósito | Comandos |
|--------|-----------|----------|
| **lazygit.nvim** | LazyGit TUI | `:LazyGit` |
| **gitsigns.nvim** | Git signs en gutter | `:Gitsigns <action>` |
| **vgit.nvim** | Git diff visualizer | Ver mappings |
| **neogit** | Neovim git client | `:Neogit` |
| **gitgraph.nvim** | Git graph visualizer | `:GitGraph` |
| **gitwiz.nvim** | Git wizard | Ver plugin config |
| **octo.nvim** | GitHub integration | `:Octo <action>` |

---

### 🤖 AI Assistance

| Plugin | Propósito | Comandos |
|--------|-----------|----------|
| **copilot.lua** | GitHub Copilot | N/A (automático) |
| **copilot-cmp** | Copilot en completions | N/A |
| **CopilotChat.nvim** | AI chat interface | `:CopilotChat<Action>` |

---

### 🎨 UI & Appearance

| Plugin | Propósito |
|--------|-----------|
| **lualine.nvim** | Statusline |
| **bufferline.nvim** | Buffer tabs |
| **indent-blankline.nvim** | Indent guides |
| **noice.nvim** | Better command line |
| **snacks.nvim** | Collection of QoL features |
| **dashboard.nvim** | Start screen |
| **dressing.nvim** | Better vim.ui interfaces |
| **fidget.nvim** | LSP progress UI |

---

### 📝 Editing & Formatting

| Plugin | Propósito | Comandos |
|--------|-----------|----------|
| **conform.nvim** | Formatting | `:ConformInfo` |
| **nvim-lint** | Linting | N/A (automático) |
| **nvim-autopairs** | Auto close brackets | N/A |
| **Comment.nvim** | Comments | `gcc`, `gbc` |
| **inc-rename.nvim** | Incremental rename | `:IncRename` |
| **actions-preview.nvim** | Code action preview | Ver con `<leader>ca` |

---

### 🧪 Testing

| Plugin | Propósito | Comandos |
|--------|-----------|----------|
| **neotest** | Testing framework | `:Neotest <action>` |
| **rest.nvim** | HTTP/REST client | `:Rest run` |
| **vim-dadbod** | Database interface | `:DB <query>` |
| **vim-dadbod-ui** | Database UI | `:DBUI` |

---

### 📚 Documentation & Notes

| Plugin | Propósito | Comandos |
|--------|-----------|----------|
| **neorg** | Note-taking | `:Neorg workspace <name>` |
| **markdown-preview.nvim** | Markdown preview | `:MarkdownPreview` |
| **markview.nvim** | Markdown renderer | N/A (automático) |
| **render-markdown.nvim** | MD rendering | N/A |

---

### 🔌 Utilities

| Plugin | Propósito |
|--------|-----------|
| **plenary.nvim** | Lua utilities (dependency) |
| **nvim-nio** | Async I/O library |
| **which-key.nvim** | Key binding helper |
| **toggleterm.nvim** | Terminal toggler |
| **oil.nvim** | Edit filesystem like buffer |
| **precognition.nvim** | Motion hints |

---

### 🎯 Productivity

| Plugin | Propósito |
|--------|-----------|
| **todo-comments.nvim** | Highlight TODO/FIXME |
| **trouble.nvim** | Diagnostics list |
| **aerial.nvim** | Code outline |
| **marks.nvim** | Better marks visualization |
| **beacon.nvim** | Cursor jump highlighter |
| **nvim-colorizer.lua** | Color preview |
| **guess-indent.nvim** | Auto detect indentation |
| **sleuth.vim** | Auto detect indent settings |

---

## 📋 Plugin Management

### Instalar/Actualizar Todos

```vim
:Lazy sync
```

### Actualizar Solo Uno

```vim
:Lazy update <plugin-name>
```

### Ver Estado de Plugins

```vim
:Lazy
```

### Ver Profile de Carga

```vim
:Lazy profile
```

### Limpiar Plugins No Usados

```vim
:Lazy clean
```

---

## 🎯 Plugins Destacados por Workflow

### Para Ruby Development

- **ruby_lsp** (LSP)
- **nvim-dap** + config para Ruby
- **neotest** con adapter de RSpec
- **vim-dadbod** para queries SQL

### Para Elixir Development

- **elixir.lua** (LSP + TreeSitter)
- **nvim-dap** con config para Elixir
- **neotest** con adapter de ExUnit

### Para Java Development

- **nvim-jdtls** (LSP completo)
- **nvim-dap** integrado con JDTLS
- Maven/Gradle support via terminal

### Para Web Development

- **typescript** LSP
- **tailwind-tools.nvim** para Tailwind
- **rest.nvim** para APIs
- **markdown-preview** para docs

### Para DevOps

- **terraform** LSP
- **yaml** LSP con schemas
- **docker** LSP
- **kubernetes** snippets

---

## 🔧 Configuración de Plugins

Los plugins están en:

```
~/.config/nvim/lua/plugins/
```

Cada plugin tiene su propio archivo (ej: `telescope.lua`, `neotree.lua`).

### Agregar Nuevo Plugin

1. Crear archivo `lua/plugins/mi-plugin.lua`:

```lua
return {
  "author/plugin-name",
  event = { "BufReadPre" },
  config = function()
    require("plugin-name").setup({
      -- config aquí
    })
  end,
}
```

2. Ejecutar `:Lazy sync`

### Desactivar Plugin Temporalmente

Comentar el `return` statement:

```lua
return {}  -- Desactivado
-- return {
--   "author/plugin-name",
--   ...
-- }
```

---

## 🐛 Troubleshooting Plugins

### Plugin no carga

```vim
:Lazy load <plugin-name>
```

### Ver logs de errores

```vim
:messages
:Lazy log
```

### Rebuild plugins

```vim
:Lazy build <plugin-name>
```

### Limpiar cache

```vim
:lua require('utils.cache_maintenance').cleanup_all()
```

---

## 📊 Estadísticas

**Total Plugins:** ~87
**Lazy loaded:** ~85%
**Startup time:** <50ms (con lazy loading)

---

## 🔗 Referencias

- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [awesome-neovim](https://github.com/rockerBOO/awesome-neovim)
- Plugin configs en esta configuración: `~/.config/nvim/lua/plugins/`
