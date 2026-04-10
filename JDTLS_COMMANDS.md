# Comandos de JDTLS en Neovim

Este documento explica los comandos disponibles para trabajar con Java en Neovim utilizando el Language Server JDTLS.

## Comandos disponibles

- `JavaInfo` - Muestra información de diagnóstico sobre la configuración de Java y JDTLS
- `JavaClean` - Limpia el workspace de JDTLS (útil para solucionar problemas)
- `JavaRestart` - Reinicia el servidor JDTLS para el buffer actual
- `JavaNewProject` - Crea un nuevo proyecto Java con estructura Maven
- `JavaOrganizeImports` - Organiza las importaciones del archivo Java actual

## Atajos de teclado en archivos Java

- `<leader>jo` - Organizar imports
- `<leader>jv` - Extraer variable
- `<leader>jc` - Extraer constante
- `<leader>jm` - Extraer método
- `<leader>jt` - Ejecutar test del método más cercano
- `<leader>jT` - Ejecutar tests de la clase actual

### Debugging con DAP

- `<leader>jb` - Alternar punto de interrupción
- `<leader>jB` - Punto de interrupción condicional
- `<leader>jd` - Continuar ejecución
- `<leader>jn` - Step over
- `<leader>ji` - Step into
- `<leader>jo` - Step out
- `<leader>ju` - Alternar interfaz de DAP

## Comandos del servidor JDTLS

Se han configurado los siguientes comandos LSP para que funcionen correctamente:

- `java.edit.organizeImports` - Usado por extensiones como Copilot
- `java.action.organizeImports` - Comando estándar de JDTLS

## Resolución de problemas comunes

### Error: "Unknown command: java.edit.organizeImports"

Si aparece este error cuando intentas organizar imports (especialmente desde Copilot), puedes:

1. Ejecutar `:JavaRestart` para reiniciar el servidor JDTLS
2. Si el problema persiste, verificar que el servidor JDTLS está funcionando con `:JavaInfo`

### Otros problemas con JDTLS

Si encuentras otros problemas con el servidor JDTLS, prueba los siguientes pasos:

1. Reinicia el servidor con `:JavaRestart`
2. Si el problema persiste, limpia el workspace con `:JavaClean` y reinicia Neovim
3. Verifica que tu proyecto Java tenga una estructura correcta (pom.xml, build.gradle, etc.)

## Configuración personalizada

La configuración de JDTLS se encuentra en:
- `/Users/ralbertomerinocolipe/.config/nvim/lua/plugins/jdtls-unified.lua`

Este archivo contiene:
- Configuración del JDK
- Soporte para Lombok
- Configuración de debugging
- Comandos personalizados
- Handlers para comandos de workspace