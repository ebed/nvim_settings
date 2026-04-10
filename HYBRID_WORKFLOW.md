# 🎯 Hybrid Workflow - Quick Reference

**Fecha:** 2026-04-07
**Setup:** Dashboard + Quick Layouts + Sessions

---

## 🚀 Filosofía

**Inicio limpio, layouts bajo demanda**

```
nvim → Dashboard (vacío, rápido)
     → Presionas <leader>l + tecla → Layout instantáneo
     → Al final <leader>ss → Guarda sesión
```

---

## ⌨️ Keybindings de Layouts

### Quick Layouts (Un hotkey → Layout completo)

| Keymap | Layout | Uso |
|--------|--------|-----|
| `<leader>ld` | **Dev** | Explorer + código (desarrollo normal) |
| `<leader>lc` | **Clean** | Solo código (focus máximo) |
| `<leader>lf` | **Full** | Explorer + código + terminal en CWD (desarrollo completo) |
| `<leader>lr` | **Review** | Explorer + código (para revisar código) |

### Terminales Contextuales (Agregan terminal sin resetear layout)

| Keymap | Ubicación | Uso |
|--------|-----------|-----|
| `<C-/>` | **CWD (raíz)** | Terminal flotante (aparece/desaparece) |
| `<leader>T` | **Dir. archivo** | Terminal split en directorio del archivo actual |

### Descripción de cada Layout

#### 1. Dev Layout (`<leader>ld`)
```
┌─────────────────┬─────────────────────┐
│                 │                     │
│    Explorer     │    Tu Código        │
│   (archivos)    │                     │
│                 │                     │
└─────────────────┴─────────────────────┘
```
**Cuándo usar:** Desarrollo normal, necesitas navegar archivos

**Después puedes:**
- `<C-/>` para terminal flotante si necesitas
- Continuar trabajando normalmente

---

#### 2. Clean Layout (`<leader>lc`)
```
┌───────────────────────────────────────┐
│                                       │
│           Tu Código                   │
│         (pantalla completa)           │
│                                       │
└───────────────────────────────────────┘
```
**Cuándo usar:** Máximo focus, escribir código sin distracciones

**Después puedes:**
- `<leader>ld` para volver a tener explorer
- `<leader>lf` para agregar terminal

---

#### 3. Full Layout (`<leader>lf`)
```
┌─────────────────┬─────────────────────┐
│                 │                     │
│    Explorer     │    Tu Código        │
│   (archivos)    │                     │
│                 ├─────────────────────┤
│                 │    Terminal         │
└─────────────────┴─────────────────────┘
```
**Cuándo usar:** Desarrollo activo, necesitas terminal constantemente

**Después puedes:**
- `<C-e>` para ir arriba (código)
- `<C-n>` para ir abajo (terminal)
- `<C-m>` para ir a explorer

---

#### 4. Review Layout (`<leader>lr`)
```
┌─────────────────┬─────────────────────┐
│                 │                     │
│    Explorer     │    Código           │
│     (ancho)     │    (lectura)        │
│                 │                     │
└─────────────────┴─────────────────────┘
```
**Cuándo usar:** Code review, leer código, explorar proyecto nuevo

**Después puedes:**
- Navegar con Harpoon entre archivos importantes
- `<leader>lc` para focus en un archivo

---

## 🖥️ Tipos de Terminal (Cuándo usar cada uno)

### 1. Terminal Flotante: `<C-/>` ⚡
```vim
<C-/>    " Aparece/desaparece (toggle)
```
**Ubicación:** CWD (raíz del proyecto)
**Cuándo usar:**
- ✅ Comandos rápidos: `git status`, `npm install`
- ✅ No interrumpe tu layout
- ✅ Aparece sobre todo, desaparece cuando terminas

**Ejemplo:**
```vim
Editando código...
<C-/>              " Terminal aparece
git add .
git commit -m "fix"
<C-/>              " Terminal desaparece
```

---

### 2. Terminal en Layout: `<leader>lf` 🏗️
```vim
<leader>lf    " Full layout con terminal permanente
```
**Ubicación:** CWD (raíz del proyecto)
**Cuándo usar:**
- ✅ Desarrollo activo: server corriendo, builds, tests
- ✅ Necesitas ver output constantemente
- ✅ Comandos desde raíz del proyecto

**Ejemplo:**
```vim
<leader>lf         " Crea layout
# En terminal:
npm run dev        " Server corriendo (ves logs)
# Sigues editando código arriba, ves logs abajo
```

---

### 3. Terminal Local: `<leader>T` 📂
```vim
<leader>T    " Terminal en directorio del archivo actual
```
**Ubicación:** Directorio donde está el archivo que estás editando
**Cuándo usar:**
- ✅ Crear archivos en el mismo directorio
- ✅ Operaciones locales: renombrar, mover archivos
- ✅ Explorar directorio específico

**Ejemplo:**
```vim
# Editando: ~/proyecto/src/components/Button.tsx
<leader>T         " Terminal abre en ~/proyecto/src/components/

# En terminal (ya estás en components/):
touch Input.tsx    " Crea Input.tsx al lado de Button.tsx
ls *.tsx           " Lista componentes locales
```

---

### 📊 Comparación Rápida:

| Terminal | Ubicación | Uso Principal | Toggle |
|----------|-----------|---------------|--------|
| `<C-/>` | CWD (raíz) | Comandos rápidos | ✅ Sí |
| `<leader>lf` | CWD (raíz) | Dev server, builds | ❌ Permanente |
| `<leader>T` | Dir. archivo | Operaciones locales | ❌ Permanente |

---

## 📋 Workflow Completo

### Día típico de desarrollo

```bash
# 1. Abrir proyecto
cd ~/mi-proyecto
nvim
```

```vim
" 2. En Neovim: Dashboard aparece
"    - Puedes seleccionar recent files
"    - O simplemente presionar <leader>sr para restaurar sesión
<leader>sr    " Restaura última sesión (si existe)

" 3. Si no hay sesión, empiezas fresh
<leader>ld    " Aplica Dev layout

" 4. Marca archivos importantes con Harpoon
<leader>ha    " Marca main.rs
<leader>ha    " Marca lib.rs
<leader>ha    " Marca tests.rs

" 5. Navega rápido entre archivos
<leader>1     " → main.rs
<leader>2     " → lib.rs
<leader>3     " → tests.rs

" 6. Necesitas terminal
<C-/>         " Terminal flotante (aparece/desaparece)
" O
<leader>lf    " Cambia a Full layout (terminal permanente)

" 7. Al terminar el día
<leader>ss    " Guarda sesión completa
:qa           " Cierra Neovim
```

---

## 🎯 Casos de Uso Reales

### Caso 1: Bug fix rápido
```vim
nvim bug_file.rs       " Abre archivo directo
" Editas...
:w | :q                " Guardas y sales
```
**No aplicas layout**, solo editas y sales.

---

### Caso 2: Feature nueva (1-2 horas)
```vim
nvim                   " Dashboard
<leader>ld             " Dev layout
<leader>ha             " Marca 3-4 archivos importantes
" Trabajas...
<leader>ss             " Guarda sesión al final
```

---

### Caso 3: Refactoring grande (varios días)
```vim
# Día 1
nvim
<leader>lf             " Full layout (necesitas terminal)
<leader>ha             " Marca 10+ archivos importantes
" Trabajas...
<leader>ss             " Guarda sesión

# Día 2
nvim
<leader>sr             " Restaura TODO como lo dejaste
" Continúas donde quedaste
```

---

### Caso 4: Code review
```vim
nvim
<leader>lr             " Review layout
" Navegas con explorer
" Saltas entre archivos con Harpoon
```

---

## 🔄 Comparación con Alternativas

| Workflow | Velocidad Inicio | Flexibilidad | Setup |
|----------|------------------|--------------|-------|
| **Auto-layout** | 🐢 Lento | ❌ Rígido | ✅ Cero |
| **Sessions only** | ⚡ Rápido | ⚠️ Media | ⚠️ Manual inicial |
| **Hybrid (esto)** | ⚡⚡ Muy rápido | ✅ Total | ✅ Un hotkey |

---

## 💡 Tips Pro

### Tip 1: Combina con Sessions
```vim
" Primera vez en proyecto
<leader>ld             " Aplica layout
<leader>ha             " Marca archivos
<leader>ss             " Guarda sesión

" Próximas veces
<leader>sr             " Restaura TODO
```

### Tip 2: Adapta el layout sobre la marcha
```vim
<leader>ld             " Empiezas con Dev
" Trabajas...
<leader>lf             " Cambias a Full (agrega terminal)
" Trabajas más...
<leader>lc             " Cambias a Clean (focus)
```

### Tip 3: Terminal flotante siempre disponible
```vim
<C-/>                  " Terminal aparece
" Ejecutas comando
<C-/>                  " Terminal desaparece
```
No necesitas cambiar layout solo para un comando rápido.

### Tip 4: Navega con Colemak-DH
```vim
<leader>lf             " Full layout
<C-m>                  " ← Explorer
<C-i>                  " → Código
<C-n>                  " ↓ Terminal
<C-e>                  " ↑ Código
```

---

## 🆚 Cuándo usar cada enfoque

### Usa Quick Layouts cuando:
- ✅ Empiezas sesión nueva
- ✅ Cambias de tipo de trabajo
- ✅ Necesitas estructura rápida

### Usa Sessions cuando:
- ✅ Proyecto long-running (varios días)
- ✅ Layout complejo con múltiples archivos
- ✅ Quieres continuidad perfecta

### Usa Dashboard puro cuando:
- ✅ Bug fix rápido
- ✅ Solo abrir un archivo
- ✅ Exploración rápida

---

## ⚡ Cheatsheet Ultra-Rápido

```
LAYOUTS (resetean todo):
<leader>ld  → Dev (explorer + code)
<leader>lc  → Clean (solo code)
<leader>lf  → Full (explorer + code + terminal en CWD)
<leader>lr  → Review (explorer ancho)

TERMINALES:
<C-/>       → Flotante en CWD (toggle)
<leader>T   → Split en dir. archivo actual

SESSIONS:
<leader>ss  → Save session
<leader>sr  → Restore session (cwd)
<leader>sl  → Load last session

HARPOON:
<leader>ha  → Add file
<leader>1-4 → Jump to file

NAVIGATION (Colemak-DH):
<M-m/n/e/i> → ←↓↑→ entre ventanas (Alt+m/n/e/i)
```

---

## 🎓 Aprendizaje Recomendado

### Semana 1: Layouts básicos
- Usa solo `<leader>ld` y `<leader>lc`
- Familiarízate con el concepto

### Semana 2: Agrega Harpoon
- Empieza a marcar archivos con `<leader>ha`
- Navega con `<leader>1-4`

### Semana 3: Sessions
- Guarda sesiones con `<leader>ss`
- Restaura con `<leader>sr`

### Semana 4: Workflow completo
- Combina todo: Layouts + Harpoon + Sessions
- Adapta a tu estilo

---

## 🚀 Próximos Pasos

1. ✅ **Restart Neovim**
   ```bash
   :qa
   nvim
   ```

2. ✅ **Instalar plugins nuevos**
   ```vim
   :Lazy sync
   ```

3. ✅ **Prueba cada layout**
   ```vim
   <leader>ld    " ¿Abre explorer?
   <leader>lc    " ¿Limpia todo?
   <leader>lf    " ¿Agrega terminal?
   ```

4. ✅ **Ver ayuda con Which-Key**
   ```vim
   <leader>      " Presiona y espera
                 " Verás todas las opciones
   <leader>l     " Verás todas las layouts
   ```

5. ✅ **Practica el workflow completo**
   ```vim
   <leader>ld
   <leader>ha    " Marca archivos
   <leader>ss    " Guarda sesión
   :qa
   nvim
   <leader>sr    " Restaura sesión
   ```

---

**¡Disfruta tu nuevo workflow híbrido!** 🎉

Presiona `<leader>` en cualquier momento para ver todas las opciones disponibles.
