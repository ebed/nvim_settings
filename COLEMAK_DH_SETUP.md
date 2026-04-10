# 🎮 Colemak-DH Setup - Cambios Implementados

**Fecha:** 2026-04-07
**Estado:** ✅ Implementado

---

## 📝 Resumen de Cambios

Se integraron keybindings Colemak-DH y plugins faltantes a tu configuración existente de Neovim.

---

## ✅ Archivos Modificados

### 1. `lua/config/mappings/general.lua`
**Cambio:** Movido Emacs-style de `<C-A/E>` a `<M-a/e>`

**Antes:**
```lua
<C-A>  → Go to Home (inicio de línea)
<C-E>  → Go to End (fin de línea)
```

**Ahora:**
```lua
<M-a>  → Go to Home (Alt+a)
<M-e>  → Go to End (Alt+e)
```

**Razón:** Liberar `<C-E>` para navegación Colemak-DH (ventana arriba)

---

### 2. `lua/config/mappings/init.lua`
**Cambio:** Agregadas 2 líneas para cargar nuevos keymaps

```lua
require("config.mappings.navigation_colemak") -- NUEVO
require("config.mappings.harpoon")           -- NUEVO
```

---

## ✨ Archivos Nuevos Creados

### 1. `lua/config/mappings/navigation_colemak.lua` ⭐

**Navegación entre ventanas (posiciones físicas de hjkl en Colemak-DH):**

```
<C-m>  ← Ventana izquierda
<C-n>  ↓ Ventana abajo
<C-e>  ↑ Ventana arriba
<C-i>  → Ventana derecha
```

**Mover ventanas:**
```
<C-M>  Mover ventana izquierda (Shift+Ctrl+m)
<C-N>  Mover ventana abajo
<C-E>  Mover ventana arriba
<C-I>  Mover ventana derecha
```

**Resize ventanas:**
```
<M-m>  Reducir ancho (Alt+m)
<M-i>  Aumentar ancho (Alt+i)
<M-n>  Aumentar alto (Alt+n)
<M-u>  Reducir alto (Alt+u)
```

**Terminal mode:**
```
<C-m/n/e/i>  Navegar desde terminal
<Esc><Esc>   Salir de modo terminal
```

---

### 2. `lua/config/mappings/harpoon.lua` ⭐

**Marcar archivos:**
```
<leader>ha   Agregar archivo actual a Harpoon
<leader>hm   Toggle Harpoon menu
```

**Navegación rápida:**
```
<leader>1    Saltar a archivo marcado #1
<leader>2    Saltar a archivo marcado #2
<leader>3    Saltar a archivo marcado #3
<leader>4    Saltar a archivo marcado #4
```

**Ciclar entre marcados:**
```
<leader>hn   Siguiente archivo marcado
<leader>hp   Archivo marcado anterior
```

---

### 3. `lua/plugins/workflow_extras.lua` ⭐

**Plugins agregados:**

#### Which-Key
- Ayuda visual de keybindings
- Presiona `<leader>` y espera → muestra opciones
- Grupos organizados: buffer, find, git, harpoon, etc.

#### Persistence (Sessions)
```
<leader>ss   Guardar sesión
<leader>sl   Cargar última sesión
<leader>sr   Restaurar sesión del directorio actual
<leader>sd   Desactivar auto-save de sesión
```

---

## 🎯 Workflow Recomendado

### 1. Trabajar en Proyecto

```vim
" Abrir Neovim en directorio del proyecto
cd ~/projects/mi-proyecto
nvim

" Marcar 4 archivos importantes con Harpoon
<leader>ha   " en archivo principal
<leader>ha   " en archivo de tests
<leader>ha   " en archivo de config
<leader>ha   " en archivo de docs

" Navegar rápido entre ellos
<leader>1    " → archivo principal
<leader>2    " → tests
<leader>3    " → config
<leader>4    " → docs
```

### 2. Splits y Navegación

```vim
" Crear layout de trabajo
<leader>sv   " Split vertical (código + terminal)
<leader>sh   " Split horizontal

" Navegar con Colemak-DH
<C-m>  " ← izquierda
<C-i>  " → derecha
<C-n>  " ↓ abajo
<C-e>  " ↑ arriba

" Resize si es necesario
<M-m>  " Reducir ancho
<M-i>  " Aumentar ancho
```

### 3. Terminal Integrado

```vim
" Abrir terminal (desde Snacks)
<c-/>        " Terminal flotante

" O usar toggleterm
<c-\>        " Terminal flotante (toggleterm)

" Navegar desde terminal
<C-m/n/e/i>  " Cambiar a otras ventanas
<Esc><Esc>   " Salir de modo terminal
```

### 4. Sessions (Persistencia)

```vim
" Al final del día
<leader>ss   " Guardar sesión

" Al día siguiente
nvim         " Abrir Neovim
<leader>sl   " Cargar última sesión
             " → Todo como lo dejaste!
```

---

## 🔑 Cheatsheet Rápido

### Navegación Colemak-DH

| Key | Action | Mnemonic |
|-----|--------|----------|
| `<C-m>` | ← Left | **M**ove left |
| `<C-n>` | ↓ Down | **N**ext down |
| `<C-e>` | ↑ Up | **E**levate up |
| `<C-i>` | → Right | **I**nward right |

### Harpoon

| Key | Action |
|-----|--------|
| `<leader>ha` | Add file |
| `<leader>hm` | Menu |
| `<leader>1-4` | Jump to file |

### Sessions

| Key | Action |
|-----|--------|
| `<leader>ss` | Save |
| `<leader>sl` | Load last |
| `<leader>sr` | Restore for cwd |

### Which-Key

| Key | Action |
|-----|--------|
| `<leader>` + wait | Show all options |
| `<leader>f` + wait | Show find options |
| `<leader>h` + wait | Show harpoon options |

---

## 🧪 Probar la Instalación

### 1. Restart Neovim

```bash
# Cierra Neovim si está abierto
:qa

# Abre de nuevo
nvim
```

### 2. Instalar Plugins Nuevos

```vim
:Lazy sync
```

Espera a que se instalen `which-key` y `persistence`.

### 3. Probar Navegación Colemak-DH

```vim
" Crear splits
:vsplit
:split

" Navegar con Colemak-DH
<C-m>  " ¿Va a la izquierda? ✅
<C-n>  " ¿Va abajo? ✅
<C-e>  " ¿Va arriba? ✅
<C-i>  " ¿Va a la derecha? ✅
```

### 4. Probar Harpoon

```vim
" Abrir varios archivos
:e file1.txt
<leader>ha   " Marcar

:e file2.txt
<leader>ha   " Marcar

" Saltar
<leader>1    " ¿Salta a file1.txt? ✅
<leader>2    " ¿Salta a file2.txt? ✅

" Ver menu
<leader>hm   " ¿Muestra lista? ✅
```

### 5. Probar Which-Key

```vim
<leader>     " Presiona y espera 1 segundo
             " ¿Aparece menu con opciones? ✅
```

### 6. Probar Sessions

```vim
" Abre varios archivos y splits
:e file1.txt
:vsplit file2.txt

" Guarda
<leader>ss   " ¿Muestra notificación? ✅

" Cierra todo
:qa

" Vuelve a abrir y restaura
nvim
<leader>sl   " ¿Restaura todo? ✅
```

---

## 🐛 Troubleshooting

### Problema: Navegación Colemak-DH no funciona

**Síntoma:** `<C-e>` no va a ventana arriba

**Solución:**
```vim
" Verifica que el mapping está cargado
:nmap <C-e>

" Debería mostrar: <C-e>   * <Cmd>lua require("which_key")...
" Si no aparece, verifica que init.lua carga navigation_colemak
```

**Check:**
```bash
grep "navigation_colemak" ~/.config/nvim/lua/config/mappings/init.lua
```

---

### Problema: Harpoon no funciona

**Síntoma:** Error al usar `<leader>ha`

**Solución:**
```vim
" Verifica que harpoon está instalado
:Lazy

" Busca "harpoon" en la lista
" Si no está, instala:
:Lazy sync
```

---

### Problema: Which-key no aparece

**Síntoma:** Presiono `<leader>` y no pasa nada

**Solución:**
```vim
" Verifica instalación
:Lazy

" Si está instalado, verifica timeout
:set timeoutlen?

" Debería ser >= 500ms
" Si no, agrega a tu config:
:set timeoutlen=500
```

---

### Problema: Sessions no guardan

**Síntoma:** `<leader>ss` no guarda la sesión

**Solución:**
```bash
# Verifica que el directorio existe
ls ~/.local/state/nvim/sessions/

# Si no existe, créalo
mkdir -p ~/.local/state/nvim/sessions/
```

---

## 🔄 Rollback (Si algo falla)

### Restaurar Backup

```bash
# Ver backups disponibles
ls ~/.config/*nvim-backup*.tar.gz

# Restaurar
cd ~/.config
rm -rf nvim
tar -xzf nvim-backup-20260407-111615.tar.gz
```

---

## 📚 Referencias

- **Colemak-DH Layout:** https://colemakmods.github.io/mod-dh/
- **Harpoon:** https://github.com/ThePrimeagen/harpoon
- **Which-Key:** https://github.com/folke/which-key.nvim
- **Persistence:** https://github.com/folke/persistence.nvim

---

## 💡 Tips Pro

### 1. Combinar con WezTerm

```
WezTerm tab 1: Backend
  └─ Neovim con Harpoon marks del backend

WezTerm tab 2: Frontend
  └─ Neovim con Harpoon marks del frontend

WezTerm tab 3: DevOps
  └─ Neovim con configs
```

### 2. Workflow de Harpoon

**Marca los 4 archivos que más editas:**
- Main source file
- Test file
- Config file
- README/docs

Luego salta entre ellos con `<leader>1-4`.

### 3. Sessions por Proyecto

```bash
# Proyecto 1
cd ~/projects/backend
nvim
# Trabaja...
<leader>ss  # Guarda sesión

# Proyecto 2
cd ~/projects/frontend
nvim
# Trabaja...
<leader>ss  # Guarda sesión

# Volver a proyecto 1
cd ~/projects/backend
nvim
<leader>sr  # Restaura sesión del backend
```

---

## ✨ Siguientes Pasos

1. ✅ Configuración instalada
2. 🧪 Prueba cada feature
3. 📖 Lee `WEZTERM_NEOVIM_SETUP.md` para workflow completo
4. 🎯 Practica keybindings Colemak-DH hasta que sean músculo memoria
5. 💪 Disfruta del productivity boost!

---

**¡Todo listo!** Tu Neovim ahora está optimizado para Colemak-DH + WezTerm workflow.

Presiona `<leader>` en Neovim para ver todas las opciones disponibles.
