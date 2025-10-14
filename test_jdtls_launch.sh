#!/bin/bash
# Script para diagnosticar y lanzar JDTLS directamente desde shell

# Variables básicas
HOME_DIR="$HOME"
JAVA_HOME=${JAVA_HOME:-"/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home"}
JAVA_BIN="$JAVA_HOME/bin/java"
JDTLS_PATH="$HOME_DIR/workspaces/utils/jdt-language-server-1.52.0-202510230337"
CONFIG_DIR="$JDTLS_PATH/config_mac"
WORKSPACE_DIR="/tmp/jdtls-test-workspace"
LAUNCHER_JAR=$(find "$JDTLS_PATH/plugins" -name "org.eclipse.equinox.launcher_*.jar" | head -n 1)
LOG_FILE="/tmp/jdtls_direct.log"

# Limpiar workspace anterior
echo "Limpiando workspace anterior..."
rm -rf "$WORKSPACE_DIR"
mkdir -p "$WORKSPACE_DIR"

# Verificar archivos
echo "Verificando archivos..."
echo "JAVA_HOME: $JAVA_HOME"
echo "LAUNCHER_JAR: $LAUNCHER_JAR"
echo "CONFIG_DIR: $CONFIG_DIR"
echo "WORKSPACE_DIR: $WORKSPACE_DIR"

if [ ! -f "$JAVA_BIN" ]; then
    echo "❌ Java binary no encontrado: $JAVA_BIN"
    exit 1
fi

if [ ! -f "$LAUNCHER_JAR" ]; then
    echo "❌ Launcher jar no encontrado: $LAUNCHER_JAR"
    exit 1
fi

if [ ! -d "$CONFIG_DIR" ]; then
    echo "❌ Config dir no encontrado: $CONFIG_DIR"
    exit 1
fi

# Ejecutar JDTLS con configuración mínima
echo "Ejecutando JDTLS directamente desde shell..."
echo "Salida en: $LOG_FILE"

# Comando directo - lo más mínimo posible
$JAVA_BIN \
    -Declipse.application=org.eclipse.jdt.ls.core.id1 \
    -Dosgi.bundles.defaultStartLevel=4 \
    -Declipse.product=org.eclipse.jdt.ls.core.product \
    -Xms256m \
    -Xmx512m \
    -jar "$LAUNCHER_JAR" \
    -configuration "$CONFIG_DIR" \
    -data "$WORKSPACE_DIR" \
    > "$LOG_FILE" 2>&1 &

JDTLS_PID=$!
echo "JDTLS iniciado con PID: $JDTLS_PID"

# Esperar un poco para ver si inicia correctamente
sleep 3

# Verificar si el proceso sigue activo
if ps -p $JDTLS_PID > /dev/null; then
    echo "✅ JDTLS está ejecutándose con éxito"
else
    echo "❌ JDTLS falló al iniciar. Verificando logs..."
    cat "$LOG_FILE" | grep -i "error\|exception\|failed\|code 13"
fi

# Mostrar stack trace si existe
echo "Buscando stack trace en logs..."
cat "$LOG_FILE" | grep -A 10 "Exception in thread" || echo "No se encontró stack trace"

echo "Script finalizado. Para terminar JDTLS ejecuta: kill $JDTLS_PID"