# Translation Agent - Configuración para Claude Code

Documentación para configurar un subagente de traducción en Claude Code CLI usando modelo Haiku.

## 🎯 Propósito

Crear un agente especializado para traducción de textos que:
- Use modelo **Haiku** (rápido y económico)
- Tenga acceso completo a lectura/escritura de archivos
- Se invoque automáticamente para tareas de traducción
- Mantenga formato y estructura del documento original

## 📋 Configuración en Claude Code

### Ubicación del Archivo de Configuración

Claude Code usa archivos de configuración en:
```
~/.claude/
```

### Crear Agente de Traducción

**Archivo**: `~/.claude/agents/translator.json` (o configuración en settings)

```json
{
  "name": "translator",
  "description": "Specialized translation agent using Haiku model for fast, cost-effective translations",
  "model": "haiku",
  "tools": [
    "Read",
    "Write",
    "Edit",
    "Glob",
    "Grep",
    "Bash"
  ],
  "systemPrompt": "You are a professional translator specializing in technical documentation. Rules:\n\n1. MAINTAIN all formatting (markdown, code blocks, indentation, structure)\n2. DO NOT translate:\n   - Code blocks (```code```)\n   - Commands (bash, vim, etc.)\n   - Variable names\n   - Function names\n   - URLs and links\n   - File names\n   - Technical terms (API, CLI, Git, etc.)\n   - Keymaps (e.g., <leader>on)\n   - Placeholders (e.g., {{date}}, {{title}})\n\n3. DO translate:\n   - Descriptions and explanations\n   - User-facing text\n   - Documentation content\n   - Comments in tables\n   - Error/success messages\n\n4. Preserve:\n   - Markdown structure\n   - Links format [[link]] or [text](url)\n   - Lists and numbering\n   - Tables\n   - Headers hierarchy\n\n5. Output:\n   - Create separate file with language suffix (e.g., file.es.md for Spanish)\n   - Maintain original filename structure\n   - Keep encoding and line endings\n\nProvide translations that read naturally in target language while maintaining technical accuracy."
}
```

## 🚀 Uso del Agente

### Invocación Automática

Cuando el usuario solicita una traducción, Claude Code puede invocar automáticamente el agente:

```
User: Traduce README.md del inglés al español

Claude Code detecta "traducción" → Invoca agente translator con modelo Haiku
```

### Invocación Manual con Task Tool

Desde la conversación principal:

```
Por favor usa el agente de traducción (Haiku) para traducir
OBSIDIAN_GUIDE.md del inglés al español
```

## 📝 Patrones de Uso

### 1. Traducir Archivo Completo

**Prompt al agente**:
```
Translate file: /path/to/file.md
From: English
To: Spanish
Output: /path/to/file.es.md

Requirements:
- Maintain markdown format
- Don't translate code blocks
- Keep commands in English
- Preserve links and structure
```

### 2. Traducir Múltiples Archivos

**Prompt al agente**:
```
Translate all *.md files in ~/Vault/templates/
From: English
To: Spanish
Create: filename.es.md for each file

Don't translate:
- {{date}}, {{title}} placeholders
- Code blocks
- Commands
```

### 3. Traducir Sección Específica

**Prompt al agente**:
```
In file KEYMAPS.md, translate only section "## Java (JDTLS)"
From: Spanish
To: English
Edit the file in-place, replacing only that section
```

## 🎨 Ejemplos de Traducción

### Ejemplo 1: Markdown con Código

**Input** (English):
```markdown
## Quick Start

Run the following command:

```bash
npm install
```

This installs all dependencies.
```

**Output** (Spanish):
```markdown
## Inicio Rápido

Ejecuta el siguiente comando:

```bash
npm install
```

Esto instala todas las dependencias.
```

**Nota**: `npm install` NO se tradujo (es un comando).

### Ejemplo 2: Template con Placeholders

**Input** (English):
```markdown
# {{title}}

**Created**: {{date:YYYY-MM-DD}}

## Summary

Brief description here.
```

**Output** (Spanish):
```markdown
# {{title}}

**Creado**: {{date:YYYY-MM-DD}}

## Resumen

Breve descripción aquí.
```

**Nota**: `{{title}}` y `{{date:YYYY-MM-DD}}` NO se tradujeron.

### Ejemplo 3: Keymaps

**Input** (Spanish):
```markdown
| `<leader>on` | Nueva nota | Crear nota nueva |
```

**Output** (English):
```markdown
| `<leader>on` | New note | Create new note |
```

**Nota**: `<leader>on` NO se tradujo (es un keymap).

## ⚙️ Configuración Avanzada

### Agregar Idiomas Específicos

Puedes crear variantes del agente para pares de idiomas específicos:

```json
{
  "name": "translator-es-en",
  "description": "Spanish to English translator",
  "model": "haiku",
  "systemPrompt": "[Base prompt] + Specific glossary for Spanish→English"
}
```

### Agregar Glosario Técnico

En el systemPrompt, agrega términos específicos:

```
Additional glossary:
- workspace → espacio de trabajo (not "área de trabajo")
- vault → bóveda (not "cámara")
- template → plantilla (not "modelo")
- daily note → nota diaria (not "nota del día")
```

## 📊 Ventajas de Usar Haiku

| Característica | Haiku | Sonnet | Opus |
|----------------|-------|--------|------|
| **Velocidad** | ⚡⚡⚡ | ⚡⚡ | ⚡ |
| **Costo/1M tokens** | $0.25 input | $3 input | $15 input |
| **Calidad traducción** | Excelente | Excelente | Excelente |
| **Ideal para** | Traducción, formato | Razonamiento | Tareas complejas |

**Para traducción**: Haiku es óptimo porque:
- ✅ Traducción es tarea bien definida
- ✅ No requiere razonamiento complejo
- ✅ Calidad equivalente a modelos más grandes
- ✅ 60x más económico que Opus
- ✅ 12x más económico que Sonnet

## 🔧 Integración con Workflow

### Workflow 1: Pre-commit Hook

Traducir automáticamente antes de commit:

```bash
#!/bin/bash
# .git/hooks/pre-commit

# Detectar archivos .md modificados
MODIFIED_MD=$(git diff --cached --name-only --diff-filter=ACM | grep '\.md$')

if [ -n "$MODIFIED_MD" ]; then
  echo "Translating modified markdown files..."

  # Invocar Claude Code con agente translator
  for file in $MODIFIED_MD; do
    claude-code task translator "Translate $file to Spanish if not already translated"
  done
fi
```

### Workflow 2: CI/CD Pipeline

```yaml
# .github/workflows/translate.yml
name: Auto-translate Documentation

on:
  push:
    paths:
      - 'docs/**.md'

jobs:
  translate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Translate docs
        run: |
          claude-code task translator \
            "Translate all docs/*.md to Spanish, creating .es.md versions"
```

### Workflow 3: Watch Mode

Script para traducir automáticamente al detectar cambios:

```bash
#!/bin/bash
# watch-translate.sh

# Vigilar cambios en archivos .md
fswatch -o ~/Vault/templates/*.md | while read num
do
  echo "Changes detected, translating..."
  claude-code task translator \
    "Translate modified files in ~/Vault/templates/ to Spanish"
done
```

## 🐛 Troubleshooting

### Problema: Código traducido por error

**Causa**: systemPrompt no es suficientemente claro

**Solución**: Reforzar en el prompt específico:
```
CRITICAL: Do NOT translate any content within ``` code blocks
```

### Problema: Links rotos después de traducir

**Causa**: Traducción de paths en links

**Solución**: En systemPrompt agregar:
```
Keep all [[links]] and [text](url) exactly as-is. Do not translate paths or URLs.
```

### Problema: Formato markdown roto

**Causa**: Modelo no preserva indentación

**Solución**: Enfatizar en systemPrompt:
```
Preserve EXACT indentation, spacing, and markdown syntax.
Copy the structure character-by-character, only translating the text content.
```

## 📚 Recursos

- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [Haiku Model Overview](https://docs.anthropic.com/claude/docs/models-overview#claude-haiku)
- [Agent Configuration Guide](https://docs.anthropic.com/claude-code/agents)

## ✅ Checklist de Configuración

- [ ] Crear archivo de configuración del agente
- [ ] Definir systemPrompt con reglas claras
- [ ] Especificar modelo "haiku"
- [ ] Habilitar herramientas: Read, Write, Edit, Glob, Grep
- [ ] Probar con archivo de ejemplo
- [ ] Verificar que código NO se traduce
- [ ] Verificar que formato se mantiene
- [ ] Verificar que links funcionan

## 🎯 Ejemplo Completo de Configuración

**Archivo**: `~/.claude/agents/translator.json`

```json
{
  "name": "translator",
  "description": "Fast translation agent using Haiku - maintains format, doesn't translate code",
  "model": "haiku",
  "tools": ["Read", "Write", "Edit", "Glob", "Grep", "Bash"],
  "systemPrompt": "You are an expert technical translator.\n\nRULES:\n1. NEVER translate: code blocks, commands, variables, URLs, filenames, technical terms, keymaps, placeholders\n2. ALWAYS translate: descriptions, explanations, user text, documentation\n3. MAINTAIN: all formatting, markdown syntax, indentation, structure, links\n4. OUTPUT: create separate file with language suffix (e.g., .es.md for Spanish)\n\nProvide natural, accurate translations while preserving technical precision.",
  "metadata": {
    "costPerTask": "low",
    "averageSpeed": "fast",
    "useCase": "translation"
  }
}
```

## 🚀 Probar el Agente

```bash
# Test 1: Traducir archivo
claude-code task translator "Translate README.md from English to Spanish, create README.es.md"

# Test 2: Batch translation
claude-code task translator "Translate all *.md in docs/ from English to Spanish"

# Test 3: Traducción específica
claude-code task translator "In KEYMAPS.md, translate section 'Java (JDTLS)' to English"
```

---

**Última actualización**: 2026-01-27
**Modelo**: Haiku (claude-3-haiku-20240307)
**Costo estimado**: ~$0.50 por documento largo (muy económico)
**Configuración**: Claude Code CLI agent system
