# CONFIGURACIÓN AVANZADA DE NEOVIM CON LUA Y ELIXIR
Este proyecto configura Neovim con plugins avanzados y utilidades personalizadas.
Incluye módulos Lua para gestión de plugins, LSP y automatización de tareas.
Elixir se usa para desarrollar herramientas y servidores de lenguaje propios.
La arquitectura separa claramente configuraciones y lógica en carpetas dedicadas.
La gestión de plugins se realiza con lazy.nvim para optimizar el rendimiento.
El proyecto cuenta con integración continua mediante GitHub Actions.
Se aplican linters y pruebas automatizadas en Lua y Elixir para asegurar calidad.
La documentación y ejemplos se encuentran en los subdirectorios relevantes.
El código sigue buenas prácticas de modularidad y mantenimiento.
## Diagrama de arquitectura general

## Plugins principales en uso
## Arquitectura de plugins Neovim


- lazy.nvim: Gestión eficiente de plugins.
- lspconfig: Configuración de servidores de lenguaje.
- copilotchat: Integración con GitHub Copilot.
- telescope.nvim: Búsqueda y navegación avanzada.
- treesitter: Mejoras en sintaxis y resaltado.
- nvim-cmp: Autocompletado inteligente.
- plenary.nvim: Utilidades Lua para plugins.
- trouble.nvim: Visualización de diagnósticos.
- gitsigns.nvim: Integración con Git.
- rest-nvim: Cliente HTTP para pruebas de APIs.
- otros plugins personalizados en `lua/plugins`.
- vim-dadbd: Integración con bases de datos usando DADBD.
