# Neotest Guide - Test Runner Integrado

Guía completa para usar Neotest con Ruby, Elixir y Java.

---

## 🔧 Instalación de Adapters

### Paso 1: Sincronizar Plugins

```vim
:Lazy sync
```

Esto instalará los siguientes adapters:
- ✅ **neotest-rspec** - Ruby RSpec tests
- ✅ **neotest-minitest** - Ruby Minitest
- ✅ **neotest-elixir** - Elixir ExUnit tests
- ✅ **neotest-java** - Java (Gradle/Maven) tests

### Paso 2: Verificar Instalación

```vim
:checkhealth neotest
```

### Paso 3: Reiniciar Neovim

```bash
nvim
```

---

## 📋 Requisitos por Lenguaje

### Ruby (RSpec)
- ✅ Archivo debe terminar en `_spec.rb`
- ✅ `bundle exec rspec` disponible
- ✅ Gemfile con `rspec` instalado

**Estructura típica**:
```
project/
├── Gemfile
├── spec/
│   ├── spec_helper.rb
│   └── models/
│       └── user_spec.rb
```

### Ruby (Minitest)
- ✅ Archivo debe terminar en `_test.rb`
- ✅ Minitest instalado

### Elixir (ExUnit)
- ✅ Archivo debe terminar en `_test.exs`
- ✅ `mix test` disponible
- ✅ Proyecto Mix configurado

**Estructura típica**:
```
project/
├── mix.exs
├── test/
│   ├── test_helper.exs
│   └── project_test.exs
```

### Java (JUnit)
- ✅ Archivo debe terminar en `Test.java`
- ✅ Gradle o Maven configurado
- ✅ JUnit en dependencies

**Estructura típica**:
```
project/
├── build.gradle o pom.xml
├── src/
│   └── test/
│       └── java/
│           └── UserTest.java
```

---

## 🎯 Comandos de Neotest

### Comandos Básicos

```vim
:Neotest summary              " Mostrar panel de tests
:Neotest run                  " Correr test bajo cursor
:Neotest run file             " Correr todos los tests del archivo
:Neotest run last             " Re-correr último test
:Neotest output               " Ver output del test
:Neotest output-panel         " Panel de output
:Neotest stop                 " Detener tests en ejecución
```

### Navegación en Summary

```vim
:Neotest summary toggle       " Toggle panel
:Neotest summary open         " Abrir panel
:Neotest summary close        " Cerrar panel
```

Dentro del summary:
- `<CR>` - Expandir/colapsar
- `o` - Abrir output del test
- `t` - Toggle panel
- `r` - Correr test seleccionado
- `d` - Debug test seleccionado

---

## ⌨️  Keymaps Configurados

Los siguientes keymaps están definidos en `lua/config/mappings/testing.lua`:

```vim
<leader>Te      " Run test (nearest)
<leader>Ta      " Run test suite (all tests)
<leader>Tc      " Run test current file
<leader>Ts      " Neotest summary
```

---

## 🐛 Troubleshooting

### Problema: "Parsing tests..." No Termina

**Causas posibles**:

1. **Adapter no instalado**:
   ```vim
   :Lazy sync
   :Lazy reload neotest
   ```

2. **No detecta el tipo de test**:
   - Verifica nombre de archivo:
     - Ruby RSpec: `*_spec.rb`
     - Ruby Minitest: `*_test.rb`
     - Elixir: `*_test.exs`
     - Java: `*Test.java`

3. **Proyecto no configurado correctamente**:
   - Ruby: Debe tener `Gemfile` y `spec/` o `test/`
   - Elixir: Debe tener `mix.exs`
   - Java: Debe tener `build.gradle` o `pom.xml`

4. **Treesitter parser faltante**:
   ```vim
   :TSInstall ruby elixir java
   ```

### Problema: Tests No Se Ejecutan

**Ruby**:
```bash
# Verificar bundle
bundle exec rspec --version

# En el proyecto
cd /path/to/project
bundle install
```

**Elixir**:
```bash
# Verificar mix
mix test --version

# Compilar proyecto
mix compile
```

**Java**:
```bash
# Verificar gradle/maven
./gradlew test --version
# o
mvn test --version
```

### Problema: Output No Se Muestra

```vim
:Neotest output-panel
```

Si no funciona:
```vim
:messages
```

Para ver errores del adapter:
```vim
:lua print(vim.inspect(require("neotest").state))
```

### Problema: Adapter No Carga

Verifica manualmente:
```vim
:lua print(vim.inspect(require("neotest").setup.adapters))
```

Si ves warning de adapter no encontrado:
```vim
:Lazy sync
:Lazy reload neotest-rspec
:qa
nvim
```

---

## 📊 Iconos en Summary

| Icono | Estado |
|-------|--------|
| ✓ | Test pasó |
| ● | Test corriendo |
| ✗ | Test falló |
| ○ | Test skipped |
| ? | Desconocido |

---

## 🔍 Workflow Recomendado

### 1. Abrir Archivo de Test

```bash
nvim spec/models/user_spec.rb
```

### 2. Abrir Summary

```vim
<leader>Ts
```

### 3. Correr Test Individual

Posiciona el cursor en un test:
```ruby
it "validates email format" do
  # ...
end
```

Luego:
```vim
<leader>Te
```

### 4. Ver Output

Si falla:
```vim
:Neotest output
```

### 5. Correr Todo el Archivo

```vim
<leader>Tc
```

### 6. Correr Todo el Suite

```vim
<leader>Ta
```

---

## 🎨 Personalización

### Cambiar Iconos

Edita `lua/plugins/neotest.lua`:
```lua
icons = {
  passed = "✅",
  running = "🏃",
  failed = "❌",
  skipped = "⏭️",
}
```

### Abrir Output Automáticamente

```lua
output = {
  enabled = true,
  open_on_run = true,  -- Cambiar a true
}
```

### Deshabilitar Virtual Text

```lua
status = {
  enabled = true,
  virtual_text = false,  -- Cambiar a false
  signs = true,
}
```

---

## 💡 Tips y Trucos

### 1. Correr Tests de un Directorio

En el summary, selecciona el directorio y presiona `r`.

### 2. Watch Mode (Re-correr en Cambios)

Aún no soportado nativamente en Neotest, pero puedes usar:

**Ruby (Guard)**:
```bash
bundle exec guard
```

**Elixir (Mix)**:
```bash
mix test.watch
```

### 3. Debug Tests

Para Ruby con DAP configurado:
```vim
<leader>db  " Set breakpoint
<leader>Te  " Run test with debugger
```

### 4. Ver Logs de Adapter

```bash
tail -f ~/.local/state/nvim/neotest.log
```

### 5. Filtrar Tests

En RSpec:
```ruby
it "test", :focus do  # Solo corre este test
end
```

En Elixir:
```elixir
@tag :focus
test "specific test" do
end
```

Luego configura en config:
```elixir
# test_helper.exs
ExUnit.configure(exclude: [:test], include: [:focus])
```

---

## 🚀 Ejemplos Prácticos

### Ejemplo Ruby RSpec

**Archivo**: `spec/models/user_spec.rb`
```ruby
require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    it 'validates presence of email' do
      user = User.new(email: nil)
      expect(user).not_to be_valid
    end

    it 'validates email format' do
      user = User.new(email: 'invalid')
      expect(user).not_to be_valid
    end
  end
end
```

**Workflow**:
1. Abrir archivo
2. `<leader>Ts` - Ver summary
3. `<leader>Te` - Correr test bajo cursor
4. `<leader>Tc` - Correr todos los tests del archivo

### Ejemplo Elixir ExUnit

**Archivo**: `test/myapp_test.exs`
```elixir
defmodule MyAppTest do
  use ExUnit.Case
  doctest MyApp

  test "greets the world" do
    assert MyApp.hello() == :world
  end
end
```

**Workflow**:
1. `mix compile` primero
2. Abrir archivo en nvim
3. `<leader>Ts`
4. `<leader>Ta` - Correr suite completo

### Ejemplo Java JUnit

**Archivo**: `src/test/java/UserTest.java`
```java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class UserTest {
    @Test
    void testValidEmail() {
        User user = new User("test@example.com");
        assertTrue(user.isValid());
    }

    @Test
    void testInvalidEmail() {
        User user = new User("invalid");
        assertFalse(user.isValid());
    }
}
```

**Workflow**:
1. `./gradlew build` primero
2. Abrir archivo
3. `<leader>Ts`
4. `<leader>Te` - Correr test individual

---

## 📚 Referencias

- [Neotest GitHub](https://github.com/nvim-neotest/neotest)
- [Neotest RSpec](https://github.com/olimorris/neotest-rspec)
- [Neotest Elixir](https://github.com/jfpedroza/neotest-elixir)
- [Neotest Java](https://github.com/rcasia/neotest-java)

---

## 🐛 Reportar Problemas

Si encuentras problemas:

1. Verifica logs:
   ```vim
   :messages
   :checkhealth neotest
   ```

2. Verifica adapter:
   ```vim
   :lua print(vim.inspect(require("neotest").state.adapter_ids))
   ```

3. Si persiste, reporta en este archivo con:
   - Lenguaje (Ruby/Elixir/Java)
   - Tipo de test (RSpec/Minitest/ExUnit/JUnit)
   - Estructura de proyecto
   - Output de `:checkhealth neotest`

---

**Estado**: Configurado para Ruby (RSpec + Minitest), Elixir (ExUnit) y Java (JUnit)
**Keymaps**: Ver `KEYMAPS.md` sección Testing
