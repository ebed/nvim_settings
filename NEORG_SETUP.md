# Neorg Setup Instructions

## ⚠️ ESTADO ACTUAL: DESHABILITADO

**Neorg está completamente DESHABILITADO** para evitar errores de parser.

Para usar Neorg, debes seguir los pasos de instalación manual abajo.

**¿Por qué está deshabilitado?**
Neorg requiere un parser tree-sitter especial que debe instalarse manualmente.
Sin el parser, Neorg genera múltiples errores al iniciar Neovim.

**Ubicación de configuración**: `lua/plugins/neorg.lua`

## 🚀 Pasos de Instalación Manual

### Paso 1: Habilitar Neorg

Edita `lua/plugins/neorg.lua` y cambia `enabled = false` a `enabled = true`:

**Cambiar línea 8 de**:
```lua
  enabled = false,  -- Disabled until parser installation
```

**A**:
```lua
  enabled = true,  -- Enable Neorg
```

**También cambia** `lazy = true` **a** `lazy = false`:

```lua
  lazy = false,  -- Load on startup
```

Guarda el archivo.

### Paso 2: Reiniciar Neovim

```vim
:qa
nvim
```

### Paso 3: Instalar Parser de Neorg

Dentro de Neovim, ejecuta:

```vim
:Neorg sync-parsers
```

**Espera 1-2 minutos** mientras se compila e instala el parser.

Verás mensajes como:
```
[neorg] Installing tree-sitter parser for norg...
[neorg] Compiling parser...
[neorg] Parser installed successfully
```

**Si ves errores**:
```bash
# En terminal (fuera de Neovim)
xcode-select --install  # Instalar herramientas de compilación
```

Luego intenta de nuevo `:Neorg sync-parsers`.

### Paso 4: Verificar Instalación

```vim
:checkhealth neorg
```

Deberías ver:
- ✅ Tree-sitter parser installed
- ✅ All modules loaded

Si ves errores, consulta la sección Troubleshooting abajo.

## 🔧 Paso 5: Habilitar Módulos Visuales (Opcional)

Una vez que el parser esté instalado (Paso 4 completado), puedes habilitar los módulos visuales.

Edita `lua/plugins/neorg.lua`:

**1. Habilitar concealer** (líneas ~18-24):

Cambiar de:
```lua
-- ["core.concealer"] = {
--   config = {
--     icon_preset = "varied",
--     folds = true,
--   },
-- },
```

A:
```lua
["core.concealer"] = {
  config = {
    icon_preset = "varied",
    folds = true,
    icons = {
      todo = {
        done = { icon = "✓" },
        pending = { icon = "○" },
        undone = { icon = "✗" },
        uncertain = { icon = "?" },
        on_hold = { icon = "⏸" },
        cancelled = { icon = "⊘" },
        recurring = { icon = "⟲" },
        urgent = { icon = "⚠" },
      },
      heading = {
        icons = { "◉", "◎", "○", "✺", "▶", "⤷" },
      },
      list = {
        icons = { "•", "◦", "▸", "▹" },
      },
    },
  },
},
```

**2. Habilitar completion** (líneas ~27-31):

Cambiar de:
```lua
-- ["core.completion"] = {
--   config = {
--     engine = "nvim-cmp",
--   },
-- },
```

A:
```lua
["core.completion"] = {
  config = {
    engine = "nvim-cmp",
  },
},
```

**3. Recargar configuración**:

```vim
:Lazy sync
:source ~/.config/nvim/init.lua
```

O simplemente reinicia Neovim:
```vim
:qa
nvim
```

## ✅ Verificación Post-Setup

Abre un archivo Neorg:
```vim
:e ~/neorg/journal/index.norg
```

Deberías ver:
- ✅ Syntax highlighting correcto
- ✅ Iconos en TODOs (si concealer habilitado)
- ✅ Headings con iconos personalizados
- ✅ Sin errores en `:messages`

## 🎯 Comandos Básicos

```vim
:Neorg workspace           " Selector de workspace
:Neorg workspace desarrollo " Abrir desarrollo
:Neorg journal today       " Journal de hoy
:Neorg index               " Abrir índice del workspace
```

## 📁 Estructura de Directorios

```
~/neorg/
├── desarrollo/          ← Notas técnicas
│   └── index.norg
├── journal/            ← Bitácora diaria
│   ├── template.norg   ← Template auto
│   └── index.norg
├── proyectos/          ← Proyectos
│   └── index.norg
└── personal/           ← Personal
    └── index.norg
```

## 🐛 Troubleshooting

### Error: "Parser could not be created"

**Causa**: Parser de Neorg no instalado.

**Solución**:
```vim
:Neorg sync-parsers
```

Si falla:
```bash
# En terminal, verifica herramientas de compilación
xcode-select --install

# Luego en Neovim:
:Lazy clean neorg
:Lazy install
:Neorg sync-parsers
```

### Error: "attempt to index a nil value"

**Causa**: Directorios de workspace no existen.

**Solución**:
```bash
mkdir -p ~/neorg/{desarrollo,journal,proyectos,personal}
```

### Concealer no muestra iconos

**Causa**:
1. Parser no instalado
2. Concealer aún comentado

**Solución**:
1. Instalar parser: `:Neorg sync-parsers`
2. Descomentar `core.concealer` en `lua/plugins/neorg.lua`
3. Recargar: `:source ~/.config/nvim/init.lua`

### sync-parsers no funciona

**Alternativa manual**:

```bash
cd ~/.local/share/nvim/lazy/neorg
nvim -c "Neorg sync-parsers" -c "qa"
```

O reinstala Neorg:
```vim
:Lazy clean neorg
:Lazy install
:Neorg sync-parsers
```

### Errores de image.nvim

**Causa**: image.nvim intenta integrarse con Neorg sin parser.

**Solución temporal**: El error es cosmético, ignóralo hasta que el parser esté instalado.

**Solución permanente**: Deshabilitar integración image.nvim con Neorg:

Edita `lua/plugins/image.lua` (si existe) y agrega:
```lua
integrations = {
  neorg = {
    enabled = false,
  },
},
```

## 🔄 Workflow Recomendado

### Primera vez:

1. `:Neorg sync-parsers` (espera instalación)
2. `:qa` (cerrar Neovim)
3. `nvim` (reabrir)
4. Descomentar `core.concealer` y `core.completion`
5. `:Lazy sync`
6. `:e ~/neorg/journal/index.norg` (verificar)

### Uso diario:

```vim
<leader>njt    " Abrir journal de hoy
<leader>nd     " Abrir workspace desarrollo
<leader>nf     " Buscar archivos .norg
```

## 📚 Documentación Completa

- **NEORG_GUIDE.md**: Guía completa de uso, sintaxis, workflows
- **KEYMAPS.md**: Todos los keymaps de Neorg

## Estado del Setup

```
✅ Configuración de Neorg lista (en archivo)
✅ 4 workspaces pre-configurados
✅ Templates de journal creados
✅ Índices pre-creados en ~/neorg/
✅ Keymaps configurados (se activan al habilitar)
❌ Neorg DESHABILITADO (enabled = false)
❌ Parser NO instalado (pendiente manual)
⏸️  Concealer deshabilitado (habilitar después de parser)
⏸️  Completion deshabilitado (habilitar después de parser)
```

## Próximos Pasos

Sigue los "Pasos de Instalación Manual" arriba en orden:

1. ✏️  Editar lua/plugins/neorg.lua (enabled = true)
2. 🔄 Reiniciar Neovim
3. 📦 :Neorg sync-parsers
4. ✅ :checkhealth neorg
5. 🎨 Descomentar concealer y completion (opcional)

---

**Última actualización**: 2026-01-27
**Ver también**: `NEORG_GUIDE.md` para guía de uso completa
