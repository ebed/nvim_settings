# Oil.nvim - Guía Completa de Uso

Oil.nvim es un file explorer que te permite **editar directorios como si fueran archivos de texto**.

## 🚀 Inicio Rápido

### Abrir Oil

```vim
-                 " Desde cualquier archivo: abrir directorio padre
:Oil              " Abrir directorio actual
:Oil ~/projects   " Abrir directorio específico
```

## 📖 Conceptos Básicos

### Lo Que Ves en Oil

```
📁 src/
📁 tests/
📄 README.md
📄 package.json
📄 tsconfig.json
```

**Cada línea es editable** - puedes renombrar, mover, o eliminar archivos editando el texto.

## 🎮 Navegación

| Tecla | Acción |
|-------|--------|
| `<Enter>` | Abrir archivo o entrar a carpeta |
| `-` | Subir un nivel (directorio padre) |
| `g?` | Ver ayuda con todos los comandos |
| `g.` | Toggle mostrar archivos ocultos (.dotfiles) |
| `gs` | Cambiar orden (nombre, fecha, tamaño) |
| `<C-r>` | Refrescar vista |

## ✏️ Editar Nombres de Archivos

### Renombrar UN archivo

```vim
# Estado inicial:
old_name.txt

# Proceso:
i                    " Entrar en modo insert
old_name.txt  →  new_name.txt   " Editar el nombre
<Esc>               " Salir de insert
:w                  " Guardar = aplicar el renombrado

# Resultado:
new_name.txt
```

### Renombrar MÚLTIPLES archivos

```vim
# Estado inicial:
component_old.tsx
utils_old.ts
service_old.ts

# Proceso:
:%s/old/new/g       " Reemplazar 'old' por 'new' en todas las líneas
:w                  " Aplicar cambios

# Resultado:
component_new.tsx
utils_new.ts
service_new.ts
```

## 📦 Crear Archivos y Carpetas

### Crear archivo nuevo

```vim
# En oil:
i                   " Modo insert
nuevo_archivo.txt   " Escribir nombre en nueva línea
<Esc>
:w                  " Crear el archivo
```

### Crear carpeta nueva

```vim
# En oil:
i                   " Modo insert
nueva_carpeta/      " Terminar con / para carpetas
<Esc>
:w                  " Crear la carpeta
```

### Crear estructura completa

```vim
# En oil (directorio vacío):
i
src/
src/components/
src/utils/
tests/
docs/
README.md
<Esc>
:w                  " Crear todo de una vez
```

## 🗑️ Eliminar Archivos

### Eliminar un archivo

```vim
dd                  " Eliminar línea (marca archivo para eliminación)
:w                  " Confirmar eliminación
```

**Nota**: Por defecto, los archivos van a la papelera (trash), no se eliminan permanentemente.

### Eliminar múltiples archivos

```vim
# Método 1: Visual
V                   " Visual line mode
jjj                 " Seleccionar múltiples líneas
d                   " Eliminar selección
:w                  " Confirmar

# Método 2: Patrón
:g/\.tmp$/d         " Eliminar todos los .tmp
:g/test_/d          " Eliminar todos los que empiecen con test_
:w                  " Confirmar
```

## 📋 Copiar/Duplicar Archivos

```vim
# Estado inicial:
original.txt

# Proceso:
yy                  " Copiar (yank) línea
p                   " Pegar debajo
i                   " Editar el nombre del duplicado
original.txt  →  copia.txt
<Esc>
:w                  " Crear la copia

# Resultado:
original.txt
copia.txt
```

## 🔀 Mover Archivos

### Mover a otra carpeta

```vim
# Estado inicial en ~/project/:
archivo.txt

# Proceso:
i                   " Modo insert
archivo.txt  →  carpeta/archivo.txt   " Agregar path de destino
<Esc>
:w                  " Mover el archivo

# Resultado:
carpeta/
  archivo.txt       " Archivo movido aquí
```

### Mover múltiples archivos

```vim
# Estado inicial:
test1.txt
test2.txt
test3.txt

# Proceso:
:%s/^/tests\//      " Agregar 'tests/' al inicio de cada línea
:w                  " Mover todos a carpeta tests/

# Resultado:
tests/test1.txt
tests/test2.txt
tests/test3.txt
```

## 🔍 Ver y Abrir Archivos

| Tecla | Acción |
|-------|--------|
| `<Enter>` | Abrir en buffer actual |
| `<C-v>` | Abrir en split vertical |
| `<C-x>` | Abrir en split horizontal |
| `<C-t>` | Abrir en nuevo tab |
| `<C-p>` | Preview (ver sin abrir) |
| `gx` | Abrir con programa externo |

## 🎯 Workflows Avanzados

### Workflow 1: Renombrado masivo con patrón

```vim
# Renombrar:
# photo1.jpg, photo2.jpg, photo3.jpg
# A:
# vacation_1.jpg, vacation_2.jpg, vacation_3.jpg

:%s/photo/vacation_/g
:w
```

### Workflow 2: Limpiar archivos temporales

```vim
# Eliminar todos los archivos temporales y backups
:g/\.tmp$/d         " Eliminar .tmp
:g/~$/d             " Eliminar backups ~
:g/\.swp$/d         " Eliminar .swp
:w                  " Aplicar todo
```

### Workflow 3: Reorganizar por fecha

```vim
gs                  " Cambiar sort a 'fecha modificación'
                    " Ahora ves archivos más recientes primero
```

### Workflow 4: Mostrar solo ciertos archivos

```vim
g.                  " Toggle hidden files
:g!/\.ts$/d         " Mantener SOLO archivos .ts (eliminar otros de vista)
                    " (no los elimina del disco, solo de la vista)
```

## 🛠️ Comandos Especiales

### Toggle trash (eliminar permanentemente)

```vim
g\                  " Toggle trash
                    " Si está OFF: archivos se eliminan permanentemente
                    " Si está ON (default): archivos van a papelera
```

### Cambiar directorio de trabajo

```vim
`                   " (backtick) cd al directorio mostrado en oil
~                   " (tilde) tcd (tab-local cd) al directorio
```

## ⚠️ Cosas Importantes

### Deshacer Cambios

**ANTES de guardar**:
```vim
u                   " Deshacer cambios en buffer
<C-c>               " Cerrar sin guardar
```

**DESPUÉS de guardar** (:w):
- Oil aplica cambios al filesystem
- Necesitas deshacer manualmente o usar git

### Confirmación

Oil pide confirmación para:
- ✅ Eliminar múltiples archivos
- ✅ Sobrescribir archivos existentes
- ✅ Operaciones destructivas

### Preview Antes de Guardar

```vim
" Después de hacer cambios pero ANTES de :w
:w !diff            " Ver qué cambios se aplicarán (no funciona siempre)
:messages           " Ver warnings/errores
```

## 🎓 Ejercicio Práctico

### Crea esta estructura en 30 segundos:

```
proyecto/
  src/
    components/
    utils/
  tests/
  README.md
  package.json
```

**Solución**:
```vim
:Oil ~/proyecto     " Crear carpeta proyecto
i
src/
src/components/
src/utils/
tests/
README.md
package.json
<Esc>
:w
```

## 💡 Tips Pro

1. **Usa macros** para operaciones repetitivas:
   ```vim
   qa              " Grabar macro en registro 'a'
   I../            " Agregar '../' al inicio
   <Esc>j          " Bajar a siguiente línea
   q               " Terminar grabación
   10@a            " Aplicar a 10 archivos
   :w              " Guardar cambios
   ```

2. **Combina con comandos externos**:
   ```vim
   :%!sort         " Ordenar alfabéticamente
   :w
   ```

3. **Usa visual block** para ediciones complejas:
   ```vim
   <C-v>           " Visual block
   jjj             " Seleccionar columna
   I               " Insert al inicio de cada línea
   prefix_         " Agregar prefijo
   <Esc>
   :w
   ```

## 🔗 Integración con Tu Workflow

### Con Git

```vim
-                   " Abrir oil
:g/\.swp$/d         " Limpiar archivos temporales
:w
:!git add .         " Desde oil, ejecutar git
```

### Con Búsqueda

```vim
<leader>e           " Abrir snacks.explorer (sidebar)
-                   " Cambiar a oil para operaciones masivas
                    " Editar, renombrar, reorganizar
:w                  " Aplicar
<C-c>               " Cerrar oil
<leader>e           " Ver resultado en explorer
```

## 📚 Resumen de Keymaps

### Navegación
- `<Enter>` - Abrir archivo/entrar carpeta
- `-` - Directorio padre
- `g?` - Help

### Edición
- `i` - Insert mode (editar nombres)
- `dd` - Eliminar archivo
- `yy` + `p` - Copiar archivo
- `:w` - **Aplicar todos los cambios**

### Vista
- `g.` - Toggle hidden files
- `gs` - Change sort order
- `<C-r>` - Refresh
- `<C-p>` - Preview

### Abrir
- `<C-v>` - Split vertical
- `<C-x>` - Split horizontal
- `<C-t>` - New tab

## 🆘 Cuando Algo Sale Mal

**"Cometí un error antes de :w"**:
```vim
u               " Deshacer cambios
<C-c>           " Cerrar sin guardar
```

**"Ya guardé y rompí algo"**:
```vim
# Usa git para revertir:
:!git restore .
# O usa tu sistema de backups
```

**"Oil no responde"**:
```vim
<C-c>           " Forzar cierre
:Oil            " Reabrir
```

---

**Recuerda**: Oil trata el directorio como un **buffer de texto normal**.
Todos tus skills de vim aplican: macros, sustituciones, visual mode, etc.

**El poder está en combinar vim + filesystem operations.**
