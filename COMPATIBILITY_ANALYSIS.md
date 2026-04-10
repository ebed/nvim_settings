# 🔍 Análisis de Compatibilidad: Config Actual vs Propuesta

**Fecha:** 2026-04-07
**Config actual:** ~/.config/nvim
**Config propuesta:** nvim-wezterm-integration

---

## ✅ BUENAS NOTICIAS: Alta Compatibilidad

Tu configuración actual ya tiene **la mayoría** de los plugins propuestos!

---

## 📦 Plugins: Estado Actual

### ✅ Ya Instalados y Configurados

| Plugin | Estado | Notas |
|--------|--------|-------|
| **lazy.nvim** | ✅ Instalado | Plugin manager (línea 8 init.lua) |
| **telescope** | ✅ Instalado | Fuzzy finder configurado |
| **bufferline** | ✅ Instalado | Tabs visuales para buffers |
| **lualine** | ✅ Instalado | Status line |
| **harpoon** | ✅ Instalado | v2, **SIN keymaps configurados** ⚠️ |
| **toggleterm** | ✅ Instalado | Terminal flotante (config.toggleterm) |
| **snacks.nvim** | ✅ Instalado | **TODO-EN-UNO**: explorer, terminal, picker, notifications |

### ⚠️ Diferencias con la Propuesta

| Propuesta | Actual | Conflicto? |
|-----------|--------|------------|
| neo-tree | **snacks.explorer** | ❌ No (snacks reemplaza neo-tree) |
| toggleterm | **snacks.terminal** + toggleterm | ⚠️ Duplicado (tienes ambos) |
| telescope | **snacks.picker** + telescope | ⚠️ Duplicado (tienes ambos) |
| nvim-notify | **snacks.notifier** | ❌ No (snacks reemplaza nvim-notify) |
| which-key | ❌ No instalado | ⚠️ Faltante (recomendado) |
| persistence.nvim | ❌ No instalado | ⚠️ Faltante (para sesiones) |

---

## ⌨️ Keybindings: Análisis de Conflictos

### 🔴 CONFLICTOS CRÍTICOS (Colemak-DH)

#### 1. `<C-E>` - CONFLICTO MAYOR

**Actual (general.lua línea 6):**
```lua
vim.keymap.set({ "n", "v", "s", "o", "i", "c" }, "<C-E>", "<End>")
```
- Emacs-style: Ir al final de la línea

**Propuesta (keymaps-colemak.lua):**
```lua
map("n", "<C-e>", "<C-w>k", { desc = "↑ Ventana arriba" })
```
- Colemak-DH: Navegar a ventana arriba

**Impacto:** ⚠️ **ALTO** - Rompe navegación Colemak-DH
**Solución:** Remover o redefinir la navegación Emacs-style

#### 2. `<C-A>` - Posible conflicto

**Actual (general.lua línea 5):**
```lua
vim.keymap.set({ "n", "v", "s", "o", "i", "c" }, "<C-A>", "<Home>")
```
- Emacs-style: Ir al inicio de la línea

**Propuesta:** No usa `<C-A>` (no hay conflicto directo)

**Impacto:** ✅ **NINGUNO** - No hay conflicto con propuesta Colemak

---

### ✅ Keybindings Compatibles (Sin Conflictos)

| Keybinding | Actual | Propuesta | Compatible? |
|------------|--------|-----------|-------------|
| `<leader>w` | Save | Save | ✅ Igual |
| `<leader>q` | Quit | Quit | ✅ Igual |
| `<leader>sv` | Split vertical | Split vertical | ✅ Igual |
| `<leader>sh` | Split horizontal | Split horizontal | ✅ Igual |
| `<leader>bn/bp` | Buffer nav | Buffer nav | ✅ Igual |
| `<leader>bd` | Delete buffer | Delete buffer | ✅ Igual |
| `<leader>e` | Snacks explorer | File explorer | ✅ Compatible |
| `<c-/>` | Snacks terminal | (no definido) | ✅ Compatible |

---

### ⚠️ Keybindings Faltantes (De la Propuesta)

Estos keybindings NO existen en tu config actual:

```lua
-- Navegación Colemak-DH (propuesta)
<C-m>  -- Ventana izquierda
<C-n>  -- Ventana abajo
<C-e>  -- Ventana arriba (CONFLICTO con <C-E> actual)
<C-i>  -- Ventana derecha

-- Harpoon (plugin instalado, SIN keymaps)
<leader>ha  -- Add file to harpoon
<leader>hm  -- Harpoon menu
<leader>1-4 -- Jump to marked files

-- Session management (plugin NO instalado)
<leader>ss  -- Save session
<leader>sl  -- Load last session
<leader>sr  -- Restore session
```

---

## 🎯 Análisis de Arquitectura

### Tu Config Actual

```
init.lua (raíz)
├─ config/
│  ├─ base_settings.lua
│  ├─ lazy.lua (plugin manager)
│  ├─ mappings/
│  │  ├─ init.lua (carga todos)
│  │  ├─ general.lua ⚠️ <C-E> conflicto
│  │  ├─ telescope.lua
│  │  ├─ git.lua
│  │  ├─ lsp.lua
│  │  └─ ...
│  ├─ telescope.lua
│  ├─ toggleterm.lua
│  └─ ...
├─ plugins/
│  ├─ snacks.lua (TODO-EN-UNO)
│  ├─ harpoon.lua ⚠️ sin keymaps
│  ├─ bufferline.lua
│  ├─ lualine.lua
│  └─ ...
└─ ...
```

### Propuesta

```
nvim-wezterm-integration/
└─ lua/
   ├─ config/
   │  └─ keymaps-colemak.lua ⚠️ conflicto con general.lua
   └─ plugins/
      └─ workflow.lua (duplica snacks.nvim)
```

---

## 💡 Recomendación: Estrategia de Integración

### Opción A: Integración Mínima (Recomendado) ⭐

**Solo agregar lo que falta:**

1. **Keybindings Colemak-DH** (con ajustes)
2. **Harpoon keymaps** (plugin ya instalado)
3. **Session management** (persistence.nvim)
4. **Which-key** (ayuda visual)

**NO instalar:**
- ❌ neo-tree (ya tienes snacks.explorer)
- ❌ toggleterm extra (ya lo tienes)
- ❌ telescope extra (ya lo tienes)
- ❌ nvim-notify (ya tienes snacks.notifier)

---

### Opción B: Limpiar Duplicados

Si quieres simplificar:

**Decisión 1: Terminal**
```
Opción A: Solo snacks.terminal (<c-/>)
Opción B: Solo toggleterm (<c-\>)
Opción C: Ambos (actual)
```

**Decisión 2: Fuzzy Finder**
```
Opción A: Solo snacks.picker
Opción B: Solo telescope
Opción C: Ambos (actual) ← Común y válido
```

---

## 🚀 Plan de Acción Recomendado

### Paso 1: Arreglar Conflicto <C-E>

**Archivo:** `~/.config/nvim/lua/config/mappings/general.lua`

**Opción A - Remover Emacs-style (recomendado para Colemak):**
```lua
-- COMENTAR O ELIMINAR estas líneas:
-- vim.keymap.set({ "n", "v", "s", "o", "i", "c" }, "<C-A>", "<Home>")
-- vim.keymap.set({ "n", "v", "s", "o", "i", "c" }, "<C-E>", "<End>")
```

**Opción B - Usar teclas alternativas:**
```lua
-- Cambiar a Alt en vez de Ctrl
vim.keymap.set({ "n", "v", "s", "o", "i", "c" }, "<M-A>", "<Home>")
vim.keymap.set({ "n", "v", "s", "o", "i", "c" }, "<M-E>", "<End>")
```

---

### Paso 2: Agregar Keymaps Colemak-DH

**Crear:** `~/.config/nvim/lua/config/mappings/navigation_colemak.lua`

```lua
-- Navegación Colemak-DH entre ventanas
vim.keymap.set("n", "<C-m>", "<C-w>h", { desc = "← Ventana izquierda" })
vim.keymap.set("n", "<C-n>", "<C-w>j", { desc = "↓ Ventana abajo" })
vim.keymap.set("n", "<C-e>", "<C-w>k", { desc = "↑ Ventana arriba" })
vim.keymap.set("n", "<C-i>", "<C-w>l", { desc = "→ Ventana derecha" })

-- Resize ventanas
vim.keymap.set("n", "<M-m>", "<cmd>vertical resize -2<cr>", { desc = "Reducir ancho" })
vim.keymap.set("n", "<M-i>", "<cmd>vertical resize +2<cr>", { desc = "Aumentar ancho" })
vim.keymap.set("n", "<M-n>", "<cmd>resize +2<cr>", { desc = "Aumentar alto" })
vim.keymap.set("n", "<M-e>", "<cmd>resize -2<cr>", { desc = "Reducir alto" })

-- Terminal mode navigation
vim.keymap.set("t", "<C-m>", "<C-\\><C-n><C-w>h", { desc = "← Ventana izquierda" })
vim.keymap.set("t", "<C-n>", "<C-\\><C-n><C-w>j", { desc = "↓ Ventana abajo" })
vim.keymap.set("t", "<C-e>", "<C-\\><C-n><C-w>k", { desc = "↑ Ventana arriba" })
vim.keymap.set("t", "<C-i>", "<C-\\><C-n><C-w>l", { desc = "→ Ventana derecha" })
```

**Luego agregar a:** `~/.config/nvim/lua/config/mappings/init.lua`

```lua
require("config.mappings.navigation_colemak")  -- NUEVO
```

---

### Paso 3: Agregar Keymaps Harpoon

**Crear:** `~/.config/nvim/lua/config/mappings/harpoon.lua`

```lua
-- Harpoon keymaps (plugin ya instalado)
local harpoon = require("harpoon")

vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon: Add file" })
vim.keymap.set("n", "<leader>hm", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon: Menu" })

-- Quick navigation
vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon: File 1" })
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon: File 2" })
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon: File 3" })
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon: File 4" })
```

**Agregar a:** `~/.config/nvim/lua/config/mappings/init.lua`

```lua
require("config.mappings.harpoon")  -- NUEVO
```

---

### Paso 4: Agregar Plugins Faltantes

**Crear:** `~/.config/nvim/lua/plugins/workflow_extras.lua`

```lua
return {
  -- Which-key: ayuda de keybindings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register({
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>f"] = { name = "+find" },
        ["<leader>h"] = { name = "+harpoon" },
        ["<leader>s"] = { name = "+session/search" },
        ["<leader>t"] = { name = "+terminal/test" },
      })
    end,
  },

  -- Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>ss", function() require("persistence").save() end, desc = "Save session" },
      { "<leader>sl", function() require("persistence").load({ last = true }) end, desc = "Load last session" },
      { "<leader>sr", function() require("persistence").load() end, desc = "Restore session for cwd" },
    },
  },
}
```

---

## 📋 Checklist de Implementación

```
[ ] 1. Backup config actual
       tar -czf ~/.config/nvim-backup-$(date +%Y%m%d).tar.gz ~/.config/nvim

[ ] 2. Arreglar conflicto <C-E>
       Editar: ~/.config/nvim/lua/config/mappings/general.lua
       Comentar líneas 5-6

[ ] 3. Crear keymaps Colemak-DH
       Crear: ~/.config/nvim/lua/config/mappings/navigation_colemak.lua
       Agregar require en mappings/init.lua

[ ] 4. Crear keymaps Harpoon
       Crear: ~/.config/nvim/lua/config/mappings/harpoon.lua
       Agregar require en mappings/init.lua

[ ] 5. Agregar plugins faltantes
       Crear: ~/.config/nvim/lua/plugins/workflow_extras.lua

[ ] 6. Restart Neovim y ejecutar :Lazy sync

[ ] 7. Probar navegación Colemak-DH
       <C-m/n/e/i> entre ventanas

[ ] 8. Probar Harpoon
       <leader>ha para marcar, <leader>1-4 para navegar

[ ] 9. Probar Which-key
       Presionar <leader> y esperar
```

---

## 🎓 Conclusión

### Tu config actual es EXCELENTE

- ✅ Ya tienes 90% de lo que necesitas
- ✅ Snacks.nvim es más moderno que mi propuesta
- ⚠️ Solo necesitas agregar:
  - Keymaps Colemak-DH
  - Harpoon keymaps
  - Which-key
  - Session management

### NO necesitas instalar la propuesta completa

La propuesta `nvim-wezterm-integration` fue diseñada para una instalación desde cero.
**Tu config actual es superior** - solo necesita pequeños ajustes.

---

## 🔧 Scripts de Ayuda

### Verificar conflictos

```bash
# Ver <C-E> actual
grep -n "C-E" ~/.config/nvim/lua/config/mappings/general.lua

# Ver plugins instalados
nvim --headless "+Lazy show" +q 2>&1 | grep -i "harpoon\|snacks\|which"
```

### Rollback si algo falla

```bash
# Restaurar backup
rm -rf ~/.config/nvim
tar -xzf ~/.config/nvim-backup-YYYYMMDD.tar.gz -C ~/
```

---

¿Quieres que proceda con la integración mínima (Opción A)?
