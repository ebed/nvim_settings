# Known Issues and Solutions

## 🔴 CRÍTICO: Neovim Crash al Presionar `:`

### Síntoma
Neovim se cierra inesperadamente al presionar `:` para entrar al command line.

### Causa Identificada
**Noice.nvim** con `command_palette = true` causa crashes en Neovim 0.11.5 en macOS.

### Solución Aplicada
Noice ha sido **deshabilitado permanentemente** hasta que se resuelva el problema upstream.

**Archivo afectado**: `lua/plugins/noice.lua`
- Movido a: `archive/noice.lua`
- Reemplazado por: stub vacío con comentario explicativo

### Alternativas a Noice

Si necesitas notificaciones mejoradas, usa:

#### Opción 1: Snacks.nvim (Ya instalado)
```lua
-- Ya configurado en lua/plugins/snacks.lua
Snacks.notifier.notify("Mensaje", "info")
```

#### Opción 2: nvim-notify (Ligero)
```lua
return {
  "rcarriga/nvim-notify",
  config = function()
    require("notify").setup({
      timeout = 3000,
      render = "minimal",
    })
    vim.notify = require("notify")
  end,
}
```

### Si Quieres Reactivar Noice (No Recomendado)

**Solo si el bug fue arreglado en versiones futuras:**

1. Restaura el archivo:
   ```bash
   cp ~/.config/nvim/archive/noice.lua ~/.config/nvim/lua/plugins/
   ```

2. Modifica la configuración para deshabilitar command_palette:
   ```lua
   presets = {
     command_palette = false,  -- IMPORTANTE: Mantener en false
     bottom_search = true,
     long_message_to_split = false,
   }
   ```

3. Prueba con:
   ```bash
   nvim
   :echo "test"
   ```

4. Si crashea, deshabilita inmediatamente:
   ```bash
   rm ~/.config/nvim/lua/plugins/noice.lua
   ```

---

## ⚠️  Neorg Parser No Instalado

### Síntoma
```
Parser could not be created for buffer and language "norg"
```

### Causa
Neorg requiere su propio parser de Treesitter que debe instalarse manualmente.

### Solución

**Neorg está deshabilitado por defecto** hasta que instales el parser:

1. Habilita Neorg temporalmente:
   ```bash
   # Restaura desde archivo deshabilitado
   mv ~/.config/nvim/lua/plugins/neorg.lua.disabled ~/.config/nvim/lua/plugins/neorg.lua
   ```

2. Instala el parser:
   ```bash
   nvim --headless "+Neorg sync-parsers" "+qa"
   ```

3. Verifica instalación:
   ```vim
   nvim
   :checkhealth neorg
   ```

**Guía completa**: Ver `NEORG_SETUP.md`

---

## 🔧 Troubleshooting General

### Neovim Crashea al Inicio

1. **Identifica el plugin problemático**:
   ```bash
   nvim --startuptime /tmp/startup.log
   cat /tmp/startup.log
   ```

2. **Deshabilita plugins uno a uno**:
   ```bash
   cd ~/.config/nvim/lua/plugins
   mv plugin_sospechoso.lua plugin_sospechoso.lua.disabled
   ```

3. **Limpia caché**:
   ```bash
   rm -rf ~/.local/state/nvim/lazy/state.json
   rm -rf ~/.cache/nvim/lazy/
   ```

### Command Line No Responde

Si `:` no hace nada o crashea:

1. **Verifica plugins de UI**:
   - Noice (deshabilitado)
   - Snacks input/picker
   - WhichKey
   - Telescope

2. **Test en modo minimal**:
   ```bash
   nvim --clean -c ":echo 'test'"
   ```

3. **Si funciona en --clean**, el problema es un plugin.

### LSP No Funciona

Ver `ARCHITECTURE.md` sección "Troubleshooting".

---

## 📊 Estado de Plugins Problemáticos

| Plugin | Estado | Razón | Alternativa |
|--------|--------|-------|-------------|
| Noice | ❌ Deshabilitado | Crashes en command line | Snacks.notifier |
| Neorg | ⏸️  Deshabilitado | Parser no instalado | Habilitar tras instalar parser |

---

## ✅ JDTLS Message Spam (FIXED)

### Síntoma (Resuelto)
```
Building
Building
Validate documents
Publish Diagnostics
(repetido cientos de veces)
```

También aparecía:
```
copilot: Unknown command: java.edit.organizeImports
```

### Causa
- JDTLS envía mensajes de progreso excesivos
- Copilot intentaba usar comando no existente `java.edit.organizeImports`

### Solución Aplicada

**Triple capa de filtrado**:

1. **En JDTLS** (`lua/plugins/jdtls.lua`):
   - Handler de `$/progress` que filtra mensajes repetitivos

2. **En Snacks** (`lua/plugins/snacks.lua`):
   - Filtro específico para JDTLS en `LspProgress`
   - No muestra "Building", "Validate", "Publish Diagnostics"

3. **Global** (`lua/config/jdtls_fixes.lua`):
   - Override de `window/showMessage` y `window/logMessage`
   - Suprime error de Copilot específicamente

**Comando nuevo**:
```vim
:OrganizeImports    " Funciona para todos los lenguajes
```

### Keymaps de Copilot Actualizados

```vim
<M-l>       " Aceptar sugerencia
<M-]>       " Siguiente sugerencia
<M-[>       " Sugerencia anterior
<C-]>       " Descartar sugerencia
```

---

## ✅ Wildcard Import Warnings (FILTERED)

### Síntoma (Resuelto)
LSP muestra warnings sobre uso de wildcards en imports:
```
Avoid using wildcard imports
Avoid on-demand imports
```

### Causa
JDTLS, Checkstyle o PMD reportan warnings cuando usas `import java.util.*;`

### Solución Aplicada

**Filtro automático de diagnósticos**: Los warnings sobre wildcards son filtrados automáticamente.

**Implementación**:
- `lua/config/java_diagnostic_filter.lua`: Módulo de filtrado
- `lua/plugins/jdtls.lua`: Handler de `textDocument/publishDiagnostics`

**Patrones filtrados**:
- "wildcard"
- "avoid.*\*"
- "on demand"
- "star import"
- "avoid using.*import"

### Comandos

```vim
:ToggleWildcardWarnings  " Activar/desactivar filtro temporalmente
```

### Configuración

**Deshabilitar permanentemente**:
```lua
-- lua/config/java_diagnostic_filter.lua
M.config = {
  enabled = false,  -- Cambiar a false
}
```

**Agregar patrones personalizados**:
```lua
patterns = {
  "wildcard",
  "tu patrón personalizado",
}
```

---

## 📝 Reportar Nuevos Problemas

Si encuentras un nuevo problema:

1. Reproduce en modo minimal:
   ```bash
   nvim --clean
   ```

2. Captura logs:
   ```bash
   tail -100 ~/.local/state/nvim/lsp.log
   ```

3. Documenta en este archivo con:
   - Síntoma
   - Pasos para reproducir
   - Solución aplicada

---

## 🔗 Referencias

- [Noice Issue Tracker](https://github.com/folke/noice.nvim/issues)
- [Neorg Troubleshooting](https://github.com/nvim-neorg/neorg/wiki/Troubleshooting)
- Configuración local: Ver `ARCHITECTURE.md`
