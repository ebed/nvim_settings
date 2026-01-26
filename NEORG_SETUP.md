# Configuración de Neorg

## Problema Identificado

Neorg requiere un parser de Treesitter específico para archivos `.norg` que debe instalarse manualmente.

## Solución Paso a Paso

### 1. Abrir Neovim
```bash
nvim
```

### 2. Instalar el Parser de Neorg

Ejecuta el siguiente comando dentro de Neovim:
```vim
:Neorg sync-parsers
```

Si ves errores, intenta:
```vim
:Lazy reload neorg
:Neorg sync-parsers
```

### 3. Verificar Instalación

Después de que termine la instalación del parser:
```vim
:checkhealth neorg
```

### 4. Habilitar Core.Concealer (Opcional)

Una vez que el parser esté instalado exitosamente, puedes habilitar el módulo `core.concealer` para tener iconos y formato bonito:

Edita `/Users/ralbertomerinocolipe/.config/nvim/lua/plugins/neorg.lua` y descomenta estas líneas:
```lua
["core.concealer"] = {
  config = {
    icon_preset = "basic",
  },
},
```

Luego reinicia Neovim:
```vim
:Lazy reload neorg
:qa
nvim
```

## Uso de Neorg

### Comandos Básicos

#### Workspaces
```vim
:Neorg workspace notes      " Ir al workspace de notas
:Neorg workspace work       " Ir al workspace de trabajo
:Neorg index               " Abrir index.norg del workspace actual
```

#### Crear Notas
```vim
:Neorg journal today       " Crear nota del día
:Neorg journal yesterday   " Nota de ayer
:Neorg journal tomorrow    " Nota de mañana
```

### Keybindings (Default)

En archivos `.norg`:

#### Navegación
- `<CR>` en un enlace - Seguir enlace
- `<M-CR>` - Crear enlace desde palabra bajo cursor
- `<Tab>` - Siguiente heading
- `<S-Tab>` - Heading anterior

#### Listas y TODOs
- `<C-Space>` - Toggle TODO estado
- `<M-t>` - Crear TODO
- `<M-l>` - Crear lista

#### Formatting
- `<M-i>` - Itálica
- `<M-b>` - Negrita
- `<M-c>` - Código inline

## Estructura de Workspaces

```
~/notes/
├── index.norg          # Índice principal
└── ...                 # Tus notas

~/work-notes/
├── index.norg          # Índice de trabajo
└── ...                 # Notas de trabajo
```

## Sintaxis Básica de Norg

### Headings
```norg
* Heading 1
** Heading 2
*** Heading 3
```

### Listas
```norg
- Item de lista
-- Sub-item
--- Sub-sub-item
```

### TODOs
```norg
- ( ) TODO sin hacer
- (x) TODO completado
- (!) TODO urgente
- (?) TODO con pregunta
```

### Enlaces
```norg
{:archivo:}              # Enlace a archivo.norg
{:ruta/archivo:}         # Enlace con ruta
{https://ejemplo.com}    # Enlace web
```

### Formato de Texto
```norg
/Itálica/
*Negrita*
`Código`
```

### Citas
```norg
> Esta es una cita
>> Cita anidada
```

### Código
```norg
@code lang
código aquí
@end
```

## Troubleshooting

### Parser No Se Instala

Si `:Neorg sync-parsers` falla:

1. Verifica que tienes las herramientas de compilación:
   ```bash
   xcode-select --install
   ```

2. Reinstala Neorg:
   ```vim
   :Lazy clean neorg
   :Lazy install neorg
   :Neorg sync-parsers
   ```

3. Verifica logs:
   ```vim
   :messages
   ```

### Errors de Treesitter

Si ves errores de "Parser could not be created":
- Asegúrate de que el parser se instaló: `:Neorg sync-parsers`
- Verifica que nvim-treesitter está actualizado: `:Lazy update nvim-treesitter`
- Revisa `:checkhealth neorg`

### Workspace No Encontrado

Si ves "attempt to index a nil value":
- Asegúrate de que los directorios existen:
  ```bash
  mkdir -p ~/notes ~/work-notes
  ```
- Crea archivos index:
  ```bash
  touch ~/notes/index.norg ~/work-notes/index.norg
  ```

## Recursos

- [Neorg Wiki](https://github.com/nvim-neorg/neorg/wiki)
- [Neorg Tutorial](https://github.com/nvim-neorg/neorg/wiki/Tutorial)
- [Sintaxis Norg](https://github.com/nvim-neorg/neorg/wiki/Norg-Syntax)

## Estado Actual

✅ Directorios creados: `~/notes`, `~/work-notes`
✅ Archivos index creados
✅ Configuración base instalada
⚠️  Parser pendiente de instalación manual
⚠️  Core.concealer deshabilitado temporalmente

Una vez que ejecutes `:Neorg sync-parsers` exitosamente, podrás usar Neorg completamente.
