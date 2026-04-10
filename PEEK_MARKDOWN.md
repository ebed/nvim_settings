# 📖 Peek.nvim - Previsualizador de Markdown

## 🎯 ¿Qué es Peek?

Peek es un previsualizador de markdown moderno y ligero que:
- ✅ Usa **Deno** (más rápido que Node.js)
- ✅ Preview en **tiempo real** mientras escribes
- ✅ Soporte para **webview nativa** o navegador
- ✅ Syntax highlighting en bloques de código
- ✅ Soporta **imágenes**, tablas, LaTeX, Mermaid diagrams
- ✅ Tema oscuro/claro configurable

## ⌨️ Keymaps

| Keymap | Comando | Descripción |
|--------|---------|-------------|
| `<leader>mp` | `:PeekToggle` | Abrir/cerrar preview |
| - | `:PeekOpen` | Abrir preview |
| - | `:PeekClose` | Cerrar preview |

## 🚀 Uso

### 1. Abrir preview
```vim
" En cualquier archivo .md
<leader>mp
" o
:PeekOpen
```

### 2. Mientras escribes
- El preview se actualiza **automáticamente en tiempo real**
- Los cambios aparecen instantáneamente en la ventana de preview
- No necesitas guardar el archivo

### 3. Cerrar preview
```vim
<leader>mp
" o
:PeekClose
```

## 🎨 Características

### Soportado:
- ✅ Markdown estándar (CommonMark)
- ✅ GitHub Flavored Markdown (GFM)
- ✅ Tablas
- ✅ Listas de tareas: `- [ ] tarea`
- ✅ Syntax highlighting en code blocks
- ✅ Imágenes (locales y URLs)
- ✅ LaTeX/KaTeX para fórmulas matemáticas
- ✅ Mermaid diagrams
- ✅ Emojis: `:smile:` → 😊
- ✅ HTML embebido

### Ejemplo de código con syntax highlighting:

```markdown
## Código JavaScript
\`\`\`javascript
function saludar(nombre) {
  console.log(`¡Hola, ${nombre}!`);
}
\`\`\`

## Código Python
\`\`\`python
def fibonacci(n):
    return n if n <= 1 else fibonacci(n-1) + fibonacci(n-2)
\`\`\`
```

### Ejemplo de fórmulas LaTeX:

```markdown
Ecuación inline: $E = mc^2$

Ecuación en bloque:
$$
\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}
$$
```

### Ejemplo de Mermaid diagram:

```markdown
\`\`\`mermaid
graph TD
    A[Start] --> B{Decision}
    B -->|Yes| C[Do Something]
    B -->|No| D[Do Something Else]
    C --> E[End]
    D --> E
\`\`\`
```

## ⚙️ Configuración

La configuración está en `lua/plugins/peek.lua`:

```lua
opts = {
  auto_load = true,           -- Auto abrir en archivos markdown
  theme = "dark",             -- Tema: 'dark' o 'light'
  update_on_change = true,    -- Actualización en tiempo real
  app = "webview",            -- 'webview' o 'browser'
}
```

### Cambiar a navegador por defecto:

Edita `lua/plugins/peek.lua` y cambia:

```lua
app = "browser",  -- Usar navegador por defecto
-- o especifica uno:
app = "/Applications/Firefox.app/Contents/MacOS/firefox",
```

## 🔄 Comparación con otros previewers

| Característica | Peek.nvim | markdown-preview.nvim | markview.nvim |
|----------------|-----------|----------------------|---------------|
| Tiempo real | ✅ Muy rápido | ✅ Rápido | ✅ In-buffer |
| Tecnología | Deno | Node.js | Lua pura |
| Preview externo | ✅ | ✅ | ❌ (in-buffer) |
| LaTeX | ✅ | ✅ | ⚠️ Limitado |
| Mermaid | ✅ | ✅ | ⚠️ |
| Ligero | ✅✅ | ⚠️ | ✅ |
| Dependencias | Solo Deno | Node + npm | Ninguna |

## 🐛 Troubleshooting

### Error: `__VERSION__ is not defined`
**✅ SOLUCIONADO** - La configuración incluye un fix automático para este bug conocido de peek.nvim.

Si el error persiste:
```bash
# Fix manual (reemplazo específico)
cd ~/.local/share/nvim/lazy/peek.nvim
sed -i '' 's/Ln1 = __VERSION__/Ln1 = "dev"/g' public/main.bundle.js

# O reinstalar el plugin
# En neovim:
:Lazy clean peek.nvim
:Lazy sync
```

### Preview no abre
```bash
# Verificar que deno está instalado
deno --version

# Si no está, instalar:
brew install deno
```

### Preview no se actualiza
- Verifica que `update_on_change = true` en la config
- Reinicia neovim: `:Lazy reload peek.nvim`

### Puerto en uso
Peek asigna puertos automáticamente. Si hay conflicto, puedes especificar uno:

```lua
opts = {
  port = 8888,  -- Puerto específico
}
```

### Problemas con imágenes
- Las rutas relativas deben ser relativas al archivo markdown
- Las URLs funcionan directamente
- Formatos soportados: PNG, JPG, GIF, WebP, SVG

## 📚 Recursos

- GitHub: https://github.com/toppair/peek.nvim
- Deno: https://deno.land

## 💡 Tips

1. **Auto-abrir en markdown**: Ya está configurado con `auto_load = true`
2. **Cambiar tema**: Modifica `theme = "light"` en la config
3. **Split side-by-side**: Abre nvim en split vertical y peek en otro monitor
4. **Live coding demos**: Perfecto para presentaciones en vivo

---

**Instalado y configurado** ✅
- Plugin: `lua/plugins/peek.lua`
- Keymap principal: `<leader>mp`
- markdown-preview.nvim deshabilitado (backup disponible)
