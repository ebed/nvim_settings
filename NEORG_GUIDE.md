# Neorg Complete Guide

Guía completa de uso de Neorg para workflow de desarrollo y bitácora diaria.

## 📁 Estructura de Workspaces

```
~/neorg/
├── desarrollo/          # Notas técnicas, snippets, arquitectura
│   ├── index.norg      # Índice principal
│   ├── java/           # Notas específicas de Java
│   ├── ruby/           # Notas específicas de Ruby
│   └── ...
├── journal/            # Bitácora diaria
│   ├── index.norg      # Índice de journals
│   ├── template.norg   # Template para entradas
│   ├── 2026-01-27.norg # Entrada del día
│   └── ...
├── proyectos/          # Documentación de proyectos
│   ├── index.norg      # Índice de proyectos
│   └── pagerduty/      # Proyecto específico
└── personal/           # Notas personales
    ├── index.norg      # Índice personal
    └── ...
```

## 🎯 Comandos Principales

### Navegación entre Workspaces

| Comando | Acción |
|---------|--------|
| `:Neorg workspace` | Selector de workspace |
| `:Neorg workspace desarrollo` | Abrir workspace de desarrollo |
| `:Neorg workspace journal` | Abrir workspace de journal |
| `:Neorg workspace proyectos` | Abrir workspace de proyectos |
| `:Neorg workspace personal` | Abrir workspace personal |
| `:Neorg index` | Abrir index.norg del workspace actual |
| `:Neorg return` | Volver al archivo anterior |

### Journal / Bitácora Diaria

| Comando | Acción |
|---------|--------|
| `:Neorg journal today` | Crear/abrir entrada de HOY |
| `:Neorg journal yesterday` | Abrir entrada de AYER |
| `:Neorg journal tomorrow` | Crear entrada de MAÑANA |
| `:Neorg journal custom` | Entrada de fecha específica |

**Tip**: Las entradas de journal usan el template automáticamente.

### Exportar

| Comando | Acción |
|---------|--------|
| `:Neorg export to-file` | Exportar a markdown |

## ⌨️ Keymaps

**Leader de Neorg**: `<leader>n`

### Workspaces

| Keymap | Acción |
|--------|--------|
| `<leader>nw` | Selector de workspace |
| `<leader>nd` | Abrir workspace **desarrollo** |
| `<leader>nj` | Abrir workspace **journal** |
| `<leader>np` | Abrir workspace **proyectos** |
| `<leader>ni` | Abrir índice del workspace actual |
| `<leader>nr` | Volver al archivo anterior |

### Journal (Bitácora)

| Keymap | Acción |
|--------|--------|
| `<leader>njt` | Journal de **hoy** |
| `<leader>njy` | Journal de **ayer** |
| `<leader>njm` | Journal de **mañana** |
| `<leader>njc` | Journal de **fecha custom** |

### TODOs

| Keymap | Acción |
|--------|--------|
| `<leader>ntd` | Marcar TODO como **done** ✓ |
| `<leader>ntu` | Marcar TODO como **undone** ✗ |
| `<leader>ntp` | Marcar TODO como **pending** ○ |
| `<leader>ntc` | Marcar TODO como **cancelled** ⊘ |

**Ciclar estados**: `<C-Space>` (en la línea del TODO)

### Telescope

| Keymap | Acción |
|--------|--------|
| `<leader>nf` | **Buscar** archivos .norg |
| `<leader>ns` | **Buscar** headings (títulos) |
| `<leader>nl` | **Buscar** linkables |

### Otros

| Keymap | Acción |
|--------|--------|
| `<leader>ne` | **Exportar** a archivo |
| `<leader>nk` (visual) | Crear **link** desde selección |
| `<C-d>` (insert) | Insertar **fecha** (2026-01-27) |
| `<C-t>` (insert) | Insertar **hora** (14:30) |

## 📝 Sintaxis Norg (Cheat Sheet)

### Headings

```norg
* Heading 1
** Heading 2
*** Heading 3
**** Heading 4
***** Heading 5
****** Heading 6
```

### Listas

```norg
- Item de lista desordenada
- Otro item
  - Sub-item (indent con 2 espacios)

~ Item numerado
~ Otro item numerado
  ~ Sub-item numerado
```

### TODOs

```norg
- ( ) TODO undone
- (x) TODO done
- (-) TODO pending
- (!) TODO urgent
- (+) TODO recurring
- (?) TODO uncertain
- (_) TODO on hold
- (=) TODO cancelled
```

**Tip**: Usa `<C-Space>` para ciclar estados.

### Links

```norg
{/ Destino}[Texto del link]           " Link a heading
{: archivo :}[Link a archivo]         " Link a archivo
{https://url.com}[Link externo]       " URL externa
{# Anchor}[Link a anchor en mismo archivo]
```

### Markup de Texto

```norg
*bold text*                  " Negrita
/italic text/                " Cursiva
_underline_                  " Subrayado
-strikethrough-              " Tachado
!spoiler!                    " Spoiler
^superscript^                " Superíndice
,subscript,                  " Subíndice
`inline code`                " Código inline
$inline math$                " Math inline
```

### Código

````norg
@code java
public class Example {
    public static void main(String[] args) {
        System.out.println("Hello Neorg!");
    }
}
@end
````

Lenguajes soportados: `java`, `ruby`, `elixir`, `javascript`, `python`, `bash`, `sql`, etc.

### Citas

```norg
> Esta es una cita
> Puede tener múltiples líneas
```

### Separadores

```norg
---
___
***
```

### Metadata

```norg
@document.meta
title: Mi Documento
description: Descripción del contenido
author: Roberto Alberto Merino
categories: desarrollo
created: 2026-01-27
updated: 2026-01-27
version: 1.0
@end
```

### Tags

```norg
#tag
#multiple-words-tag
#categoría/subcategoría
```

### Tablas

```norg
| Columna 1 | Columna 2 | Columna 3 |
|-----------|-----------|-----------|
| Dato 1    | Dato 2    | Dato 3    |
| Dato 4    | Dato 5    | Dato 6    |
```

### Definiciones

```norg
$ Término
  Definición del término.
  Puede tener múltiples líneas.
```

### Footnotes

```norg
Texto con footnote[^1].

[^1]: Contenido del footnote.
```

### Math

```norg
$$
E = mc^2
$$
```

## 🔥 Workflow Diario Recomendado

### 1. Iniciar el Día (Mañana)

**Objetivo**: Revisar journal de ayer y crear entrada de hoy.

```vim
" 1. Abrir journal de ayer para revisar TODOs pendientes
<leader>njy

" 2. Crear journal de hoy
<leader>njt

" 3. En el journal de hoy:
"    - Copiar TODOs pendientes de ayer
"    - Agregar nuevos TODOs del día
"    - Marcar prioridades con {URGENT}
```

### 2. Durante el Día (Desarrollo)

**Objetivo**: Tomar notas rápidas de código, problemas y soluciones.

```vim
" 1. Abrir workspace de desarrollo
<leader>nd

" 2. Crear nota rápida (ej: problema con imports de Java)
:edit java-imports-wildcard.norg

" 3. Escribir nota con código:
```

**Ejemplo de nota**:
```norg
* Java Import Wildcard Issue

  Problema: JDTLS no colapsa imports a wildcards automáticamente.

  ** Solución
     @code lua
     sources = {
       organizeImports = {
         starThreshold = 3,
       }
     }
     @end

  ** Referencias
     - {: jdtls-config :}[JDTLS Config]
     - {https://github.com/eclipse/eclipse.jdt.ls}

  ~ Tags: #java #jdtls #imports
```

### 3. Reuniones (Durante el Día)

**Objetivo**: Documentar reuniones en el journal del día.

```vim
" Mientras estás en la reunión:
<leader>njt   " Abrir journal de hoy
```

Agregar sección:
```norg
** Reunión con [Equipo/Persona] - 14:00
   - Tema: Revisión de arquitectura microservicios
   - Acuerdos:
     - ( ) Migrar servicio A primero
     - ( ) Definir contratos de API
   - Decisiones: Usar gRPC en lugar de REST
   - Follow-up: Reunión de seguimiento en 1 semana
```

### 4. Finalizar el Día (Tarde/Noche)

**Objetivo**: Completar journal del día con resumen y TODOs para mañana.

```vim
<leader>njt   " Abrir journal de hoy
```

Completar secciones:
- Marcar TODOs completados: `<leader>ntd`
- Agregar aprendizajes del día
- Documentar problemas y soluciones
- Crear TODOs para mañana

### 5. Proyectos Específicos

**Objetivo**: Documentar progreso de proyectos en curso.

```vim
<leader>np    " Abrir workspace proyectos
:edit pagerduty/progress.norg
```

Actualizar estado del proyecto:
```norg
* Proyecto PagerDuty Integration

  ** Progreso Semana 27/01/2026
     - [x] Setup webhook endpoint
     - [x] Implementar autenticación
     - ( ) Testing de alertas
     - ( ) Documentar API

  ** Blocker
     Rate limiting de PagerDuty API - esperando respuesta de soporte.
```

## 🎨 Tips y Trucos

### 1. Búsqueda Rápida con Telescope

```vim
<leader>nf    " Buscar archivo por nombre
<leader>ns    " Buscar por contenido de headings
```

Usa esto para encontrar notas rápidamente sin navegar manualmente.

### 2. Links Internos

Crea una red de notas interconectadas:

```norg
" En desarrollo/java-performance.norg:
Ver también: {: java-best-practices :}[Java Best Practices]

" En desarrollo/java-best-practices.norg:
Relacionado: {: java-performance :}[Performance Tips]
```

### 3. Templates Personalizados

Crea templates para tipos de notas recurrentes:

```bash
# Template para ADR (Architecture Decision Record)
cp ~/neorg/desarrollo/index.norg ~/neorg/desarrollo/adr-template.norg
```

### 4. Export a Markdown

Para compartir con otros:

```vim
<leader>ne    " Export to markdown
```

### 5. Integración con Git

Versiona tus notas:

```bash
cd ~/neorg
git init
git add .
git commit -m "Initial commit"
```

Haz commits periódicos de tu journal:

```bash
# Al final de cada semana
git add journal/
git commit -m "Journal: Week of Jan 20-26"
```

## 🚀 Casos de Uso Específicos

### Bug Tracking en Journal

```norg
* Trabajo y Desarrollo

  ** Bug: Memory Leak en Servicio X
     Descripción: El servicio consume memoria progresivamente.

     --- Investigación
     - Heap dump analizado con VisualVM
     - Sospecha: Connection pool no se cierra

     --- Solución
     @code java
     // Agregar try-with-resources
     try (Connection conn = dataSource.getConnection()) {
         // ...
     }
     @end

     --- Resultado
     Memory leak resuelto, consumo estable en 200MB.

     ~ Tags: #bug #memory-leak #java
```

### Code Snippet Repository

```norg
* Database Query Optimization

  ** N+1 Query Fix (Rails)
     @code ruby
     # Bad: N+1 queries
     users = User.all
     users.each { |user| puts user.posts.count }

     # Good: Eager loading
     users = User.includes(:posts)
     users.each { |user| puts user.posts.size }
     @end

  ** Explain Analyze (PostgreSQL)
     @code sql
     EXPLAIN ANALYZE
     SELECT * FROM users
     WHERE created_at > NOW() - INTERVAL '7 days';
     @end
```

### Meeting Notes con Action Items

```norg
* Reuniones y Comunicaciones

  ** Sprint Planning - 2026-01-27 10:00
     Participantes: @juan @maria @roberto

     --- Prioridades del Sprint
     ~ Story 1: Implementar autenticación OAuth
     ~ Story 2: Optimizar queries de dashboard
     ~ Story 3: Agregar tests E2E

     --- Action Items
     - ( ) @roberto: Setup OAuth provider {URGENT}
       Deadline: 2026-01-29
     - ( ) @maria: Revisar índices de database
       Deadline: 2026-01-31
     - ( ) @juan: Configurar Playwright
       Deadline: 2026-02-02

     --- Decisiones
     - Usaremos Auth0 como provider OAuth
     - Sprint duration: 2 semanas
     - Daily standups a las 9:30am
```

## 📊 Revisión Semanal/Mensual

Cada viernes o fin de mes, crea una revisión:

```vim
<leader>nj
:edit review-2026-01-week4.norg
```

```norg
* Revisión Semanal: 20-26 Enero 2026

  ** Logros Principales
     - [x] Optimización completa de Neovim config
     - [x] Implementación de wildcard imports en Java
     - [x] Setup de Neorg para bitácora

  ** Aprendizajes Clave
     ~ Lua patterns para filtrado de diagnósticos
     ~ Configuración avanzada de JDTLS handlers
     ~ Neorg módulos y workspaces

  ** Métricas
     - TODOs completados: 42
     - Bugs resueltos: 8
     - Reuniones: 5
     - Días productivos: 5/5

  ** Objetivos Próxima Semana
     - ( ) Completar integración PagerDuty
     - ( ) Escribir documentación de API
     - ( ) Refactoring de módulo de autenticación

  ** Reflexiones
     Buena semana de productividad. La configuración de Neorg
     ayuda mucho a mantener organizado el trabajo.
```

## 🔧 Troubleshooting

### Parser no instalado

```vim
:TSInstall norg
:TSInstall norg_meta
```

### Icons no se ven

Asegúrate de tener una Nerd Font instalada (Hack Nerd Font, JetBrains Mono, etc).

### Telescope no encuentra archivos

```vim
:checkhealth telescope
```

Verifica que `rg` (ripgrep) esté instalado:

```bash
brew install ripgrep
```

### Links no funcionan

Verifica que el archivo destino exista:

```vim
:Neorg index  " Ver todos los archivos en workspace
```

## 📚 Referencias

- [Neorg Wiki](https://github.com/nvim-neorg/neorg/wiki)
- [Norg Specification](https://github.com/nvim-neorg/norg-specs)
- [Neorg Modules](https://github.com/nvim-neorg/neorg/wiki/Modules)

## 🎯 Next Steps

1. **Instala el parser**: `:TSInstall norg norg_meta`
2. **Crea tu primer journal**: `<leader>njt`
3. **Explora los templates**: Edita `~/neorg/journal/template.norg`
4. **Personaliza workspaces**: Ajusta paths en `lua/plugins/neorg.lua`

---

**Última actualización**: 2026-01-27
**Autor**: Roberto Alberto Merino
