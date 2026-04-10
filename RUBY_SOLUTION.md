# ✅ Solución Ruby LSP - PagerDuty

## 🔍 Problema Root Cause

1. **ruby-lsp NO está en el Gemfile** del proyecto PagerDuty
2. La configuración intentaba usar `bundle exec ruby-lsp` → **FALLA**
3. ruby-lsp creaba un "composed bundle" en `.ruby-lsp/` con `bundle install` → **TIMEOUT**

## ✅ Solución Implementada

### 1. Usar ruby-lsp Global (NO bundle exec)

```lua
-- lua/config/lspconfig.lua
local function ruby_cmd()
  return { "ruby-lsp" }  -- SIN bundle exec
end
```

### 2. Configuración Global de ruby-lsp

Archivo: `~/.config/ruby-lsp/config.json`
```json
{
  "enableExperimentalFeatures": false,
  "formatter": "rubocop"
}
```

### 3. Configuración por Proyecto

Archivo: `~/workspaces/Pagerduty/web/.ruby-lsp/config.yml`
```yaml
enableExperimentalFeatures: false
bundleGemfile: ""
```

### 4. Variable de Entorno

Añadido a `~/.zshrc`:
```bash
export RUBY_LSP_EXPERIMENTAL_FEATURES=0
```

## 🚀 Pasos para Aplicar

**1. Reinicia tu terminal** (para cargar las variables de entorno):
```bash
# Cierra y abre una nueva terminal
# O ejecuta:
source ~/.zshrc
```

**2. Reinicia Neovim completamente** (cierra todas las instancias)

**3. Abre un archivo Ruby en PagerDuty:**
```bash
cd ~/workspaces/Pagerduty/web
nvim app/models/user.rb
```

**4. Verifica que funcione:**
```vim
:RubyCheck
```

Deberías ver:
```
ruby_lsp activo: ✓
ID: X, Root: /Users/.../workspaces/Pagerduty/web
```

**5. Prueba las funciones LSP:**
- `K` sobre un método → Ver documentación
- `gd` → Ir a definición
- `<leader>ca` → Code actions
- `<leader>f` → Formatear con rubocop

## 🎯 Comandos Útiles

```vim
:RubyCheck              " Ver estado del LSP
:RubyLspCleanCache      " Limpiar .ruby-lsp/ si se crea
:LspInfo                " Info detallada
:LspLog                 " Ver logs
:LspRestart             " Reiniciar LSP
```

## 📝 Archivos Modificados

1. `lua/config/lspconfig.lua` - Cambió a usar ruby-lsp global
2. `~/.config/ruby-lsp/config.json` - Config global (nuevo)
3. `~/workspaces/Pagerduty/web/.ruby-lsp/config.yml` - Config proyecto (nuevo)
4. `~/.zshrc` - Variables de entorno (nuevo)
5. `lua/config/ruby_check.lua` - Comandos diagnóstico

## ⚠️ Notas Importantes

- **ruby-lsp NO debe estar en el Gemfile** del proyecto
- Se instala globalmente: `gem install ruby-lsp`
- Usa la versión de Ruby del proyecto (3.2.5) via rbenv
- El formateo lo hace rubocop (que SÍ está en el Gemfile)

## 🐛 Si Sigue Sin Funcionar

1. Verifica variables de entorno:
   ```bash
   echo $RUBY_LSP_EXPERIMENTAL_FEATURES  # debe mostrar: 0
   ```

2. Verifica ruby-lsp en la versión correcta:
   ```bash
   cd ~/workspaces/Pagerduty/web
   ruby -v  # debe ser 3.2.5
   which ruby-lsp
   ruby-lsp --version
   ```

3. Revisa logs:
   ```vim
   :LspLog
   ```

4. Si ves "bundle install", limpia el cache:
   ```vim
   :RubyLspCleanCache
   ```
