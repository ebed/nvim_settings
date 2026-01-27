# Neorg Setup Instructions

## ⚠️ Estado Actual

Neorg está configurado pero con algunos módulos **deshabilitados temporalmente** hasta que los parsers se instalen.

**Módulos deshabilitados**:
- `core.concealer` (iconos y markup visual)
- `core.completion` (autocompletado)

**Módulos habilitados** (funcionan sin parser):
- `core.dirman` (workspaces)
- `core.journal` (bitácora)
- `core.keybinds`
- Todos los demás módulos básicos

## 🚀 Instalación del Parser (Primer Uso)

### Método 1: Comando Neorg (Recomendado)

```vim
:Neorg sync-parsers
```

Espera a que termine la instalación (puede tardar 1-2 minutos).

### Método 2: Instalación Automática

Simplemente abre un archivo `.norg`:

```vim
:e ~/neorg/journal/index.norg
```

Neorg detectará que falta el parser e intentará instalarlo automáticamente.

### Verificar Instalación

```vim
:checkhealth neorg
```

Deberías ver ✅ junto a "Tree-sitter parser".

## 🔧 Habilitar Módulos Completos

Una vez que el parser esté instalado, edita `lua/plugins/neorg.lua`:

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
✅ Configuración de Neorg instalada
✅ 4 workspaces configurados
✅ Templates de journal creados
✅ Índices pre-creados
✅ Keymaps configurados
⏸️  Parser pendiente (instalar con :Neorg sync-parsers)
⏸️  Concealer deshabilitado (habilitar después de parser)
⏸️  Completion deshabilitado (habilitar después de parser)
```

## Próximo Paso

**Instala el parser ahora**:

```vim
:Neorg sync-parsers
```

Luego sigue las instrucciones de "Habilitar Módulos Completos" arriba.

---

**Última actualización**: 2026-01-27
**Ver también**: `NEORG_GUIDE.md` para guía de uso completa
