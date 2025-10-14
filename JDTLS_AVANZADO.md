# Configuración Avanzada JDTLS para Neovim

Este documento explica cómo sacar el máximo provecho de la configuración avanzada de JDTLS para desarrollo Java en Neovim.

## Características Incluidas

- ✅ Autocompleción inteligente y contextual
- ✅ Diagnósticos en tiempo real
- ✅ Soporte completo para Lombok
- ✅ Navegación de código y refactorización
- ✅ Debugging integrado con DAP
- ✅ Formateo automático del código
- ✅ Organización automática de imports
- ✅ Creación de proyectos Java
- ✅ Code Lens para implementaciones y referencias
- ✅ Keybindings específicos para Java

## Comandos Disponibles

### Comandos Generales

| Comando | Descripción |
| ------- | ----------- |
| `:JavaInfo` | Muestra información sobre la configuración Java y JDTLS |
| `:JavaClean` | Limpia el workspace y reinicia JDTLS |
| `:LombokStatus` | Verifica el estado de Lombok |
| `:JavaNewProject <nombre>` | Crea un nuevo proyecto Java Maven |

### Keybindings (en archivos Java)

| Keybinding | Descripción |
| ---------- | ----------- |
| `<leader>jo` | Organizar imports |
| `<leader>jv` | Extraer variable |
| `<leader>jc` | Extraer constante |
| `<leader>jm` | Extraer método |
| `<leader>jt` | Test método más cercano |
| `<leader>jT` | Test clase |

### Keybindings para Debugging

| Keybinding | Descripción |
| ---------- | ----------- |
| `<leader>jb` | Alternar breakpoint |
| `<leader>jB` | Breakpoint condicional |
| `<leader>jd` | Iniciar/continuar debugging |
| `<leader>jn` | Step over |
| `<leader>ji` | Step into |
| `<leader>jo` | Step out |
| `<leader>ju` | Toggle DAP UI |

## Requisitos para Debugging

Para aprovechar las capacidades de debugging, necesitas:

1. Plugin `nvim-dap` instalado
2. Extensiones de Java Debug para JDTLS

### Instalar Extensiones de Debug con Mason

```lua
:MasonInstall java-debug-adapter java-test
```

O descárgalas manualmente:

```bash
# Para debugging
git clone https://github.com/microsoft/java-debug.git ~/workspaces/utils/java-debug
cd ~/workspaces/utils/java-debug
./mvnw clean install

# Para testing
git clone https://github.com/microsoft/vscode-java-test.git ~/workspaces/utils/vscode-java-test
cd ~/workspaces/utils/vscode-java-test
npm install
npm run build-plugin
```

## Uso de Lombok

Para usar Lombok correctamente:

1. Asegúrate de que el JAR de Lombok esté en la ruta correcta (`~/workspaces/utils/lombok.jar`)
2. Ejecuta `:LombokStatus` para verificar que Lombok está habilitado
3. Añade anotaciones como `@Getter`, `@Setter`, `@RequiredArgsConstructor` en tus clases Java

## Creación de Proyectos

Para crear un nuevo proyecto Java:

```
:JavaNewProject mi_proyecto
```

Esto creará una estructura de proyecto Maven con:
- Estructura de directorios src/main/java y src/test/java
- Clase Main.java básica
- Archivo pom.xml configurado

## Troubleshooting

Si encuentras problemas:

1. **JDTLS no inicia correctamente**:
   - Ejecuta `:JavaClean` y reinicia Neovim
   - Verifica rutas con `:JavaInfo`

2. **Problemas con Lombok**:
   - Verifica que el JAR existe y que JDTLS lo está usando con `:LombokStatus`

3. **Debugging no funciona**:
   - Asegúrate de tener nvim-dap instalado
   - Verifica que las extensiones de debugging están instaladas

4. **Error "Bundles not found"**:
   - Instala las extensiones necesarias con Mason o manualmente

5. **Rendimiento lento**:
   - Aumenta la memoria disponible para JDTLS en la configuración
   - Asegúrate de tener suficientes recursos en tu sistema

## Personalización

Puedes personalizar esta configuración editando el archivo `jdtls-enhanced.lua` y ajustando parámetros como:

- Memoria asignada a JVM
- Preferencias de formateo
- Orden de importaciones
- Keybindings

## Recursos Adicionales

- [Documentación oficial de JDTLS](https://github.com/mfussenegger/nvim-jdtls)
- [Documentación DAP para Java](https://github.com/mfussenegger/nvim-dap)
- [Documentación de Lombok](https://projectlombok.org/features/all)