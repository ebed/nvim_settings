# Guía de Instalación y Uso de Yazi

## 🎯 Resumen
Yazi es un file manager de terminal moderno con:
- Previsualización de múltiples tipos de archivos (markdown, código, imágenes, PDFs, etc.)
- Interfaz rápida y visual tipo vim
- Soporte para imágenes usando kitty graphics protocol
- Integración con neovim

## 📦 Instalación

### macOS (Homebrew)
```bash
brew install yazi
```

### Previsualizadores instalados ✅

Tu configuración actual incluye:

```bash
✅ glow         # Markdown renderizado con colores y formato
✅ bat          # Syntax highlighting para código
✅ poppler      # Preview de PDFs como imágenes
✅ imagemagick  # Procesamiento de imágenes (si está instalado)
```

### Opcional: Instaladores adicionales

```bash
# Para videos (thumbnails)
brew install ffmpegthumbnailer

# Para archivos JSON mejorados
brew install jq

# Para archivos de Office (docx, xlsx)
brew install pandoc
```

## ⚙️ Configuración

### 1. WezTerm - ✅ Ya configurado
El soporte para kitty graphics protocol ya está habilitado en tu configuración de wezterm.

### 2. Neovim - ✅ Ya configurado
El plugin `yazi.nvim` ya está instalado en `lua/plugins/yazi.lua`.

## 🚀 Uso

### Keymaps en Neovim

| Keymap | Descripción |
|--------|-------------|
| `<leader>fy` | Abrir yazi en el directorio del archivo actual |
| `<leader>fY` | Abrir yazi en el directorio de trabajo (cwd) |
| `<leader>yr` | Reabrir última sesión de yazi |

### Navegación dentro de Yazi

#### Básicos
- `j/k` - Mover arriba/abajo
- `h/l` - Ir al directorio padre / entrar a directorio
- `<Enter>` - Abrir archivo en neovim
- `q` o `<Esc>` - Cerrar yazi

#### Splits y tabs (al abrir archivo)
- `<C-v>` - Abrir en split vertical
- `<C-x>` - Abrir en split horizontal
- `<C-t>` - Abrir en nueva tab

#### Previsualización
- La previsualización aparece automáticamente en el panel derecho
- Para markdown: verás el contenido parseado con colores
- Para imágenes: se mostrarán directamente en el terminal (gracias a kitty protocol)

#### Búsqueda y filtrado
- `/` - Buscar archivos
- `f` - Filtrar archivos (fuzzy find)
- `<C-s>` - Buscar contenido con Telescope (integración)

#### Operaciones de archivos
- `y` - Copiar (yank)
- `x` - Cortar
- `p` - Pegar
- `d` - Eliminar (con confirmación)
- `r` - Renombrar
- `a` - Crear archivo
- `A` - Crear directorio
- `.` - Toggle archivos ocultos

#### Selección múltiple
- `<Space>` - Seleccionar archivo actual
- `v` - Modo visual (seleccionar múltiples)
- `V` - Seleccionar todos

#### Otras funciones útiles
- `z` - Saltar a directorio frecuente (zoxide integration si está instalado)
- `<Tab>` - Alternar entre buffers abiertos
- `<C-y>` - Copiar ruta relativa al clipboard
- `<F1>` - Mostrar ayuda completa

## 📝 Preview Mejorado de Markdown con Glow

**Yazi ahora usa `glow` automáticamente** para renderizar markdown de forma hermosa.

### ¿Qué verás en el preview?

Cuando te posiciones sobre un archivo `.md`:

**✅ CON GLOW (configurado):**
- 🎨 Encabezados con colores y estilos
- **Texto en negrita** y *cursiva* formateado
- `Código inline` resaltado
- Bloques de código con syntax highlighting completo
- Tablas renderizadas y alineadas
- Listas con viñetas visuales
- Enlaces destacados en color
- Citas con formato especial

**❌ SIN GLOW (preview básico):**
- Texto plano con símbolos markdown crudos
- `# Título` en lugar de títulos formateados
- Sin colores ni formato

### 🧪 Prueba ahora

```bash
# Abre yazi en /tmp con el archivo de demo
yazi /tmp

# Navega con j/k hasta test-yazi-markdown.md
# Verás el preview renderizado en el panel derecho
```

### Configuración de glow

Glow usa tu terminal theme automáticamente. Si quieres personalizarlo:

```bash
# Ver estilos disponibles
glow -s [dark|light|notty|auto]

# Ejemplo: forzar tema oscuro
glow -s dark archivo.md
```

## 🔄 Comparación: Oil vs Yazi

### Oil (mantén para ediciones rápidas)
- **Ventaja**: Editar directorios como si fueran archivos de texto
- **Usa para**: Renombrar múltiples archivos, reorganizar directorios
- **Keymap**: `-` (ya configurado)

### Yazi (usa para exploración y preview)
- **Ventaja**: Previsualización rica, navegación rápida, imágenes
- **Usa para**: Explorar proyectos, ver archivos antes de abrir, trabajar con imágenes
- **Keymap**: `<leader>fy`

## 🎨 Personalización de Yazi

**✅ Ya configurado** en `~/.config/yazi/yazi.toml`:

```toml
[manager]
sort_by = "modified"          # Ordenar por fecha modificación
sort_reverse = true           # Más reciente primero
show_hidden = false           # Ocultar archivos . por defecto
sort_dir_first = true         # Directorios primero

[preview]
tab_size = 2                  # Tamaño de tabs en preview
max_width = 1000              # Ancho máximo del preview
max_height = 1000             # Alto máximo del preview
```

**Previsualizadores detectados automáticamente:**
- `glow` → Markdown renderizado
- `bat` → Syntax highlighting para código
- `pdftoppm` → PDFs como imágenes
- `imagemagick` → Procesamiento de imágenes

Para más opciones: https://yazi-rs.github.io/docs/configuration/yazi

## 🐛 Troubleshooting

### Las imágenes no se muestran
1. Verifica que wezterm tiene kitty graphics habilitado (ya lo está)
2. Reinicia wezterm después de cambiar la configuración
3. Verifica que yazi detecta el protocolo: `yazi --debug`

### Previsualización de markdown muy básica
- ✅ **glow ya está instalado y configurado**
- Yazi lo detecta automáticamente
- **Prueba ahora**: `yazi /tmp` y navega a `test-yazi-markdown.md`

### Lentitud en directorios grandes
- Yazi es generalmente rápido, pero puedes deshabilitar preview temporalmente con `P`

## 📚 Recursos
- Documentación oficial: https://yazi-rs.github.io
- GitHub: https://github.com/sxyazi/yazi
- Plugin yazi.nvim: https://github.com/mikavilpas/yazi.nvim

## 🔗 Integración con otros plugins

### Peek.nvim - Preview de markdown en neovim
Para previsualizar markdown **dentro de neovim** con peek:
- Keymap: `<leader>mp`
- Documentación: `PEEK_MARKDOWN.md`
- Preview en tiempo real con Deno

---

**Setup completo** ✅
- Yazi: Exploración de archivos con preview
- Peek: Preview de markdown en neovim
- Oil: Editor de directorios
