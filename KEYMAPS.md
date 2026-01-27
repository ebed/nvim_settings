# Keymaps Quick Reference

## 🗺️ Guía Rápida de Atajos de Teclado

**Leader key:** `<Space>`

---

## 📁 General & Navigation

| Keymap | Acción | Descripción |
|--------|--------|-------------|
| `<leader>w` | Save | Guardar archivo actual |
| `<leader>q` | Quit | Cerrar ventana actual |
| `<leader>Q` | Force Quit | Cerrar todo (forzado) |
| `<leader>h` | Clear highlight | Limpiar resaltado de búsqueda |
| `<Tab>` | Next buffer | Siguiente buffer |
| `<S-Tab>` | Previous buffer | Buffer anterior |
| `<leader>bd` | Delete buffer | Cerrar buffer actual |
| `<C-A>` | Go to line start | Inicio de línea (todos los modos) |
| `<C-E>` | Go to line end | Fin de línea (todos los modos) |

### Ventanas (Splits)

| Keymap | Acción |
|--------|--------|
| `<leader>sv` | Split vertical |
| `<leader>sh` | Split horizontal |
| `<leader>se` | Equalizar splits |
| `<leader>sx` | Cerrar split |

---

## 🔍 Telescope (Búsqueda)

| Keymap | Acción | Descripción |
|--------|--------|-------------|
| `<leader>ff` | Find files | Buscar archivos |
| `<leader>fg` | Live grep | Buscar en contenido |
| `<leader>fb` | Find buffers | Buscar en buffers abiertos |
| `<leader>fh` | Help tags | Buscar en ayuda |
| `<leader>fr` | Recent files | Archivos recientes |
| `<leader>fw` | Search word | Buscar palabra bajo cursor |

---

## 🌿 Git Operations

| Keymap | Acción | Descripción |
|--------|--------|-------------|
| `<leader>gg` | LazyGit | Abrir LazyGit TUI |
| `<leader>gb` | Git branches | Ver branches |
| `<leader>gc` | Git commits | Ver commits |
| `<leader>gs` | Git status | Ver status |

---

## 💡 LSP (Language Server)

### Navigation

| Keymap | Acción | Descripción |
|--------|--------|-------------|
| `gd` | Go to definition | Ir a definición |
| `gD` | Go to declaration | Ir a declaración |
| `gi` | Go to implementation | Ir a implementación |
| `gr` | Go to references | Ver referencias |
| `K` | Hover | Ver documentación (hover.nvim) |

### Actions

| Keymap | Acción | Descripción |
|--------|--------|-------------|
| `<leader>rn` | Rename | Renombrar símbolo |
| `<leader>ca` | Code action | Acciones de código |
| `<leader>f` | Format | Formatear buffer |
| `<leader>dl` | Diagnostics list | Lista de diagnósticos |
| `!` | Open diagnostic float | Ver diagnóstico flotante |
| `[d` | Previous diagnostic | Diagnóstico anterior |
| `]d` | Next diagnostic | Siguiente diagnóstico |

---

## 🐛 Debugging (DAP)

| Keymap | Acción | Descripción |
|--------|--------|-------------|
| `<F5>` | Continue | Continuar/Iniciar debug |
| `<F10>` | Step over | Paso siguiente (sobre) |
| `<F11>` | Step into | Paso siguiente (dentro) |
| `<F12>` | Step out | Salir de función |
| `<leader>db` | Toggle breakpoint | Breakpoint on/off |
| `<leader>dr` | REPL toggle | Abrir/cerrar REPL |

---

## ☕ Java (JDTLS)

### Refactoring

| Keymap | Acción | Descripción |
|--------|--------|-------------|
| `<leader>jo` | Organize imports + wildcards | Organiza imports y colapsa a wildcard (3+) |
| `<leader>jv` | Extract variable | Extraer variable |
| `<leader>jc` | Extract constant | Extraer constante |
| `<leader>jm` | Extract method | Extraer método |

**Nota sobre imports**: Cuando hay 3 o más clases del mismo paquete, se colapsan automáticamente a wildcard (`import pkg.*;`). Ver `JAVA_IMPORTS_GUIDE.md` para detalles.

### Testing

| Keymap | Acción |
|--------|--------|
| `<leader>jt` | Test nearest method | Test del método más cercano |
| `<leader>jT` | Test class | Test de toda la clase |

### Comandos

```vim
:JavaInfo                " Ver configuración Java/JDTLS
:JavaClean               " Limpiar workspace
:JavaRestart             " Reiniciar JDTLS
:JavaNewProject <name>   " Crear proyecto Maven
:OrganizeImports         " Organizar imports con wildcards (Java)
:CollapseImports [N]     " Colapsar a wildcards (umbral: N, default 3)
:SortImports             " Ordenar imports alfabéticamente (sin colapsar)
:ToggleWildcardWarnings  " Activar/desactivar filtro de warnings de wildcards
```

---

## 🧪 Testing (Neotest)

| Keymap | Acción | Descripción |
|--------|--------|-------------|
| `<leader>Te` | Run test | Ejecutar test bajo cursor |
| `<leader>Ta` | Run test suite | Ejecutar suite completa |
| `<leader>Tc` | Run current file | Ejecutar tests del archivo |
| `<leader>Ts` | Test summary | Ver resumen de tests |

---

## 🤖 AI Assistance (Copilot)

| Keymap | Acción | Descripción |
|--------|--------|-------------|
| `<leader>cc` | CopilotChat toggle | Abrir/cerrar chat |
| `<leader>cp` | CopilotChat prompt | Seleccionar prompt |
| `<leader>cd` | CopilotChat doc | Generar documentación |

---

## 📝 Neorg (Notas y Bitácora)

**Leader de Neorg**: `<leader>n`

### Workspaces

| Keymap | Acción | Descripción |
|--------|--------|-------------|
| `<leader>nw` | Select workspace | Selector de workspace |
| `<leader>nd` | Workspace desarrollo | Notas técnicas y desarrollo |
| `<leader>nj` | Workspace journal | Bitácora diaria |
| `<leader>np` | Workspace proyectos | Documentación de proyectos |
| `<leader>ni` | Workspace index | Abrir índice del workspace actual |
| `<leader>nr` | Return | Volver al archivo anterior |

### Journal / Bitácora Diaria

| Keymap | Acción | Descripción |
|--------|--------|-------------|
| `<leader>njt` | Today's journal | Crear/abrir entrada de HOY |
| `<leader>njy` | Yesterday's journal | Abrir entrada de AYER |
| `<leader>njm` | Tomorrow's journal | Crear entrada de MAÑANA |
| `<leader>njc` | Custom date journal | Journal de fecha específica |

### TODO Management

| Keymap | Acción | Descripción |
|--------|--------|-------------|
| `<leader>ntd` | TODO done | Marcar como completado ✓ |
| `<leader>ntu` | TODO undone | Marcar como no completado ✗ |
| `<leader>ntp` | TODO pending | Marcar como pendiente ○ |
| `<leader>ntc` | TODO cancelled | Cancelar TODO ⊘ |
| `<C-Space>` | Cycle TODO state | Ciclar entre estados |

### Telescope Integration

| Keymap | Acción | Descripción |
|--------|--------|-------------|
| `<leader>nf` | Find norg files | Buscar archivos .norg |
| `<leader>ns` | Search headings | Buscar en títulos |
| `<leader>nl` | Find linkable | Buscar elementos linkables |

### Otros

| Keymap | Acción | Descripción |
|--------|--------|-------------|
| `<leader>ne` | Export to file | Exportar a markdown |
| `<leader>nk` (visual) | Create link | Crear link desde selección |
| `<C-d>` (insert) | Insert date | Insertar fecha (2026-01-27) |
| `<C-t>` (insert) | Insert time | Insertar hora (14:30) |

### Comandos

```vim
:Neorg workspace           " Selector de workspace
:Neorg workspace desarrollo " Abrir workspace específico
:Neorg journal today       " Journal de hoy
:Neorg index               " Abrir índice
:Neorg export to-file      " Exportar a markdown
:TSInstall norg            " Instalar parser de Neorg
```

**Ver guía completa**: `NEORG_GUIDE.md`

---

## 🎨 Plugins Varios

### Snacks.nvim

| Keymap | Acción |
|--------|--------|
| `<leader>sd` | Snacks Dashboard |
| `<leader>sp` | Snacks Picker |
| `<leader>sn` | Snacks Notify |
| `<leader>se` | Snacks Explorer |

### File Explorer

| Keymap | Acción |
|--------|--------|
| `<leader>e` | Toggle Neo-tree |

### Terminal

| Keymap | Acción |
|--------|--------|
| `<leader>tt` | Toggle terminal |

### Bookmarks

| Keymap | Acción |
|--------|--------|
| `<leader>MB` | List all bookmarks |
| `<leader>MB0-6` | List bookmark group N |

### Markdown

| Keymap | Acción |
|--------|--------|
| `<leader>mp` | Markdown preview toggle |

### Build Tools

| Keymap | Acción |
|--------|--------|
| `<leader>mb` | Maven build |
| `<leader>mr` | Maven run |
| `<leader>et` | Elixir mix toggle |

### HTTP/REST Client

En archivos `.http`:

| Keymap | Acción |
|--------|--------|
| `<leader>r` | Ejecutar request |

---

## 🎯 Leap (Motion)

| Keymap | Acción |
|--------|--------|
| `R` (visual/operator) | Treesitter select |

---

## 💡 Tips

### Descubrir Keymaps

```vim
:Telescope keymaps
```

### Ver Keymaps de Buffer Actual

```vim
:verbose map <leader>
```

### WhichKey

Al presionar `<leader>` y esperar, aparece menú con opciones disponibles.

---

## 📝 Convenciones

- **`<leader>`** = Espacio
- **`g` prefix** = "Go to" navigation
- **`<leader>f`** = "Find" (Telescope)
- **`<leader>g`** = "Git"
- **`<leader>c`** = "Copilot/Code"
- **`<leader>d`** = "Debug/Diagnostics"
- **`<leader>T`** = "Test"
- **`<leader>s`** = "Snacks"
- **`<leader>M`** = "Marks/Bookmarks"
- **`<leader>m`** = "Maven/Build"
- **`<leader>e`** = "Explorer/Elixir"

---

## 🔧 Personalización

Para agregar/modificar keymaps, editar:

```
~/.config/nvim/lua/config/mappings/
├── general.lua    # Navegación básica
├── telescope.lua  # Búsqueda
├── git.lua        # Git
├── lsp.lua        # LSP
├── dap.lua        # Debugging
├── plugins.lua    # Plugins varios
├── java.lua       # Java específico
└── testing.lua    # Testing
```
