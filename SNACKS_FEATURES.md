# Snacks.nvim Features - Alternativa Mejorada a Noice

Snacks.nvim proporciona una experiencia visual mejorada sin los problemas de estabilidad de Noice.

---

## 🎨 Features Visuales Activadas

### 1. **Notificaciones Elegantes**
Sistema de notificaciones con iconos y estilos mejorados.

**Características**:
- ✅ Notificaciones con iconos por nivel (error, warn, info, debug)
- ✅ Bordes redondeados
- ✅ Auto-dismiss después de 3 segundos
- ✅ Stack de notificaciones en la esquina
- ✅ Historial de notificaciones

**Uso**:
```vim
:lua vim.notify("Mensaje de prueba", vim.log.levels.INFO)
<leader>n       " Ver historial de notificaciones
<leader>un      " Cerrar todas las notificaciones
```

**Niveles**:
```lua
vim.log.levels.ERROR  --
vim.log.levels.WARN   --
vim.log.levels.INFO   --
vim.log.levels.DEBUG  --
vim.log.levels.TRACE  --
```

---

### 2. **LSP Progress Integration**
Muestra el progreso de language servers como notificaciones.

**Características**:
- ✅ Notificaciones automáticas cuando LSP inicia
- ✅ Progreso de indexación de proyectos
- ✅ Notificaciones al completar tareas
- ✅ No intrusivo (solo eventos importantes)

**Ejemplo visual**:
```
 ruby_lsp - Indexing
Starting...

 ruby_lsp - Indexing
Complete
```

---

### 3. **Input/Prompt Mejorado**
Dialogs de input con mejor visualización.

**Características**:
- ✅ Centrado en pantalla
- ✅ Bordes redondeados
- ✅ Títulos descriptivos

**Se usa automáticamente en**:
- Renombrar símbolos (LSP rename)
- Git commit messages
- Search/Replace
- Command palette

---

### 4. **Terminal Flotante**
Terminal integrado con mejor UI.

**Keymaps**:
```vim
<C-/>           " Toggle terminal flotante
<leader>tt      " Toggle terminal (alternativo)
```

**Características**:
- ✅ Ventana flotante 80% de la pantalla
- ✅ Bordes redondeados
- ✅ Título "Terminal"
- ✅ Fácil de cerrar con <Esc> o <C-/>

---

### 5. **Scratch Buffer**
Buffer temporal para notas rápidas.

**Keymaps**:
```vim
<leader>.       " Toggle scratch buffer
<leader>S       " Selector de scratch buffers
```

**Características**:
- ✅ Markdown por defecto
- ✅ No se guarda automáticamente
- ✅ Perfecto para notas temporales
- ✅ Múltiples scratch buffers

**Uso común**:
```vim
<leader>.
# Escribe notas rápidas
# Copiar/pegar código temporal
# Calcular expresiones
<leader>.       " Cerrar
```

---

### 6. **Zen Mode & Zoom**
Modo concentración sin distracciones.

**Keymaps**:
```vim
<leader>z       " Toggle Zen Mode (centra el código, oculta UI)
<leader>Z       " Toggle Zoom (maximiza ventana actual)
```

**Características Zen**:
- ✅ Fondo oscurecido (backdrop)
- ✅ Oculta statusline, tabline, signcolumn
- ✅ Código centrado (80% ancho)
- ✅ Perfecto para escribir/leer código

---

### 7. **Picker/Finder Mejorado**
Fuzzy finder con preview y mejor UI.

**Keymaps principales**:
```vim
<leader><space>     " Smart picker (archivos + más)
<leader>,           " Buffers
<leader>/           " Live grep
<leader>:           " Command history
<leader>ff          " Find files
<leader>fg          " Git files
<leader>fr          " Recent files
```

**Características**:
- ✅ Preview automático
- ✅ Múltiples fuentes (archivos, buffers, git, etc.)
- ✅ Búsqueda incremental
- ✅ Integración con LSP (symbols, definitions, etc.)

---

### 8. **Git Integration Visual**
Comandos git con mejor visualización.

**Keymaps**:
```vim
<leader>gb      " Git branches (picker)
<leader>gl      " Git log
<leader>gs      " Git status
<leader>gd      " Git diff (hunks)
<leader>gB      " Git browse (abre en GitHub/GitLab)
<leader>gg      " LazyGit
```

---

### 9. **Toggles Visuales**
Activar/desactivar features con feedback visual.

**Keymaps disponibles**:
```vim
<leader>us      " Toggle Spelling
<leader>uw      " Toggle Wrap
<leader>uL      " Toggle Relative Numbers
<leader>ud      " Toggle Diagnostics
<leader>ul      " Toggle Line Numbers
<leader>uc      " Toggle Conceal Level
<leader>uT      " Toggle Treesitter
<leader>ub      " Toggle Dark/Light Background
<leader>uh      " Toggle Inlay Hints
<leader>ug      " Toggle Indent Guides
<leader>uD      " Toggle Dim Inactive Windows
```

---

## 🎯 Comparación con Noice

| Feature | Noice | Snacks | Estado |
|---------|-------|--------|--------|
| Notificaciones | ✅ | ✅ | Mejor en Snacks |
| LSP Progress | ✅ | ✅ | Igual |
| Command Palette | ✅ | ❌ | Causaba crashes |
| Input Mejorado | ✅ | ✅ | Igual |
| Terminal | ❌ | ✅ | Solo Snacks |
| Zen Mode | ❌ | ✅ | Solo Snacks |
| Picker | ❌ | ✅ | Solo Snacks |
| Estabilidad | ⚠️ | ✅ | **Snacks gana** |

---

## 🔧 Configuración Personalizada

### Cambiar Timeout de Notificaciones

Edita `lua/plugins/snacks.lua`:
```lua
notifier = {
  timeout = 5000,  -- 5 segundos (default: 3000)
}
```

### Cambiar Posición del Terminal

```lua
terminal = {
  win = {
    position = "bottom",  -- o "top", "left", "right", "float"
    height = 0.3,
  },
}
```

### Deshabilitar LSP Progress Notifications

Comenta el autocmd en `snacks.lua`:
```lua
-- vim.api.nvim_create_autocmd("LspProgress", {
--   callback = function(ev)
--     ...
--   end,
-- })
```

---

## 💡 Tips y Trucos

### 1. Ver Historial de Notificaciones
```vim
<leader>n
```
Útil cuando te perdiste una notificación importante.

### 2. Buscar Comandos Recientes
```vim
<leader>:
<leader>sc
```
Busca en tu historial de comandos.

### 3. Terminal Rápido para Comandos Git
```vim
<C-/>
git status
<C-/>
```

### 4. Scratch Buffer para Cálculos
```vim
<leader>.
:=2+2
:=math.sqrt(16)
```

### 5. Zen Mode para Presentations
```vim
<leader>z       " Activar Zen Mode
:set nonumber   " Ocultar números de línea
:set noshowmode " Ocultar modo
```

---

## 🐛 Troubleshooting

### Las Notificaciones No Se Ven

1. Verifica que Snacks está cargado:
   ```vim
   :lua print(vim.inspect(Snacks))
   ```

2. Test manual:
   ```vim
   :lua Snacks.notifier.notify("Test", { level = "info" })
   ```

### Terminal No Abre

1. Verifica keymaps:
   ```vim
   :verbose map <C-/>
   ```

2. Prueba comando directo:
   ```vim
   :lua Snacks.terminal()
   ```

### Picker Es Lento

El picker de Snacks es muy rápido. Si es lento:
1. Verifica que no tienes directorios enormes (node_modules, .git)
2. Usa `.gitignore` para excluir archivos

---

## 📚 Documentación Completa

- [Snacks.nvim GitHub](https://github.com/folke/snacks.nvim)
- Configuración local: `lua/plugins/snacks.lua`
- Keymaps: Ver `:Telescope keymaps` y buscar "Snacks"

---

## 🎉 Features Únicas de Snacks

### Dashboard con Fortune + Cowsay
Al abrir Neovim sin archivo:
```
 _______________________
< Fortune of the day... >
 -----------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

### Debug Utilities
```vim
:lua dd(vim.lsp.get_clients())  " Debug inspect
:lua bt()                        " Backtrace
```

### Smart Picker
```vim
<leader><space>
```
Detecta contexto automáticamente:
- En git repo: git files
- Fuera de git: all files
- Con texto seleccionado: grep

---

**Conclusión**: Snacks ofrece una experiencia visual moderna y estable, siendo una alternativa superior a Noice sin los problemas de crashes. ✨
