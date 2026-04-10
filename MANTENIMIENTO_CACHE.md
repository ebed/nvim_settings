# Solución para errores "No space left on device" en Neovim

## Problema detectado

Al iniciar Neovim, se pueden producir los siguientes errores:

```
Error executing callback: ...share/nvim/lazy/plenary.nvim/lua/plenary/async/async.lua:18: The coroutine failed with this message: ...azy/telescope-frecency.nvim/lua/frecency/v1/database.lua:202: failed to get lock

Lua callback: ...cal/share/nvim/lazy/snacks.nvim/lua/snacks/dashboard.lua:1037: ENOSPC: no space left on device: /Users/ralbertomerinocolipe/.cache/nvim/snacks/...

Error executing vim.schedule lua callback: ...olipe/.local/share/nvim/lazy/lazy.nvim/lua/lazy/util.lua:66: /Users/ralbertomerinocolipe/.local/state/nvim/lazy/state.json: No space left on device
```

Este error se produce debido a:

1. Problemas con archivos de bloqueo en `telescope-frecency`
2. Acumulación excesiva de archivos temporales en la caché
3. Posibles problemas de permisos en directorios de caché
4. Estado inconsistente en archivos de configuración de plugins

## Solución implementada

Se han implementado las siguientes soluciones:

### 1. Script de limpieza manual

Se ha creado un script `clean_nvim_cache.sh` en la configuración de Neovim que puede ejecutarse manualmente para limpiar archivos innecesarios:

```bash
~/.config/nvim/clean_nvim_cache.sh
```

### 2. Sistema automático de mantenimiento

Se ha agregado un módulo Lua `utils/cache_maintenance.lua` que realiza las siguientes tareas:

- Elimina automáticamente archivos de bloqueo problemáticos
- Limpia periódicamente archivos temporales antiguos
- Verifica permisos de escritura en directorios importantes
- Monitorea el espacio disponible

Este módulo se carga automáticamente al iniciar Neovim.

## Si el problema persiste

Si los errores continúan apareciendo:

1. Ejecuta manualmente el script de limpieza:
   ```
   bash ~/.config/nvim/clean_nvim_cache.sh
   ```

2. Elimina manualmente los directorios de caché (solo como último recurso):
   ```
   rm -rf ~/.cache/nvim/snacks
   rm -f ~/.local/state/nvim/file_frecency.bin*
   rm -f ~/.local/state/nvim/lazy/state.json
   ```

3. Reinicia Neovim y sincroniza los plugins:
   ```
   :Lazy sync
   ```

## Prevención

Para evitar problemas similares en el futuro:

1. Ejecuta periódicamente el script de limpieza (puede agregarse al cron)
2. Considera limitar la cantidad de archivos recientes en telescope-frecency
3. Monitorea regularmente el espacio disponible en disco

## Detalles técnicos

El sistema de mantenimiento implementado:

- Se inicializa en `init.lua` con `require("utils.cache_maintenance").setup()`
- Realiza limpieza inmediata al iniciar Neovim
- Ejecuta limpieza periódica cada 30 minutos
- Verifica permisos al guardar archivos de configuración