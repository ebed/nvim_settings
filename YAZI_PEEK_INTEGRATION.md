# 🔗 Integración Yazi + Peek

## 📋 Resumen

**No se puede usar peek directamente en yazi** (peek requiere neovim), pero sí puedes crear un flujo de trabajo integrado:

```
Yazi (navegación + preview rápido con glow)
  ↓ [abrir archivo markdown]
Neovim (edición)
  ↓ [auto-abre]
Peek (preview en tiempo real)
```

## 🎯 Flujo de trabajo recomendado

### 1. **Explorar con Yazi**
```bash
# Abrir yazi en neovim
<leader>fy
```

**En yazi:**
- Navega con `j/k`
- Ves preview de markdown con **glow** en el panel derecho
- Encuentras el archivo que quieres editar
- Presionas `<Enter>` para abrirlo en neovim

### 2. **Editar con Neovim + Peek**
Al abrir el archivo markdown en neovim:
- ✅ **Peek se abre automáticamente** (`auto_load = true`)
- ✅ Ves el preview en tiempo real mientras editas
- ✅ Cambios aparecen instantáneamente en peek

### 3. **Cerrar y volver a Yazi**
```vim
:q        " Cerrar neovim (peek se cierra automáticamente)
```
Vuelves a yazi para seguir navegando.

## 📊 Comparación de herramientas

| Herramienta | Cuándo usar | Ventaja |
|-------------|-------------|---------|
| **Yazi + glow** | Navegación y exploración | Preview rápido de múltiples archivos |
| **Neovim + Peek** | Edición de markdown | Preview en tiempo real mientras escribes |
| **Markview** (in-buffer) | Lectura en neovim | No necesita ventana externa |

## ⚙️ Configuración aplicada

### Yazi (`~/.config/yazi/yazi.toml`)
```toml
[opener]
edit = [
  { run = 'nvim "$@"', block = true, desc = "Edit in Neovim" },
]

[open]
rules = [
  { mime = "text/*", use = "edit" },  # Archivos de texto se abren con nvim
]
```

### Peek (`lua/plugins/peek.lua`)
```lua
opts = {
  auto_load = true,  -- ✅ Auto-abrir en archivos markdown
  close_on_bdelete = true,  -- ✅ Auto-cerrar al cerrar buffer
  theme = "dark",
}
```

## 🎬 Casos de uso

### Caso 1: Explorar documentación de proyecto
```bash
1. <leader>fy              # Abrir yazi
2. Navegar hasta docs/     # Ver previews con glow
3. <Enter> en README.md    # Abre en nvim con peek
4. Editar y ver cambios    # Peek actualiza en tiempo real
5. :wq                     # Guardar y volver a yazi
```

### Caso 2: Editar múltiples archivos markdown
```bash
1. <leader>fy              # Abrir yazi
2. <Space> en varios .md   # Seleccionar múltiples archivos
3. <Enter>                 # Abrir todos en nvim (buffers)
4. <leader>mp              # Toggle peek según necesites
5. :bnext / :bprev         # Navegar entre buffers
```

### Caso 3: Preview rápido sin editar
```bash
1. <leader>fy              # Abrir yazi
2. Navegar con j/k         # Ver preview con glow (panel derecho)
3. q                       # Salir sin abrir en nvim
```

## 🔧 Personalización avanzada

### Opción 1: Auto-abrir peek solo desde yazi

Si quieres que peek se abra automáticamente **solo cuando abres archivos desde yazi**:

```lua
-- En lua/plugins/peek.lua
opts = {
  auto_load = false,  -- Cambiar a false
}
```

Luego crea un wrapper en yazi:

```bash
# ~/.config/yazi/scripts/nvim-with-peek.sh
#!/bin/bash
nvim "$@" -c "PeekOpen"
```

Y en `yazi.toml`:
```toml
[opener]
edit = [
  { run = '~/.config/yazi/scripts/nvim-with-peek.sh "$@"', block = true },
]
```

### Opción 2: Usar diferentes previewers según contexto

**En Yazi (navegación rápida):**
- Glow para preview ligero

**En Neovim (edición profunda):**
- Peek para preview interactivo
- Markview para renderizado in-buffer (ya lo tienes instalado)

## 🎨 Keymaps combinados

| Contexto | Keymap | Acción |
|----------|--------|--------|
| Neovim | `<leader>fy` | Abrir yazi |
| Yazi | `<Enter>` | Abrir archivo en nvim |
| Yazi | `q` | Cerrar yazi |
| Neovim (en .md) | `<leader>mp` | Toggle peek |
| Neovim (en .md) | Auto | Peek se abre al entrar |

## 💡 Tips

1. **Preview rápido**: Usa yazi para ver múltiples archivos markdown sin abrirlos
2. **Edición profunda**: Abre en neovim cuando necesites editar con peek
3. **Performance**: Glow en yazi es más ligero que abrir neovim cada vez
4. **Combinación**: Puedes tener yazi abierto en un terminal y nvim en otro

## 🐛 Troubleshooting

### Peek no se abre automáticamente desde yazi
```vim
" Verificar que auto_load está en true
:lua print(require("peek").config.auto_load)
" Debe mostrar: true
```

### Preview en yazi no muestra glow
```bash
# Verificar que glow está disponible
which glow

# Probar glow directamente
glow archivo.md

# Limpiar cache de yazi
yazi --clear-cache
```

### Peek y glow muestran cosas diferentes
- **Normal**: Glow y Peek pueden renderizar markdown ligeramente diferente
- **Glow**: Optimizado para terminal (80 columnas típicamente)
- **Peek**: Renderizado completo tipo navegador

---

## ✅ Resumen del setup

```
┌─────────────────────────────────────────┐
│  Flujo de trabajo integrado             │
├─────────────────────────────────────────┤
│                                         │
│  1. Yazi (<leader>fy)                   │
│     ├─ Preview: glow (rápido)           │
│     └─ Navegar: j/k                     │
│                                         │
│  2. Abrir en Neovim (<Enter>)           │
│     ├─ Peek: auto-abre                  │
│     ├─ Editar: tiempo real              │
│     └─ Preview: actualiza automático    │
│                                         │
│  3. Guardar y salir (:wq)               │
│     └─ Peek: auto-cierra                │
│                                         │
└─────────────────────────────────────────┘
```

**✅ Configurado y listo para usar**
