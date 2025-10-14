#!/bin/bash
# Script para configurar correctamente el entorno de Java para JDTLS en macOS

# Configuración básica
JAVA_HOME=${JAVA_HOME:-"/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home"}
export JAVA_HOME

# Configuración crucial para JNI en macOS
export DYLD_LIBRARY_PATH="$JAVA_HOME/lib:$JAVA_HOME/lib/server:$DYLD_LIBRARY_PATH"
export LD_LIBRARY_PATH="$JAVA_HOME/lib:$JAVA_HOME/lib/server:$LD_LIBRARY_PATH"

# Añadir Java al PATH
export PATH="$JAVA_HOME/bin:$PATH"

# Variables adicionales para JNI
export JAVA_LIBRARY_PATH="$JAVA_HOME/lib:$JAVA_HOME/lib/server"

# Diagnóstico
echo "===== Diagnóstico entorno Java ====="
echo "JAVA_HOME: $JAVA_HOME"
echo "DYLD_LIBRARY_PATH: $DYLD_LIBRARY_PATH"
echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"
echo "PATH: $PATH"

# Verificar bibliotecas nativas
echo "===== Verificando bibliotecas nativas ====="
ls -la "$JAVA_HOME/lib/libjli.dylib" 2>/dev/null || echo "❌ libjli.dylib no encontrada"
ls -la "$JAVA_HOME/lib/server/libjvm.dylib" 2>/dev/null || echo "❌ libjvm.dylib no encontrada"
ls -la "$JAVA_HOME/lib/libzip.dylib" 2>/dev/null || echo "❌ libzip.dylib no encontrada"

# Verificar versión Java
echo "===== Versión Java ====="
java -version

# Ejecutar comando proporcionado
echo "===== Ejecutando comando ====="
if [ $# -gt 0 ]; then
    echo "Comando: $@"
    "$@"
else
    echo "No se proporcionó ningún comando"
    echo "Uso: java_env.sh <comando>"
    echo "Ejemplo: java_env.sh java -version"
    echo "Ejemplo para JDTLS: java_env.sh /Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home/bin/java -jar /path/to/launcher.jar ..."
fi