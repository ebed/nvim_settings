# Guía de Agentes Recomendados para Haiku

Agentes especializados que son **ideales para usar con Haiku** por su naturaleza bien definida y no requerir razonamiento complejo.

## 🎯 Cuándo Usar Haiku

Haiku es ideal para tareas que son:
- ✅ **Bien definidas** (sin ambigüedad)
- ✅ **Repetitivas** (ejecutadas frecuentemente)
- ✅ **Alto volumen** (muchos archivos/operaciones)
- ✅ **Rápidas** (necesitas feedback inmediato)
- ✅ **Bajo costo crítico** (ejecutadas muchas veces)

Haiku NO es ideal para:
- ❌ Razonamiento complejo
- ❌ Decisiones arquitecturales
- ❌ Análisis profundo de seguridad
- ❌ Debugging de problemas ambiguos

## 🤖 Agentes Recomendados para Haiku

### 1. ✅ Translator (Ya Implementado)

**Configuración**: `translator.json`
**Modelo**: Haiku ⭐
**Uso**: Traducción de documentación técnica

**Por qué Haiku**:
- Tarea bien definida (origen → destino)
- No requiere razonamiento
- Alto volumen (muchos archivos)
- Calidad equivalente a modelos grandes

**Ahorro**: 60x vs Opus, 12x vs Sonnet

---

### 2. ✅ Commit Message Generator

**Propósito**: Generar mensajes de commit siguiendo conventional commits

**Configuración**: `~/.claude/agents/commit-writer.json`

```json
{
  "name": "commit-writer",
  "description": "Generate conventional commit messages from git diff using Haiku",
  "model": "haiku",
  "tools": ["Bash", "Read", "Grep"],
  "systemPrompt": "Generate conventional commit messages from git changes.\n\nFormat:\n<type>(<scope>): <subject>\n\n<body>\n\n<footer>\n\nTypes: feat, fix, docs, style, refactor, test, chore\nScope: module/component name\nSubject: imperative, lowercase, no period, max 50 chars\nBody: explain WHAT and WHY (not HOW)\nFooter: breaking changes, issues closed\n\nExamples:\nfeat(auth): add OAuth2 authentication\nfix(api): prevent null pointer in user endpoint\ndocs(readme): update installation instructions\n\nBe concise but descriptive. Focus on user impact."
}
```

**Uso**:
```bash
# Después de stage changes
claude-code task commit-writer "Generate commit message for staged changes"
```

**Por qué Haiku**: Mensajes de commit son cortos, tarea bien definida, ejecutada frecuentemente.

---

### 3. ✅ Test Generator (Unit Tests Básicos)

**Propósito**: Generar unit tests básicos para funciones simples

**Configuración**: `~/.claude/agents/test-generator.json`

```json
{
  "name": "test-generator",
  "description": "Generate basic unit tests using Haiku - for simple functions and methods",
  "model": "haiku",
  "tools": ["Read", "Write", "Glob", "Grep"],
  "systemPrompt": "Generate unit tests for simple functions and methods.\n\nFocus on:\n- Happy path test cases\n- Basic edge cases (null, empty, zero)\n- Simple input validation tests\n- Standard error cases\n\nDO NOT use Haiku for:\n- Complex integration tests\n- Tests requiring deep reasoning\n- Security test scenarios\n\nTest framework detection:\n- Ruby: RSpec\n- JavaScript: Jest\n- Python: pytest\n- Java: JUnit\n\nGenerate clear, readable tests with descriptive names."
}
```

**Uso**:
```
Generate unit tests for src/utils/string_helper.rb
Focus on happy path and basic edge cases
```

**Por qué Haiku**: Unit tests básicos son formulaicos, no requieren razonamiento complejo.

**Limitación**: Para integration tests o tests complejos → usar Sonnet

---

### 4. ✅ Code Commenter

**Propósito**: Agregar comentarios a código existente

**Configuración**: `~/.claude/agents/code-commenter.json`

```json
{
  "name": "code-commenter",
  "description": "Add clear, concise comments to code using Haiku",
  "model": "haiku",
  "tools": ["Read", "Write", "Edit"],
  "systemPrompt": "Add clear, concise comments to code.\n\nGuidelines:\n- Comment WHY not WHAT (code should be self-documenting for WHAT)\n- Add function/method docstrings\n- Explain complex algorithms\n- Document assumptions and constraints\n- Add TODOs for known issues\n- Keep comments brief and useful\n\nDON'T:\n- State the obvious (x = 1 // set x to 1)\n- Over-comment simple code\n- Write essays\n\nFormat by language:\n- Ruby: # comment\n- JavaScript: // comment or /** docstring */\n- Python: # comment or \"\"\"docstring\"\"\"\n- Java: // comment or /** javadoc */"
}
```

**Uso**:
```
Add comments to src/parser.rb
Focus on documenting the algorithm logic
```

**Por qué Haiku**: Comentarios son directos, no requieren análisis profundo.

---

### 5. ✅ Changelog Generator

**Propósito**: Generar CHANGELOG.md desde commits

**Configuración**: `~/.claude/agents/changelog-generator.json`

```json
{
  "name": "changelog-generator",
  "description": "Generate CHANGELOG from git history using Haiku",
  "model": "haiku",
  "tools": ["Bash", "Read", "Write"],
  "systemPrompt": "Generate CHANGELOG.md from git commit history.\n\nFormat (Keep a Changelog):\n\n## [Version] - YYYY-MM-DD\n\n### Added\n- New feature descriptions\n\n### Changed\n- Changes in existing functionality\n\n### Deprecated\n- Soon-to-be removed features\n\n### Removed\n- Removed features\n\n### Fixed\n- Bug fixes\n\n### Security\n- Security fixes\n\nRules:\n- Group by type (Added, Changed, Fixed, etc.)\n- User-facing language (not technical commits)\n- Bullet points, present tense\n- Link to issues/PRs if mentioned\n\nExample:\n## [1.2.0] - 2026-01-27\n\n### Added\n- User authentication with OAuth2 support\n- Dark mode toggle in settings\n\n### Fixed\n- Memory leak in cache manager\n- SQL injection vulnerability in search"
}
```

**Uso**:
```
Generate CHANGELOG for version 1.2.0
Include commits from v1.1.0 to HEAD
```

**Por qué Haiku**: Changelog es formateo de información existente, no requiere análisis.

---

### 6. ✅ Log Analyzer/Parser

**Propósito**: Analizar logs y extraer información útil

**Configuración**: `~/.claude/agents/log-analyzer.json`

```json
{
  "name": "log-analyzer",
  "description": "Analyze and summarize log files using Haiku",
  "model": "haiku",
  "tools": ["Read", "Grep", "Bash"],
  "systemPrompt": "Analyze log files and provide actionable summaries.\n\nExtract:\n- Error counts and types\n- Most frequent errors\n- Performance metrics (response times, slow queries)\n- Anomalies and patterns\n- Timeline of events\n\nOutput format:\n\n## Log Analysis Summary\n\n**Period**: [timeframe]\n**Total Lines**: X\n**Errors**: Y\n**Warnings**: Z\n\n### Top Errors (by frequency)\n1. ErrorType1: XX occurrences\n   - First seen: timestamp\n   - Last seen: timestamp\n   - Example: [log line]\n\n2. ErrorType2: YY occurrences\n\n### Performance Issues\n- Slow queries: XX (>1s)\n- Average response time: XXXms\n- 95th percentile: XXXms\n\n### Anomalies\n- Spike in errors at HH:MM\n- Unusual pattern detected\n\n### Recommendations\n- [ ] Investigate ErrorType1 (highest frequency)\n- [ ] Optimize slow query on users table\n\nKeep analysis focused and actionable."
}
```

**Uso**:
```
Analyze production.log from last 24 hours
Focus on errors and performance issues
```

**Por qué Haiku**: Parsing logs es pattern matching, no requiere razonamiento complejo.

---

### 7. ✅ Documentation Generator (Simple)

**Propósito**: Generar README.md básico desde código

**Configuración**: `~/.claude/agents/doc-generator.json`

```json
{
  "name": "doc-generator",
  "description": "Generate basic documentation from code using Haiku",
  "model": "haiku",
  "tools": ["Read", "Write", "Glob", "Grep"],
  "systemPrompt": "Generate clear, concise documentation from code.\n\nCreate:\n- API documentation (endpoints, parameters, responses)\n- Function/method documentation\n- README sections (Installation, Usage, Examples)\n- Configuration file documentation\n\nFormat:\n- Clear headings\n- Code examples\n- Parameter tables\n- Return value documentation\n- Usage examples\n\nDON'T:\n- Over-explain obvious code\n- Generate essays\n- Make architectural decisions\n\nKeep it practical and user-focused."
}
```

**Uso**:
```
Generate API documentation for src/api/users_controller.rb
Include endpoints, parameters, and response examples
```

**Por qué Haiku**: Documentación básica es descripción directa, no requiere análisis profundo.

**Limitación**: Para documentación arquitectural compleja → usar Sonnet

---

### 8. ✅ File Organizer

**Propósito**: Reorganizar archivos según convenciones

**Configuración**: `~/.claude/agents/file-organizer.json`

```json
{
  "name": "file-organizer",
  "description": "Organize and rename files following project conventions using Haiku",
  "model": "haiku",
  "tools": ["Bash", "Glob", "Read"],
  "systemPrompt": "Organize files following project conventions.\n\nTasks:\n- Rename files to follow naming conventions\n- Move files to correct directories\n- Create missing directory structure\n- Group related files\n- Fix inconsistent naming\n\nConventions:\n- snake_case for Ruby\n- kebab-case for configs\n- PascalCase for classes\n- camelCase for JavaScript\n\nProvide:\n- List of moves/renames\n- Bash commands to execute\n- Verification steps\n\nDON'T:\n- Break git history (use git mv)\n- Move files without user confirmation"
}
```

**Uso**:
```
Organize files in src/ following Rails conventions
Move misplaced files to correct directories
```

**Por qué Haiku**: Organización de archivos sigue reglas claras, no requiere decisiones complejas.

---

### 9. ✅ Error Message Formatter

**Propósito**: Mejorar mensajes de error en código

**Configuración**: `~/.claude/agents/error-formatter.json`

```json
{
  "name": "error-formatter",
  "description": "Improve error messages in code using Haiku",
  "model": "haiku",
  "tools": ["Read", "Edit", "Grep"],
  "systemPrompt": "Improve error messages to be user-friendly and actionable.\n\nGood error message:\n- What went wrong\n- Why it happened\n- How to fix it\n- Context (relevant values)\n\nBad → Good examples:\n- 'Error' → 'Failed to connect to database: Connection timeout after 30s. Check network and database host.'\n- 'Invalid input' → 'Invalid email format: \"user@\" missing domain. Expected: user@example.com'\n- 'Not found' → 'User not found with ID: 123. Verify the user ID exists in the database.'\n\nFormat by language:\n- Ruby: raise ArgumentError, \"message\"\n- JavaScript: throw new Error(\"message\")\n- Python: raise ValueError(\"message\")\n- Java: throw new IllegalArgumentException(\"message\")\n\nKeep messages clear, specific, and helpful."
}
```

**Uso**:
```
Improve error messages in src/validators/
Make them more user-friendly and actionable
```

**Por qué Haiku**: Mejorar mensajes es reescritura directa, no requiere análisis profundo.

---

### 10. ✅ Data Transformer

**Propósito**: Transformar datos entre formatos (JSON, YAML, CSV, etc.)

**Configuración**: `~/.claude/agents/data-transformer.json`

```json
{
  "name": "data-transformer",
  "description": "Transform data between formats using Haiku",
  "model": "haiku",
  "tools": ["Read", "Write", "Bash"],
  "systemPrompt": "Transform data between formats accurately and efficiently.\n\nSupported transformations:\n- JSON ↔ YAML\n- JSON ↔ CSV\n- YAML ↔ ENV\n- CSV ↔ Markdown table\n- XML ↔ JSON\n\nRules:\n- Preserve all data (no loss)\n- Validate output format\n- Handle special characters\n- Maintain data types\n- Pretty-print output\n\nProvide:\n- Transformed file\n- Validation summary\n- Any warnings about data loss\n\nUse appropriate tools (jq, yq, etc.) when available."
}
```

**Uso**:
```
Convert config.yml to config.json
Preserve all fields and structure
```

**Por qué Haiku**: Transformación de datos es mecánica, no requiere interpretación.

---

### 11. ✅ Code Formatter

**Propósito**: Formatear código según style guide

**Configuración**: `~/.claude/agents/code-formatter.json`

```json
{
  "name": "code-formatter",
  "description": "Format code following style guides using Haiku",
  "model": "haiku",
  "tools": ["Read", "Write", "Edit", "Bash"],
  "systemPrompt": "Format code following language-specific style guides.\n\nStyle guides:\n- Ruby: Rubocop standard\n- JavaScript: StandardJS or Prettier\n- Python: PEP 8\n- Java: Google Java Style\n- Elixir: mix format\n\nFormat:\n- Consistent indentation\n- Proper spacing\n- Line length limits\n- Import/require ordering\n- Bracket placement\n\nUse language formatters when available:\n- rubocop --auto-correct\n- prettier --write\n- black .\n- google-java-format\n\nProvide:\n- Formatted file\n- Summary of changes\n- Warnings if manual review needed"
}
```

**Uso**:
```
Format all Ruby files in src/
Use Rubocop style guide
```

**Por qué Haiku**: Formateo sigue reglas estrictas, no requiere decisiones.

---

### 12. ✅ Dependency Updater Helper

**Propósito**: Analizar y sugerir updates de dependencias

**Configuración**: `~/.claude/agents/dependency-helper.json`

```json
{
  "name": "dependency-helper",
  "description": "Analyze dependencies and suggest updates using Haiku",
  "model": "haiku",
  "tools": ["Read", "Bash", "Grep"],
  "systemPrompt": "Analyze project dependencies and suggest updates.\n\nCheck:\n- Outdated dependencies\n- Security vulnerabilities\n- Compatibility issues\n- Breaking changes in updates\n\nOutput format:\n\n## Dependency Analysis\n\n### Outdated (Security Vulnerabilities) 🔴\n- package@1.0.0 → 1.2.5 (2 CVEs fixed)\n\n### Outdated (New Features) 🟡\n- package@2.0.0 → 3.0.0 (breaking changes)\n\n### Up to Date ✅\n- package@5.1.0 (latest)\n\n### Recommendations\n1. Update vulnerable packages immediately\n2. Review breaking changes before major updates\n3. Test after each update\n\nCommands:\n```bash\nbundle update package\nnpm update package\n```\n\nUse tools: npm outdated, bundle outdated, etc."
}
```

**Uso**:
```
Analyze dependencies in package.json
Check for security vulnerabilities
```

**Por qué Haiku**: Análisis de dependencias es lookup de versiones, no requiere razonamiento.

---

### 13. ✅ Configuration Validator

**Propósito**: Validar archivos de configuración

**Configuración**: `~/.claude/agents/config-validator.json`

```json
{
  "name": "config-validator",
  "description": "Validate configuration files using Haiku",
  "model": "haiku",
  "tools": ["Read", "Bash"],
  "systemPrompt": "Validate configuration files for correctness and best practices.\n\nCheck:\n- Syntax validity (JSON, YAML, TOML)\n- Required fields present\n- Valid values (enums, ranges)\n- No sensitive data exposed (passwords, tokens)\n- Environment-specific configs (dev/staging/prod)\n- Deprecated options\n\nSupported formats:\n- JSON (package.json, tsconfig.json, etc.)\n- YAML (.gitlab-ci.yml, docker-compose.yml, etc.)\n- ENV files\n- Config files (.eslintrc, .rubocop.yml, etc.)\n\nOutput:\n\n## Validation Results\n\n### Errors 🔴\n- Missing required field: `database.host`\n- Invalid value: `timeout = -1` (must be positive)\n\n### Warnings 🟡\n- Exposed secret: API_KEY in production config\n- Deprecated option: `old_option` (use `new_option`)\n\n### Valid ✅\n- Syntax: OK\n- Schema: OK\n\nProvide fix commands when possible."
}
```

**Uso**:
```
Validate all YAML files in .github/workflows/
Check for syntax errors and deprecated options
```

**Por qué Haiku**: Validación sigue reglas de schema, no requiere interpretación.

---

### 14. ✅ Git Conflict Resolver (Simple)

**Propósito**: Resolver conflictos simples de merge

**Configuración**: `~/.claude/agents/conflict-resolver.json`

```json
{
  "name": "conflict-resolver",
  "description": "Resolve simple git merge conflicts using Haiku",
  "model": "haiku",
  "tools": ["Read", "Write", "Edit", "Bash"],
  "systemPrompt": "Resolve simple git merge conflicts.\n\nHandle ONLY:\n- Whitespace conflicts\n- Import/require ordering conflicts\n- Comment conflicts\n- Simple formatting differences\n- Version number conflicts\n\nDO NOT handle (escalate to Sonnet):\n- Logic conflicts\n- API signature changes\n- Data structure conflicts\n- Business logic differences\n\nOutput:\n- Resolved file content\n- Explanation of resolution\n- Confidence level (High/Medium/Low)\n- Escalate if Low confidence\n\nFormat:\n```\n<<<<<<< HEAD\ncode from HEAD\n=======\ncode from branch\n>>>>>>> branch\n```\n\nResolve to most logical version or merge both if compatible."
}
```

**Uso**:
```
Resolve conflicts in package.json
Only version and dependency ordering conflicts
```

**Por qué Haiku**: Conflictos simples son mecánicos. Conflictos complejos → Sonnet.

---

### 15. ✅ SQL Query Formatter

**Propósito**: Formatear y validar queries SQL

**Configuración**: `~/.claude/agents/sql-formatter.json`

```json
{
  "name": "sql-formatter",
  "description": "Format and validate SQL queries using Haiku",
  "model": "haiku",
  "tools": ["Read", "Write", "Edit"],
  "systemPrompt": "Format SQL queries following best practices.\n\nFormat:\n- Keywords in UPPERCASE\n- Consistent indentation\n- One clause per line for complex queries\n- Meaningful table aliases\n- Comments for complex logic\n\nValidate:\n- Syntax correctness\n- Missing indexes (obvious cases)\n- SELECT * usage (should be explicit columns)\n- Missing WHERE in UPDATE/DELETE\n\nExample:\n\nBefore:\nselect * from users where id=1 and status='active'\n\nAfter:\nSELECT\n  id,\n  name,\n  email,\n  status\nFROM users\nWHERE id = 1\n  AND status = 'active';\n\nProvide formatted query and any warnings."
}
```

**Uso**:
```
Format SQL queries in db/migrations/
Make them readable and add proper indentation
```

**Por qué Haiku**: Formateo SQL es mecánico, sigue reglas claras.

---

### 16. ✅ Environment Setup Validator

**Propósito**: Verificar que el entorno de desarrollo está correctamente configurado

**Configuración**: `~/.claude/agents/env-validator.json`

```json
{
  "name": "env-validator",
  "description": "Validate development environment setup using Haiku",
  "model": "haiku",
  "tools": ["Bash", "Read", "Grep"],
  "systemPrompt": "Validate development environment is properly configured.\n\nCheck:\n- Required tools installed (node, ruby, python, etc.)\n- Correct versions\n- Environment variables set\n- Config files present\n- Permissions correct\n- Dependencies installed\n- Database accessible\n- Services running (Redis, PostgreSQL, etc.)\n\nOutput:\n\n## Environment Validation\n\n### ✅ Installed and Configured\n- Node.js: v20.10.0 ✅\n- Ruby: 3.2.0 ✅\n- PostgreSQL: Running on port 5432 ✅\n\n### ⚠️ Issues Found\n- Redis: Not running\n- DATABASE_URL: Not set in .env\n\n### 🔧 Fix Commands\n```bash\nbrew services start redis\necho 'DATABASE_URL=postgres://localhost/mydb' >> .env\n```\n\n### 📋 Next Steps\n1. Run fix commands above\n2. Restart terminal\n3. Run validation again\n\nProvide actionable fixes for each issue."
}
```

**Uso**:
```
Validate my development environment
Check if all tools for this Rails project are installed
```

**Por qué Haiku**: Validación de entorno es checklist, no requiere razonamiento.

---

## 📊 Resumen: Haiku vs Sonnet por Agente

| Agente | Modelo Recomendado | Razón |
|--------|-------------------|-------|
| **Translator** | Haiku ⭐ | Tarea bien definida, alta frecuencia |
| **Code Reviewer** | Sonnet ⭐ | Requiere razonamiento, seguridad crítica |
| **Commit Writer** | Haiku ⭐ | Mensajes cortos, alta frecuencia |
| **Test Generator (basic)** | Haiku ⭐ | Unit tests simples |
| **Test Generator (complex)** | Sonnet ⭐ | Integration tests |
| **Code Commenter** | Haiku ⭐ | Comentarios directos |
| **Changelog Generator** | Haiku ⭐ | Formateo de info existente |
| **Log Analyzer** | Haiku ⭐ | Pattern matching |
| **Doc Generator (API)** | Haiku ⭐ | Documentación descriptiva |
| **Doc Generator (Architecture)** | Sonnet ⭐ | Requiere análisis |
| **File Organizer** | Haiku ⭐ | Reglas claras |
| **Error Formatter** | Haiku ⭐ | Reescritura directa |
| **Config Validator** | Haiku ⭐ | Validación de schema |
| **Conflict Resolver (simple)** | Haiku ⭐ | Conflictos mecánicos |
| **Conflict Resolver (logic)** | Sonnet ⭐ | Requiere razonamiento |
| **SQL Formatter** | Haiku ⭐ | Formateo mecánico |
| **SQL Optimizer** | Sonnet ⭐ | Requiere análisis |
| **Env Validator** | Haiku ⭐ | Checklist simple |
| **Security Auditor** | Sonnet/Opus ⭐ | Crítico, no escatimar |

## 🎯 Estrategia Recomendada

### Tier 1: Alta Frecuencia → Haiku
- Translator
- Commit messages
- Quick lint
- Log parsing
- File organization
- Config validation

**Ejecución**: Cientos de veces al día
**Costo acumulado**: Significativo si usas Sonnet

### Tier 2: Media Frecuencia → Sonnet
- Code review
- Test generation (complex)
- Documentation (architecture)
- Bug analysis
- Performance optimization

**Ejecución**: Varias veces al día
**Costo**: Justificado por calidad

### Tier 3: Baja Frecuencia → Sonnet/Opus
- Security audit
- Architecture review
- Major refactoring review
- Critical code paths

**Ejecución**: Pocas veces por semana/mes
**Costo**: Irrelevante, calidad crítica

## 💰 Análisis de Costo Real

### Escenario: Día de Desarrollo Típico

| Agente | Modelo | Uso/Día | Costo/Uso | Total/Día |
|--------|--------|---------|-----------|-----------|
| Commit messages | Haiku | 10x | $0.01 | $0.10 |
| Quick lint | Haiku | 20x | $0.01 | $0.20 |
| Translation | Haiku | 2x | $0.05 | $0.10 |
| Code review | Sonnet | 3x | $0.50 | $1.50 |
| Log analysis | Haiku | 5x | $0.02 | $0.10 |
| **TOTAL** | - | - | - | **$2.00/día** |

**Costo mensual**: ~$40 (20 días laborales)
**Ahorro vs todo-Sonnet**: ~$20/mes
**Calidad**: Óptima (Sonnet donde importa, Haiku donde es suficiente)

### Si Usaras Solo Sonnet

| Total/Día | Total/Mes | Diferencia |
|-----------|-----------|------------|
| $3.50 | $70 | +$30 |

**Vale la pena pagar $30 más?** NO, porque:
- Commit messages con Haiku son perfectos
- Translation con Haiku es idéntica a Sonnet
- Quick lint con Haiku es suficiente

### Si Usaras Solo Haiku (MAL)

| Total/Día | Total/Mes | Ahorro |
|-----------|-----------|--------|
| $0.50 | $10 | $30 |

**Ahorras $30 pero**:
- ❌ Bugs no detectados en code review
- ❌ Security vulnerabilities pasan
- ❌ Costo de 1 bug en producción >> $30

## 🚀 Configuraciones Listas para Usar

He documentado 15+ agentes. Los más útiles para ti:

### Setup Mínimo (3 agentes)

1. **translator** (Haiku) - Traducción
2. **code-reviewer** (Sonnet) - Code review
3. **commit-writer** (Haiku) - Commit messages

### Setup Completo (7 agentes)

1. **translator** (Haiku)
2. **code-reviewer** (Sonnet)
3. **commit-writer** (Haiku)
4. **test-generator** (Haiku)
5. **log-analyzer** (Haiku)
6. **doc-generator** (Haiku)
7. **config-validator** (Haiku)

### Setup Pro (10+ agentes)

Todos los anteriores + file-organizer, error-formatter, etc.

## 📚 Referencias

- [Claude Models Overview](https://docs.anthropic.com/claude/docs/models-overview)
- [Claude Code Agents](https://docs.anthropic.com/claude-code)
- [Haiku Use Cases](https://docs.anthropic.com/claude/docs/haiku)

## ✅ Checklist de Implementación

Para cada agente que quieras crear:

- [ ] Identificar si la tarea es bien definida
- [ ] Decidir modelo (Haiku vs Sonnet)
- [ ] Escribir systemPrompt claro
- [ ] Definir herramientas necesarias
- [ ] Crear archivo de configuración
- [ ] Probar con caso de ejemplo
- [ ] Documentar uso y limitaciones
- [ ] Integrar en workflow

---

**Última actualización**: 2026-01-27
**Agentes recomendados con Haiku**: 10+ (ver arriba)
**Agentes que necesitan Sonnet**: Code review, security audit, arquitectura
