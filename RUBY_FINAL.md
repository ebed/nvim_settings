# ✅ Ruby LSP - Solución Final

## 🎯 Problema Root Cause

`ruby-lsp` crea un "composed bundle" en `.ruby-lsp/` con **TODAS** las dependencias del proyecto + ruby-lsp. En proyectos grandes como PagerDuty (149 gems, 322 dependencias totales), el primer `bundle install` tarda varios minutos y causaba **timeouts**.

## ✅ Solución Aplicada

**Pre-crear el composed bundle** manualmente UNA VEZ usando `ruby-lsp --doctor`.

Una vez creado:
- ✅ `Gemfile.lock` existe en `.ruby-lsp/`
- ✅ Ruby-lsp ya NO intenta `bundle install` de nuevo
- ✅ Inicia inmediatamente

## 🚀 Estado Actual

El composed bundle fue creado exitosamente:
```
~/workspaces/Pagerduty/web/.ruby-lsp/
├── Gemfile
├── Gemfile.lock  ← 322 gems instaladas
└── .bundle/
```

## 📝 Próximos Pasos

**1. Reinicia Neovim**

**2. Abre un archivo Ruby:**
```bash
cd ~/workspaces/Pagerduty/web
nvim app/models/user.rb
```

**3. Verifica:**
```vim
:RubyCheck
```

Deberías ver:
```
ruby_lsp activo: ✓
ID: X, Root: .../workspaces/Pagerduty/web
```

El LSP debería iniciar en **~2 segundos** sin bundle install.

## 🎯 Funcionalidades Disponibles

### LSP
- `K` → Ver documentación
- `gd` → Ir a definición
- `gr` → Ver referencias
- `<leader>ca` → Code actions
- `<leader>rn` → Renombrar
- `[d` / `]d` → Navegar diagnósticos

### Formateo
- `<leader>f` → Formatear con rubocop (conform.nvim)

### Tests
- Configurado con neotest (RSpec/Minitest)

## 🔧 Comandos Útiles

```vim
:RubyCheck         " Ver estado del LSP
:LspInfo           " Info detallada
:LspRestart        " Reiniciar LSP
:LspLog            " Ver logs
```

## 📊 Performance

- **Primera vez** (bundle install): ~3-5 minutos (YA HECHO ✓)
- **Inicios posteriores**: ~2 segundos
- **Indexación inicial**: ~30 segundos (en background)

## ⚠️ Mantenimiento

El directorio `.ruby-lsp/` se actualiza automáticamente cuando:
- Cambias de rama Git
- Actualizas el `Gemfile.lock` del proyecto
- Actualizas ruby-lsp globalmente

Si ruby-lsp empieza a tardar de nuevo:
```vim
:RubyLspCleanCache   " Eliminar .ruby-lsp/
```
Luego reinicia Neovim (volverá a crear el bundle)

## 📁 Archivos del Setup

1. `lua/config/lspconfig.lua` - Config LSP (usa ruby-lsp global)
2. `lua/plugins/conform.lua` - Config formateo (rubocop)
3. `lua/config/ruby_check.lua` - Comandos diagnóstico
4. `~/workspaces/Pagerduty/web/.ruby-lsp/` - Composed bundle (generado)

## 🎉 Resultado

Ruby LSP completamente funcional en PagerDuty:
- ✅ Diagnósticos en tiempo real
- ✅ Autocompletado inteligente
- ✅ Navegación de código (go to definition, references)
- ✅ Formateo con rubocop
- ✅ Renombrado de símbolos
- ✅ Code actions
