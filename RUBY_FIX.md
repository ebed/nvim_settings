# Fix Ruby LSP para PagerDuty

## 🔧 Problema Identificado

`ruby-lsp` intentaba crear un "composed bundle" en `.ruby-lsp/` que hacía `bundle install` con timeouts al conectarse al repositorio interno de PagerDuty.

## ✅ Solución Implementada

1. **Variables de entorno** para desactivar composed bundle:
   - `RUBY_LSP_EXPERIMENTAL_FEATURES=0`
   - `RUBY_LSP_DISABLE_COMPOSED_BUNDLE=1`

2. **Configuración simplificada** en `lspconfig.lua`

3. **Eliminado** el directorio `.ruby-lsp/` problemático

## 🚀 Uso

### Iniciar Neovim en proyecto Ruby/Rails

```bash
cd ~/workspaces/Pagerduty/web
nvim app/models/user.rb
```

El LSP debería iniciar automáticamente en ~2 segundos (sin bundle install).

### Comandos Útiles

```vim
:RubyCheck              " Ver estado del LSP
:RubyLspCleanCache      " Limpiar .ruby-lsp/ si vuelve a crearse
:LspInfo                " Información detallada del LSP
:LspRestart             " Reiniciar LSP
```

### Funciones LSP Disponibles

| Atajo | Función |
|-------|---------|
| `K` | Ver documentación |
| `gd` | Ir a definición |
| `gr` | Ver referencias |
| `<leader>ca` | Code actions |
| `<leader>rn` | Renombrar |
| `[d` / `]d` | Navegar diagnósticos |

### Formateo

```vim
<leader>f    " Formatear con rubocop (conform.nvim)
```

## ⚠️ Si el problema persiste

1. Verifica que el LSP arrancó:
   ```vim
   :RubyCheck
   ```

2. Si dice "ruby_lsp activo: ✗", revisa logs:
   ```vim
   :LspLog
   ```

3. Si ves mensajes de "bundle install", elimina el cache:
   ```vim
   :RubyLspCleanCache
   ```

4. Reinicia Neovim completamente

## 📝 Configuración

La configuración usa:
- **LSP**: `ruby-lsp` (sin composed bundle)
- **Formateo**: `rubocop` vía `conform.nvim`
- **Tests**: `neotest` con RSpec/Minitest

Todo está en:
- `lua/config/lspconfig.lua` - Configuración LSP
- `lua/plugins/conform.lua` - Configuración formateo
- `lua/config/ruby_check.lua` - Comandos diagnóstico
