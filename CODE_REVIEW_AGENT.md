# Code Review Agent - Configuración para Claude Code

Documentación para configurar subagentes de code review en Claude Code CLI.

## 🎯 Recomendación de Modelo

### ✅ Sonnet (RECOMENDADO para Code Review)

**Usar Sonnet porque**:
- ✅ Detecta bugs sutiles y edge cases
- ✅ Identifica vulnerabilidades de seguridad (OWASP Top 10)
- ✅ Sugerencias arquitecturales profundas
- ✅ Análisis de performance (N+1, memory leaks)
- ✅ Razonamiento sobre contexto entre archivos
- ✅ Balance perfecto: calidad vs costo

**Costo**: ~$3/1M tokens (~$0.30 por review típico)
**Velocidad**: Rápida (suficiente para workflow normal)

### ⚠️ Haiku (Solo para Lint/Style)

**Usar Haiku SOLO si**:
- Necesitas feedback ultra-rápido (pre-commit)
- Solo quieres verificar estilo/formateo
- Cambios muy triviales (typos, comments)
- Prioridad absoluta en costo

**NO usar Haiku para**:
- ❌ Code review real (bugs, seguridad)
- ❌ Features nuevas
- ❌ Refactoring
- ❌ Código crítico

## 📋 Configuración Sonnet (RECOMENDADO)

### Agente de Code Review Completo

**Archivo**: `~/.claude/agents/code-reviewer.json`

```json
{
  "name": "code-reviewer",
  "description": "Expert code reviewer using Sonnet - comprehensive analysis of bugs, security, architecture, and best practices",
  "model": "sonnet",
  "tools": [
    "Read",
    "Glob",
    "Grep",
    "Bash"
  ],
  "systemPrompt": "You are a senior software engineer conducting thorough code reviews with 15+ years of experience.\n\n## REVIEW CATEGORIES:\n\n### 1. SECURITY (Highest Priority) 🔴\n- SQL injection vulnerabilities\n- XSS (Cross-Site Scripting)\n- CSRF (Cross-Site Request Forgery)\n- Command injection\n- Authentication/authorization bypasses\n- Sensitive data exposure (passwords, tokens, PII)\n- Insecure dependencies or outdated libraries\n- Hardcoded credentials\n- Weak cryptography\n- Path traversal vulnerabilities\n\n### 2. BUGS AND LOGIC ERRORS 🟡\n- Null/undefined pointer exceptions\n- Off-by-one errors\n- Race conditions and concurrency issues\n- Incorrect conditionals or logic\n- Infinite loops or recursion\n- Resource leaks (connections, file handles)\n- Memory leaks\n- Incorrect data type usage\n- Timezone and date handling issues\n\n### 3. PERFORMANCE 🟡\n- N+1 query problems\n- Inefficient algorithms (O(n²) when O(n) possible)\n- Missing database indexes\n- Excessive memory allocation\n- Blocking operations in async contexts\n- Unnecessary network calls\n- Cache misuse\n\n### 4. ARCHITECTURE AND DESIGN 🟢\n- SOLID principles violations\n- God objects / classes doing too much\n- Tight coupling\n- Missing abstractions\n- Inappropriate design patterns\n- Separation of concerns\n- Code duplication (DRY)\n\n### 5. CODE QUALITY 🟢\n- Readability and clarity\n- Meaningful variable/function names\n- Appropriate comments (when needed)\n- Consistent code style\n- Proper error messages\n- Magic numbers (should be constants)\n\n### 6. TESTING 🟢\n- Missing test coverage for critical paths\n- Edge cases not tested\n- Missing integration tests\n- Test quality and assertions\n\n## OUTPUT FORMAT:\n\n```markdown\n## Summary\n[One paragraph overview of changes reviewed]\n\n## Critical Issues 🔴\n[Security vulnerabilities and critical bugs - MUST FIX]\n\n### Issue 1: [Title]\n**File**: path/to/file.ext:line\n**Severity**: Critical\n**Description**: [What's wrong]\n**Impact**: [What could happen]\n**Fix**: [How to fix with code example]\n\n## Important Issues 🟡\n[Significant bugs, performance problems - SHOULD FIX]\n\n### Issue 2: [Title]\n**File**: path/to/file.ext:line\n**Severity**: Important\n**Description**: [What's wrong]\n**Recommendation**: [Suggested fix]\n\n## Suggestions 🟢\n[Improvements, refactoring, best practices - NICE TO HAVE]\n\n### Suggestion 1: [Title]\n**File**: path/to/file.ext:line\n**Benefit**: [Why this helps]\n**Example**: [Code example]\n\n## Positive Aspects ✅\n[Things done well - encourage good practices]\n\n## Testing Recommendations 🧪\n- [ ] Test case 1\n- [ ] Test case 2\n\n## Conclusion\n[Final verdict: Approve / Request Changes / Approve with Comments]\n```\n\n## RULES:\n1. Be constructive and specific\n2. Provide code examples for fixes\n3. Prioritize security and correctness over style\n4. Reference specific files and line numbers\n5. Explain WHY something is a problem, not just WHAT\n6. Acknowledge good code and patterns\n7. Suggest tests for edge cases\n8. Consider maintainability and future changes"
}
```

## 🚀 Uso del Agente

### Caso 1: Review de Branch/PR

```
Revisa todos los cambios en mi branch actual vs main.
Enfócate en seguridad y bugs críticos.
```

**Agente ejecuta**:
```bash
git diff main...HEAD  # Ver cambios
# Lee archivos modificados
# Analiza cada cambio
# Genera reporte completo
```

### Caso 2: Review de Archivo

```
Revisa src/services/payment_processor.rb
Es código crítico, busca vulnerabilidades y bugs
```

### Caso 3: Review Pre-Commit (Quick con Haiku)

```
Quick lint de mis archivos staged.
Solo estilo y errores obvios, tengo prisa.
```

Usa agente `code-linter` (Haiku) para feedback en segundos.

### Caso 4: Security Audit Específico

```
Security audit de:
- src/controllers/users_controller.rb
- src/models/user.rb

Busca: SQL injection, auth bypass, data exposure
```

## 📝 Ejemplos de Review

### Ejemplo 1: Bug Detectado (N+1 Query)

**Código**:
```ruby
def show_users_with_posts
  users = User.all
  users.each do |user|
    puts "#{user.name}: #{user.posts.count} posts"
  end
end
```

**Review del Agente (Sonnet)**:
```markdown
## Important Issues 🟡

### N+1 Query Performance Problem

**File**: app/services/user_service.rb:3-5
**Severity**: Important
**Description**: The method triggers N+1 queries. For each user, it executes
a separate query to count posts.

**Impact**: With 1000 users, this executes 1001 database queries.
Response time scales linearly with user count.

**Fix**:
```ruby
def show_users_with_posts
  users = User.includes(:posts)  # Eager load posts
  users.each do |user|
    puts "#{user.name}: #{user.posts.size} posts"  # Use .size not .count
  end
end
```

**Testing Recommendation**:
- [ ] Add performance test with 100+ users
- [ ] Verify query count with ActiveRecord::QueryCounter
```

### Ejemplo 2: Vulnerabilidad de Seguridad

**Código**:
```ruby
def search
  query = params[:q]
  @results = User.where("name LIKE '%#{query}%'")
end
```

**Review del Agente (Sonnet)**:
```markdown
## Critical Issues 🔴

### SQL Injection Vulnerability

**File**: app/controllers/search_controller.rb:3
**Severity**: CRITICAL 🚨
**Description**: Direct string interpolation in SQL WHERE clause allows
SQL injection attacks.

**Impact**: Attacker can:
- Extract entire database
- Delete data
- Bypass authentication
- Execute arbitrary SQL

**Exploit Example**:
```
GET /search?q=%' OR '1'='1' --
# Executes: SELECT * FROM users WHERE name LIKE '%%' OR '1'='1' --%'
# Returns ALL users
```

**Fix** (REQUIRED before merge):
```ruby
def search
  query = params[:q]
  @results = User.where("name LIKE ?", "%#{query}%")  # Use parameterized query
end
```

**Better Fix** (with sanitization):
```ruby
def search
  query = params[:q].to_s.strip
  return [] if query.blank?

  @results = User.where("name ILIKE ?", "%#{sanitize_sql_like(query)}%")
end
```

**Testing Required**:
- [ ] Test with malicious input: `' OR '1'='1' --`
- [ ] Test with SQL keywords: `DROP TABLE`, `UNION SELECT`
- [ ] Test with special chars: `%`, `_`, `'`, `"`

**Conclusion**: 🔴 REQUEST CHANGES - Critical security fix required
```

### Ejemplo 3: Quick Lint (Haiku)

**Código**:
```ruby
def process
  x = 10
  if x > 5
      puts "big"
  end
end
```

**Review del Agente (Haiku)**:
```markdown
## Style Issues

### Inconsistent Indentation
**File**: service.rb:4
Use 2 spaces, not 4 for if block body.

### Non-descriptive Variable Name
**File**: service.rb:2
`x` should be renamed to something meaningful like `threshold` or `value`.

## Quick Fix
```ruby
def process
  threshold = 10
  if threshold > 5
    puts "big"
  end
end
```

**Conclusion**: ✅ Minor style issues only
```

## 🔄 Workflows de Integración

### Workflow 1: Pre-Commit Hook

```bash
#!/bin/bash
# .git/hooks/pre-commit

echo "Running code review..."

# Get staged files
STAGED=$(git diff --cached --name-only --diff-filter=ACM)

# Review with appropriate agent
if echo "$STAGED" | grep -q "controller\|auth\|payment"; then
  # Critical files: use Sonnet
  claude-code task code-reviewer "Review staged files focusing on security"
else
  # Other files: quick lint with Haiku
  claude-code task code-linter "Quick lint of staged files"
fi

# Exit 1 if critical issues found
```

### Workflow 2: GitHub Action (CI/CD)

```yaml
name: Automated Code Review

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
        with:
          fetch-depth: 0

      - name: Code Review with Sonnet
        run: |
          claude-code task code-reviewer \
            "Review PR changes. Focus on security, bugs, and architecture."

      - name: Post review as PR comment
        uses: actions/github-script@v6
        with:
          script: |
            // Post agent output as PR comment
```

### Workflow 3: VS Code Extension

Si usas VS Code con Claude Code:

```
Right-click on file → "Claude Code Review" → Invoca agente
```

## 🐛 Troubleshooting

### Agente da false positives

**Solución**: Refinar systemPrompt con contexto del proyecto:

```json
{
  "systemPrompt": "[Base prompt]\n\nProject-specific context:\n- Using Rails 7.1 with strong parameters\n- Authorization handled by Pundit gem\n- SQL injection protected by ActiveRecord\n\nDon't flag these as issues if properly used."
}
```

### Review demasiado superficial (si usas Haiku)

**Solución**: Cambiar a Sonnet para reviews importantes:

```
Usa el agente code-reviewer (Sonnet) en lugar de code-linter
```

### Review demasiado lento

**Solución**: Limita scope:

```
Revisa solo los archivos modificados en último commit,
no todo el proyecto
```

## 💰 Análisis de Costo

### Estimación por Review

| Tamaño de Review | Haiku | Sonnet | Opus |
|------------------|-------|--------|------|
| **Small** (1-2 files, 100 líneas) | $0.01 | $0.15 | $0.75 |
| **Medium** (5-10 files, 500 líneas) | $0.05 | $0.60 | $3.00 |
| **Large** (20+ files, 2000 líneas) | $0.20 | $2.40 | $12.00 |

### ¿Vale la Pena Sonnet?

**Sí, porque**:
- Un bug en producción cuesta >> $2.40
- Un security breach cuesta >> $100
- Tiempo de debugging de bugs no detectados >> costo de Sonnet
- Quality assurance preventiva es más barata que fixing bugs

### Estrategia Híbrida (Óptimo)

```
1. Quick lint con Haiku (pre-commit) - $0.01
2. Review con Sonnet (pre-merge) - $0.60
3. Security audit con Opus (si crítico) - $3.00
```

**Costo total**: ~$3.61 por feature
**Ahorro**: Prevenir 1 bug = ROI infinito

## 📋 Configuración Completa

### Agente 1: Code Reviewer (Sonnet) - Principal

**Archivo**: `~/.claude/agents/code-reviewer.json`

```json
{
  "name": "code-reviewer",
  "description": "Comprehensive code reviewer using Sonnet - detects bugs, security issues, performance problems, and architectural concerns",
  "model": "sonnet",
  "tools": ["Read", "Glob", "Grep", "Bash"],
  "systemPrompt": "You are a senior software engineer with 15+ years of experience conducting thorough code reviews.\n\n## REVIEW PRIORITIES (in order):\n\n### 1. SECURITY 🔴 (Highest Priority)\nCheck for OWASP Top 10:\n- SQL Injection (string interpolation in queries)\n- XSS (unescaped user input in views)\n- CSRF (missing tokens)\n- Authentication bypass (weak auth logic)\n- Authorization issues (missing permission checks)\n- Sensitive data exposure (logging passwords, tokens)\n- Insecure deserialization\n- Using components with known vulnerabilities\n- Insufficient logging and monitoring\n- Command injection (unsafe system calls)\n\nExample checks:\n- Ruby: User.where(\"name = '#{params[:name]}'\") ← SQL INJECTION\n- JavaScript: innerHTML = userInput ← XSS\n- Java: Runtime.exec(\"rm \" + filename) ← COMMAND INJECTION\n\n### 2. CRITICAL BUGS 🔴\n- Null/undefined pointer exceptions\n- Array out of bounds\n- Division by zero\n- Infinite loops or unbounded recursion\n- Resource leaks (unclosed connections, files)\n- Memory leaks (circular references, event listeners)\n- Deadlocks in concurrent code\n- Data corruption risks\n\n### 3. PERFORMANCE 🟡\n- N+1 query problems (eager loading needed)\n- Inefficient algorithms (nested loops, O(n²))\n- Missing database indexes\n- Large data loaded into memory\n- Synchronous blocking in async context\n- Excessive API calls\n- Cache not utilized\n\n### 4. CORRECTNESS 🟡\n- Logic errors\n- Edge cases not handled\n- Error handling missing or incorrect\n- Validation missing\n- Incorrect assumptions\n- Data consistency issues\n\n### 5. BEST PRACTICES 🟢\n- SOLID principles\n- DRY (Don't Repeat Yourself)\n- YAGNI (You Aren't Gonna Need It)\n- Proper abstraction levels\n- Code readability\n- Meaningful names\n- Appropriate comments\n- Separation of concerns\n\n### 6. TESTING 🟢\n- Missing test coverage\n- Edge cases not tested\n- Integration tests needed\n- Test quality and assertions\n- Mocking appropriate\n\n## OUTPUT FORMAT:\n\n```markdown\n## 📊 Review Summary\n\n**Files Reviewed**: X files\n**Lines Changed**: +XX -YY\n**Severity**: 🔴 Critical / 🟡 Important / 🟢 Minor\n\n**Verdict**: ✅ Approve / ⚠️ Approve with Comments / 🔴 Request Changes\n\n---\n\n## 🔴 Critical Issues (MUST FIX)\n\n### 1. [Issue Title]\n\n**Location**: `path/to/file.ext:42`\n**Category**: Security / Bug\n**Severity**: Critical\n\n**Problem**:\n[Detailed explanation]\n\n**Impact**:\n[What could go wrong]\n\n**Code**:\n```language\n[Problematic code]\n```\n\n**Fix**:\n```language\n[Corrected code]\n```\n\n**Testing**:\n- [ ] Test case 1\n- [ ] Test case 2\n\n---\n\n## 🟡 Important Issues (SHOULD FIX)\n\n[Same format as above]\n\n---\n\n## 🟢 Suggestions (NICE TO HAVE)\n\n[Same format but less critical]\n\n---\n\n## ✅ Positive Aspects\n\n- Well-structured code\n- Good error handling\n- Clear naming\n- [Other good things]\n\n---\n\n## 🧪 Testing Recommendations\n\n### Missing Test Coverage\n- [ ] Test edge case: empty input\n- [ ] Test edge case: very large input\n- [ ] Test error handling: network failure\n\n### Recommended Integration Tests\n- [ ] Full user flow: signup → login → action\n\n---\n\n## 📈 Code Quality Metrics\n\n- Complexity: Low / Medium / High\n- Maintainability: Good / Acceptable / Needs Work\n- Test Coverage: XX% (estimated)\n\n---\n\n## 🎯 Priority Actions\n\n1. [Highest priority fix]\n2. [Second priority]\n3. [Third priority]\n\n**Timeline**: [Estimate effort - Quick / Medium / Extensive]\n```\n\n## IMPORTANT NOTES:\n- Always provide specific file:line references\n- Include code examples for both problem and solution\n- Explain the 'why' not just the 'what'\n- Be constructive and educational\n- Acknowledge good code patterns\n- Consider project context and framework conventions\n- Prioritize actionable feedback\n- If unsure, say so (don't make up issues)"
}
```

### Agente 2: Quick Linter (Haiku) - Opcional

**Archivo**: `~/.claude/agents/code-linter.json`

```json
{
  "name": "code-linter",
  "description": "Fast style and formatting checker using Haiku - for quick pre-commit validation",
  "model": "haiku",
  "tools": ["Read", "Glob", "Grep"],
  "systemPrompt": "You are a code style checker for fast, pre-commit feedback.\n\nFocus ONLY on:\n- Code formatting and indentation\n- Naming conventions\n- Obvious syntax errors\n- Style guide violations\n- Simple best practice violations\n\nDO NOT analyze:\n- Complex security vulnerabilities\n- Architectural decisions\n- Performance optimization (unless obvious)\n- Deep logic errors\n\nProvide quick, actionable feedback in under 10 seconds.\n\nOUTPUT FORMAT:\n\n## Style Issues\n\n### Issue 1: [Title]\n**File**: path:line\n**Fix**: [One-line fix suggestion]\n\n## Summary\n✅ Ready to commit / ⚠️ Fix style issues first\n\nKeep it brief and fast."
}
```

## 🎯 Uso Recomendado por Escenario

### Feature Nueva → Sonnet

```
Revisa mi implementación de user authentication.
Files: src/auth/*.rb, tests/auth/*_spec.rb

Busca: seguridad, bugs, tests faltantes
```

### Bug Fix → Sonnet

```
Revisa mi fix del bug de memory leak.
File: src/services/cache_manager.rb

Verifica que el fix es correcto y no introduce nuevos bugs
```

### Refactoring → Sonnet

```
Revisa mi refactoring de UserService.
Antes: app/services/user_service_old.rb
Después: app/services/user_service.rb

Verifica que la lógica es equivalente y el diseño mejoró
```

### Typo/Comment Fix → Haiku (code-linter)

```
Quick check de mi fix de typos.
Solo cambié comentarios y nombres de variables.
```

### Security-Critical Code → Opus (si es MUY crítico)

```
Security audit exhaustivo de payment_processor.rb
Este código maneja pagos reales, necesito análisis profundo.
```

## 📊 Comparativa Final

### Code Review Quality

| Aspecto | Haiku | Sonnet ⭐ | Opus |
|---------|-------|-----------|------|
| **Bugs obvios** | ✅ | ✅ | ✅ |
| **Bugs sutiles** | ❌ | ✅ | ✅ |
| **SQL injection** | ⚠️ Básico | ✅ Detecta | ✅ Exhaustivo |
| **N+1 queries** | ❌ | ✅ | ✅ |
| **Race conditions** | ❌ | ✅ | ✅ |
| **Arquitectura** | ❌ | ✅ | ✅ |
| **Edge cases** | ❌ | ✅ | ✅ |
| **Costo** | 💰 | 💰💰 | 💰💰💰 |
| **Velocidad** | ⚡⚡⚡ | ⚡⚡ | ⚡ |

### Recomendación por Uso

| Caso | Modelo | Razón |
|------|--------|-------|
| **Review general** | **Sonnet** ⭐ | Best balance |
| **Pre-commit lint** | Haiku | Feedback rápido |
| **Security audit** | Opus | No hay margen de error |
| **Quick check** | Haiku | Speed over depth |
| **Production code** | Sonnet/Opus | Quality matters |

## 🚀 Comandos de Ejemplo

### Con Sonnet (Recomendado)

```bash
# Review de PR
claude-code task code-reviewer "Review PR #123 changes"

# Review de archivo
claude-code task code-reviewer "Review src/auth/login.rb for security issues"

# Review de commit
claude-code task code-reviewer "Review last commit"

# Review de branch
claude-code task code-reviewer "Review all changes in feature/auth-improvements vs main"
```

### Con Haiku (Quick Lint)

```bash
# Pre-commit quick check
claude-code task code-linter "Quick lint of staged files"

# Style check
claude-code task code-linter "Check code style in src/"
```

## ✅ Checklist de Setup

- [ ] Crear `~/.claude/agents/code-reviewer.json` (Sonnet)
- [ ] Opcional: Crear `~/.claude/agents/code-linter.json` (Haiku)
- [ ] Probar con archivo de ejemplo
- [ ] Verificar que detecta SQL injection
- [ ] Verificar que detecta N+1 queries
- [ ] Verificar formato de output
- [ ] Integrar en workflow (pre-commit, CI/CD)

## 🎯 Mi Recomendación Final

**Usa Sonnet para code review**. Los $3/1M tokens adicionales valen absolutamente la pena porque:

1. **Previene bugs costosos** ($2 review < $1000 debugging)
2. **Detecta seguridad** (un breach cuesta >> $3)
3. **Mejora calidad** (aprendes de las sugerencias)
4. **Más rápido que humano** (review en minutos vs horas)

**Haiku solo para**:
- Lint checks pre-commit (speed matters)
- Cambios triviales (typos, comments)
- Quick feedback loop durante desarrollo

**Estrategia híbrida óptima**:
```
Dev loop: Haiku (fast iteration)
    ↓
Pre-PR: Sonnet (thorough review)
    ↓
Critical: Opus (if auth/payment/security)
```

---

**Última actualización**: 2026-01-27
**Modelo recomendado**: Sonnet (balance perfecto)
**Costo típico**: $0.30-$2.00 por review (excelente ROI)
**Setup**: Claude Code CLI agent system
