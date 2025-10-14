#!/bin/bash
# Script para configurar entorno Java para LSP - versión silenciosa

# Configuración básica
JAVA_HOME=${JAVA_HOME:-"/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home"}
export JAVA_HOME

# Configuración crucial para JNI en macOS - silenciosa
export DYLD_LIBRARY_PATH="$JAVA_HOME/lib:$JAVA_HOME/lib/server:$DYLD_LIBRARY_PATH"
export LD_LIBRARY_PATH="$JAVA_HOME/lib:$JAVA_HOME/lib/server:$LD_LIBRARY_PATH"
export PATH="$JAVA_HOME/bin:$PATH"
export JAVA_LIBRARY_PATH="$JAVA_HOME/lib:$JAVA_HOME/lib/server"

# Ejecutar comando sin salida de diagnóstico
exec "$@"