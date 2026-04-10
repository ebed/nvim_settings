# Obsidian + Neovim - Guía Completa

Sistema de gestión de conocimiento y tareas usando Obsidian + Neovim con Markdown.

## 🎯 Ventajas de Este Setup

✅ **Markdown universal** - formato estándar, compatible con todo
✅ **Obsidian gratis** - app desktop y móvil sin costo
✅ **Sincronización gratis** - iCloud/Dropbox/Drive/Git (elige uno)
✅ **Edición rápida** - Neovim para edición desde terminal
✅ **Sin parsers complicados** - Markdown nativo
✅ **Multiplataforma** - funciona en Desktop, iOS, Android
✅ **Backlinks y graph** - visualización de relaciones entre notas
✅ **Extensible** - plugins de Obsidian + Neovim

## 📁 Estructura del Vault

```
~/Vault/
├── daily/              → Notas diarias (journal/bitácora)
├── notes/              → Notas permanentes por tema
│   ├── desarrollo/     → Notas técnicas
│   ├── index.md        → Índice principal
│   └── ...
├── projects/           → Seguimiento de proyectos
│   └── index.md        → Lista de proyectos
├── templates/          → Plantillas
│   ├── daily.md        → Template diario
│   ├── project.md      → Template de proyecto
│   └── note.md         → Template de nota
├── attachments/        → Archivos adjuntos (imágenes, PDFs)
├── inbox.md            → Capturas rápidas (bandeja de entrada)
└── README.md           → Documentación del vault
```

## 🚀 Setup Inicial (20-30 minutos)

### 1. Estructura Ya Creada ✅

Los directorios y templates ya están en `~/Vault/`.

### 2. Instalar Obsidian Desktop App

**macOS**:
```bash
brew install --cask obsidian
```

O descarga desde: https://obsidian.md/

### 3. Configurar Obsidian

1. Abre Obsidian
2. Selecciona "Open folder as vault"
3. Navega a `~/Vault`
4. Acepta confiar en el vault

### 4. Instalar Plugins de Obsidian (Recomendados)

Ve a Settings → Community plugins → Browse:

**Esenciales**:
- ✅ **Dataview** - Queries sobre tus notas (ej: listar TODOs)
- ✅ **Tasks** - Gestión avanzada de tareas
- ✅ **Periodic Notes** - Notas diarias/semanales/mensuales
- ✅ **Templates** - Sistema de plantillas
- ✅ **Calendar** - Vista de calendario para notas diarias

**Opcionales pero útiles**:
- **Excalidraw** - Diagramas y dibujos
- **Kanban** - Tableros kanban
- **Tag Wrangler** - Gestión de tags
- **File Explorer Note Count** - Contador de notas por carpeta

### 5. Configurar Periodic Notes

Settings → Periodic Notes:

- Daily notes folder: `daily`
- Daily note template: `templates/daily.md`
- Daily note format: `YYYY-MM-DD`

### 6. Configurar Sincronización

#### Opción A: iCloud (macOS/iOS)

1. Mueve ~/Vault a ~/Library/Mobile Documents/com~apple~CloudDocs/Vault
2. Crea symlink:
```bash
ln -s ~/Library/Mobile\ Documents/com~apple~CloudDocs/Vault ~/Vault
```

#### Opción B: Dropbox

1. Mueve ~/Vault a ~/Dropbox/Vault
2. Crea symlink:
```bash
ln -s ~/Dropbox/Vault ~/Vault
```

#### Opción C: Git (Recomendado para historial)

Ya inicializado en `~/Vault/.git`.

**Crear repo remoto en GitHub** (privado):

```bash
cd ~/Vault
git remote add origin https://github.com/tu-usuario/vault.git
git branch -M main
git push -u origin main
```

**Workflow diario**:
```bash
cd ~/Vault
git add .
git commit -m "Update $(date +%Y-%m-%d)"
git push
```

**Auto-sync con plugin Obsidian Git**:
- Instala plugin "Obsidian Git" en Obsidian
- Configura auto-commit cada X minutos
- Auto-pull al abrir

#### Opción D: Syncthing (Linux/Android)

Instala Syncthing y sincroniza carpeta `~/Vault`.

### 7. Configurar Móvil

**iOS**:
1. Instala Obsidian desde App Store (gratis)
2. Si usas iCloud: automático
3. Si usas Git: instala Working Copy (gratis con limitaciones)

**Android**:
1. Instala Obsidian desde Play Store (gratis)
2. Si usas Syncthing: configura sync
3. Si usas Git: instala MGit o Termux

## ⌨️ Keymaps en Neovim

**Prefix**: `<leader>o` (en archivos Markdown)

### Quick Actions

| Keymap | Acción |
|--------|--------|
| `<leader>on` | Nueva nota |
| `<leader>ot` | Nota de hoy |
| `<leader>oy` | Nota de ayer |
| `<leader>om` | Nota de mañana |

### Búsqueda

| Keymap | Acción |
|--------|--------|
| `<leader>of` | Buscar nota (Telescope) |
| `<leader>os` | Buscar contenido |
| `<leader>ob` | Ver backlinks |
| `<leader>ol` | Seguir link |

### Links

| Keymap | Modo | Acción |
|--------|------|--------|
| `<leader>ok` | n/v | Link a nota |
| `<leader>oK` | n/v | Link nueva nota |

### Otros

| Keymap | Acción |
|--------|--------|
| `<leader>oT` | Insertar template |
| `<leader>oc` | Toggle checkbox |
| `<leader>oo` | Abrir en Obsidian |
| `<leader>or` | Renombrar nota |

## 📝 Sintaxis Markdown + Obsidian

### Headings

```markdown
# Heading 1
## Heading 2
### Heading 3
```

### Listas

```markdown
- Item de lista
  - Sub-item
    - Sub-sub-item

1. Item numerado
2. Otro item
```

### TODOs/Checkboxes

```markdown
- [ ] TODO sin hacer
- [x] TODO completado
- [>] TODO rescheduled
- [~] TODO cancelado
```

Usa `<leader>oc` para toggle entre estados.

### Links

```markdown
[[nota]]                          " Link a nota.md
[[nota|Texto custom]]             " Link con texto alternativo
[[carpeta/nota]]                  " Link con path
[[nota#Sección]]                  " Link a sección específica
[Link externo](https://url.com)   " URL externa
```

### Formato de Texto

```markdown
*cursiva*
**negrita**
***negrita cursiva***
~~tachado~~
`código inline`
==highlight==
```

### Bloques de Código

````markdown
```javascript
const ejemplo = "código aquí";
```
````

### Tablas

```markdown
| Columna 1 | Columna 2 | Columna 3 |
|-----------|-----------|-----------|
| Dato 1    | Dato 2    | Dato 3    |
```

### Tags

```markdown
#tag
#categoria/subcategoria
#desarrollo
#trabajo
```

### Callouts (Obsidian específico)

```markdown
> [!note] Título
> Contenido de la nota

> [!warning] Advertencia
> Contenido de advertencia

> [!tip] Tip
> Contenido del tip
```

Tipos: note, abstract, info, todo, tip, success, question, warning, failure, danger, bug, example, quote.

### Imágenes

```markdown
![[imagen.png]]                    " Imagen local (en attachments/)
![Alt text](https://url.com/img)  " Imagen externa
```

### Frontmatter (Metadata)

```markdown
---
title: Mi Nota
tags: [desarrollo, java]
created: 2026-01-27
---

Contenido de la nota...
```

## 🔥 Workflows Recomendados

### 1. Workflow Diario (Mañana)

**En Neovim**:
```vim
<leader>ot          " Abrir nota de hoy
```

O en terminal:
```bash
nvim ~/Vault/daily/$(date +%Y-%m-%d).md
```

**Contenido**:
- Revisar TODOs de ayer
- Copiar pendientes a hoy
- Planificar día

### 2. Captura Rápida

**Idea rápida**:
```vim
<leader>of          " Buscar "inbox"
# Agregar idea a inbox.md
```

**Nueva nota permanente**:
```vim
<leader>on          " Nueva nota
# Título: "nombre-de-la-nota"
# Escribe contenido
# Linkea desde otras notas
```

### 3. Gestión de Proyecto

**Crear proyecto**:
```vim
<leader>on
# Título: nombre-del-proyecto
<leader>oT          " Insertar template "project"
# Llenar secciones
```

**Actualizar progreso**:
```vim
<leader>of          " Buscar proyecto
# Actualizar estado, TODOs, notas
```

### 4. Notas de Reunión

En daily note del día:
```markdown
## 🤝 Reuniones

### Reunión con Equipo - 14:00
- **Tema**: Revisión de sprint
- **Acuerdos**:
  - [ ] Action item 1 #urgent
  - [ ] Action item 2
- **Decisiones**: Usar arquitectura X
- **Link**: [[projects/nombre-proyecto]]
```

### 5. Código y Snippets

Crear nota técnica:
```vim
<leader>on
# Título: java-stream-api-tips
```

Contenido:
````markdown
# Java Stream API - Tips

## Filter + Map Pattern

```java
List<String> result = list.stream()
    .filter(x -> x.length() > 5)
    .map(String::toUpperCase)
    .collect(Collectors.toList());
```

## Referencias
- [[notes/desarrollo/java]]
- https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html

#desarrollo #java #stream-api
````

### 6. Workflow Semanal (Viernes)

Crear revisión semanal:
```vim
<leader>on
# Título: 2026-W04-review
```

Usar Dataview para queries:
````markdown
## TODOs Completados Esta Semana

```dataview
TASK
WHERE completed
WHERE file.ctime >= date(today) - dur(7 days)
```

## Notas Creadas

```dataview
LIST
FROM ""
WHERE file.ctime >= date(today) - dur(7 days)
SORT file.ctime DESC
```
````

## 🔧 Plugins Útiles de Neovim (Adicionales)

Ya tienes `obsidian.nvim` configurado. Otros plugins útiles:

### Render Markdown en Neovim

```lua
{
  "MeanderingProgrammer/render-markdown.nvim",
  ft = "markdown",
  opts = {},
}
```

### Preview con Glow

```lua
{
  "ellisonleao/glow.nvim",
  cmd = "Glow",
  opts = {},
}
```

Uso: `:Glow` para preview

### Tablas

```lua
{
  "dhruvasagar/vim-table-mode",
  ft = "markdown",
}
```

Activa con `:TableModeToggle`

### LSP para Markdown

Ya configurado con `marksman` (si instalado con Mason).

```vim
:Mason
# Buscar e instalar: marksman, markdownlint
```

## 📊 Queries con Dataview (Obsidian)

### Listar TODOs Pendientes

```dataview
TASK
WHERE !completed
WHERE contains(file.folder, "projects")
```

### Notas Recientes

```dataview
TABLE file.mtime as "Modificado"
FROM ""
SORT file.mtime DESC
LIMIT 10
```

### Proyectos Activos

```dataview
TABLE status, deadline
FROM "projects"
WHERE status = "🟡 En Progreso"
```

### Notas con Tag Específico

```dataview
LIST
FROM #desarrollo
SORT file.name ASC
```

## 🐛 Troubleshooting

### Obsidian.nvim no detecta vault

Verifica path en config:
```lua
workspaces = {
  { name = "vault", path = "~/Vault" }
}
```

### Links no funcionan

Asegúrate de usar formato wiki: `[[nombre-nota]]`

### Templates no se encuentran

Verifica que existen en `~/Vault/templates/`

### Sincronización conflictos

1. Haz pull antes de editar
2. Edita
3. Commit y push inmediatamente

Si hay conflicto:
```bash
git status
# Resolver archivos con conflicto
git add .
git commit -m "Resolve conflicts"
git push
```

## 📱 Tips para Móvil

### iOS

- Usa Obsidian app (gratis)
- Si usas Git: Working Copy para pull/push
- Swipe gestures para navegar

### Android

- Obsidian app (gratis)
- Syncthing para sync automático sin Git
- MGit o Termux para Git

## 🎯 Siguiente Nivel

### Plugins Avanzados Obsidian

- **Templater** (más potente que Templates)
- **QuickAdd** (macros y workflows)
- **Advanced Tables** (edición de tablas)
- **Excalidraw** (dibujos inline)

### Automatización

Script para crear nota diaria automática:
```bash
#!/bin/bash
# ~/bin/daily-note.sh
DATE=$(date +%Y-%m-%d)
NOTE=~/Vault/daily/$DATE.md

if [ ! -f "$NOTE" ]; then
  # Copiar template y reemplazar fecha
  cp ~/Vault/templates/daily.md "$NOTE"
  # Abrir en Neovim
  nvim "$NOTE"
else
  nvim "$NOTE"
fi
```

Agregar a crontab o alias.

## 📚 Recursos

- [Obsidian Help](https://help.obsidian.md/)
- [obsidian.nvim Docs](https://github.com/epwalsh/obsidian.nvim)
- [Dataview Docs](https://blacksmithgu.github.io/obsidian-dataview/)
- [Markdown Guide](https://www.markdownguide.org/)

## ✅ Checklist de Verificación

- [ ] ~/Vault/ existe con estructura correcta
- [ ] Git inicializado en ~/Vault/
- [ ] Obsidian desktop instalado y configurado
- [ ] Plugins instalados (Dataview, Tasks, Periodic Notes)
- [ ] obsidian.nvim funciona (`:checkhealth obsidian` en Neovim)
- [ ] Sincronización configurada (iCloud/Dropbox/Git)
- [ ] Primera nota diaria creada
- [ ] Templates funcionan
- [ ] Móvil configurado (opcional)

---

**Última actualización**: 2026-01-27
**Configuración**: `~/.config/nvim/lua/plugins/obsidian.lua`
**Vault**: `~/Vault/`
