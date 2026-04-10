# Solución Pragmática: Ruby LSP en PagerDuty

## 🎯 El Problema

Ruby-lsp crea un "composed bundle" que hace `bundle install` con TODAS las dependencias del proyecto PagerDuty (322 gems). Esto:
- Tarda 3-5 minutos la primera vez
- Falla frecuentemente con timeouts en el repo interno
- Usa la versión incorrecta de Ruby (3.2.8 en vez de 3.2.5)

## ✅ Solución Implementada

**Desactivar completamente el composed bundle** usando `.ruby-lsp.yml`:

```yaml
bundleGemfile: ""
```

Ahora ruby-lsp:
- NO crea directorio `.ruby-lsp/`
- NO hace `bundle install`
- Usa el bundle del proyecto directamente
- Inicia en ~2 segundos

## ⚠️ Limitación Conocida

Ruby-lsp NO está en el Gemfile de PagerDuty, entonces usa la versión global instalada con:
```bash
gem install ruby-lsp
```

Esto significa que ruby-lsp puede no tener acceso a TODAS las gems del proyecto, pero **las funciones principales funcionan**:
- ✅ Syntax highlighting
- ✅ Go to definition (para stdlib y código propio)
- ✅ Hover documentation (limitado)
- ✅ Diagnostics básicos
- ⚠️ Go to definition (gems del proyecto): LIMITADO
- ⚠️ Full Rails integration: LIMITADO

## 🎯 Qué Funciona PERFECTAMENTE

### Formateo con Rubocop
```vim
<leader>f  " Formatear con rubocop via conform.nvim
```

**ESTO ES LO MÁS IMPORTANTE** y funciona al 100% porque rubocop está en el Gemfile.

### Navegación de Código
- `gd` - Go to definition (tu código)
- `gr` - Referencias
- `K` - Hover

### Diagnostics
- `[d` / `]d` - Navegar errores
- Syntax errors en tiempo real

## 🚀 Uso Recomendado

**Para desarrollo en PagerDuty:**

1. **Formateo**: Usa `<leader>f` (rubocop) - PERFECTO
2. **Go to definition**: Usa `gd` para tu código - FUNCIONA
3. **Buscar en gems**: Usa `telescope` o `grep` - MÁS CONFIABLE
4. **Rails console**: Para explorar gems del proyecto

## 📝 Alternativa: Agregar ruby-lsp al Gemfile

Si quieres FULL funcionalidad de LSP, agrega a `Gemfile`:

```ruby
group :development do
  gem 'ruby-lsp', require: false
  gem 'ruby-lsp-rails', require: false
end
```

Luego:
```bash
bundle install
```

Y comenta la línea `bundleGemfile: ""` en `.ruby-lsp.yml`.

**NOTA**: Esto volverá a crear el composed bundle, pero al menos estará en el Gemfile.

## ✅ Estado Actual

- ✅ Formateo con rubocop: PERFECTO
- ✅ Syntax highlighting: FUNCIONA
- ✅ Diagnostics básicos: FUNCIONA
- ✅ Go to definition (tu código): FUNCIONA
- ⚠️ Rails autocomplete: LIMITADO
- ⚠️ Gem navigation: LIMITADO

## 🎯 Recomendación

**MANTÉN ESTA CONFIGURACIÓN**. El formateo con rubocop (que es lo más importante) funciona perfectamente. Para funcionalidad completa de LSP, considera agregar ruby-lsp al Gemfile en el futuro.

## 📋 Archivos de Configuración

- `~/workspaces/Pagerduty/web/.ruby-lsp.yml` - Desactiva composed bundle
- `lua/config/lspconfig.lua` - Config simplificada de ruby_lsp
- `lua/plugins/conform.lua` - Config de rubocop (PERFECTO)
