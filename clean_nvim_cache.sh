#!/bin/bash

# Script para limpiar la caché y archivos temporales de Neovim
# Ejecutar periódicamente para evitar problemas de espacio en disco

# Directorios a limpiar
CACHE_DIR="$HOME/.cache/nvim"
STATE_DIR="$HOME/.local/state/nvim"

# Fecha actual para backups
DATE=$(date +%Y%m%d)
BACKUP_DIR="/tmp/nvim_backup_$DATE"

echo "Iniciando limpieza de caché y archivos temporales de Neovim..."

# Crear directorio de backup
mkdir -p "$BACKUP_DIR"

# Backup de archivos importantes antes de limpiar
echo "Creando backups..."
[ -f "$STATE_DIR/lazy/state.json" ] && cp "$STATE_DIR/lazy/state.json" "$BACKUP_DIR/"
[ -f "$STATE_DIR/file_frecency.bin" ] && cp "$STATE_DIR/file_frecency.bin" "$BACKUP_DIR/"

# Limpiar archivos de caché específicos
echo "Limpiando archivos de caché..."
find "$CACHE_DIR/snacks" -type f -name "*.txt" -mtime +7 -delete 2>/dev/null
find "$CACHE_DIR" -type f -name "*.json" -mtime +30 -delete 2>/dev/null
find "$CACHE_DIR" -type f -size +10M -delete 2>/dev/null

# Limpiar archivos de bloqueo de telescope-frecency
echo "Limpiando archivos de bloqueo..."
rm -f "$STATE_DIR/file_frecency.bin.lock" 2>/dev/null

# Verificar si hay errores al escribir en los directorios
echo "Verificando permisos..."
if ! touch "$STATE_DIR/write_test" 2>/dev/null; then
  echo "¡ADVERTENCIA! No se puede escribir en $STATE_DIR"
  chmod -R u+w "$STATE_DIR" 2>/dev/null
fi
rm -f "$STATE_DIR/write_test" 2>/dev/null

if ! touch "$CACHE_DIR/write_test" 2>/dev/null; then
  echo "¡ADVERTENCIA! No se puede escribir en $CACHE_DIR"
  chmod -R u+w "$CACHE_DIR" 2>/dev/null
fi
rm -f "$CACHE_DIR/write_test" 2>/dev/null

echo "Limpieza completada."
echo "Si continúas teniendo problemas, considera reinstalar los plugins con ':Lazy sync'"