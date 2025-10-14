#!/bin/bash
# Script de diagnóstico para JDTLS

echo "=== Diagnóstico JDTLS ==="
echo "Fecha: $(date)"

# Variables básicas
JAVA_HOME=${JAVA_HOME:-"/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home"}
JAVA_BIN="$JAVA_HOME/bin/java"
HOME_DIR="$HOME"
JDTLS_PATH="$HOME_DIR/workspaces/utils/jdt-language-server-1.52.0-202510230337"
LOMBOK_JAR="$HOME_DIR/workspaces/utils/lombok.jar"
PROJECT_NAME=$(basename "$(pwd)")
WORKSPACE_DIR="$HOME_DIR/.local/share/nvim/jdtls-workspace/$PROJECT_NAME"
CONFIG_DIR="$JDTLS_PATH/config_mac"
LAUNCHER_JAR=$(find "$JDTLS_PATH/plugins" -name "org.eclipse.equinox.launcher_*.jar" | head -n 1)

# Verificar variables críticas
echo "=== Verificando variables ==="
echo "JAVA_HOME: $JAVA_HOME"
echo "JAVA_BIN: $JAVA_BIN"
echo "JDTLS_PATH: $JDTLS_PATH"
echo "LOMBOK_JAR: $LOMBOK_JAR"
echo "PROJECT_NAME: $PROJECT_NAME"
echo "WORKSPACE_DIR: $WORKSPACE_DIR"
echo "CONFIG_DIR: $CONFIG_DIR"
echo "LAUNCHER_JAR: $LAUNCHER_JAR"

# Verificar archivos
echo -e "\n=== Verificando archivos ==="
if [ -f "$JAVA_BIN" ]; then echo "✅ Java binary exists"; else echo "❌ Java binary not found"; fi
if [ -f "$LAUNCHER_JAR" ]; then echo "✅ Launcher jar exists"; else echo "❌ Launcher jar not found"; fi
if [ -f "$LOMBOK_JAR" ]; then echo "✅ Lombok jar exists"; else echo "❌ Lombok jar not found"; fi
if [ -d "$CONFIG_DIR" ]; then echo "✅ Config dir exists"; else echo "❌ Config dir not found"; fi

# Verificar permisos
echo -e "\n=== Verificando permisos ==="
echo "Java binary: $(ls -la "$JAVA_BIN")"
echo "Launcher jar: $(ls -la "$LAUNCHER_JAR")"
echo "Lombok jar: $(ls -la "$LOMBOK_JAR")"
echo "Config dir: $(ls -la "$CONFIG_DIR" | head -n 3)"

# Limpiar workspace antiguo
echo -e "\n=== Limpiando workspace ==="
if [ -d "$WORKSPACE_DIR" ]; then
    rm -rf "$WORKSPACE_DIR"
    echo "✅ Workspace eliminado"
    mkdir -p "$WORKSPACE_DIR"
    echo "✅ Workspace creado de nuevo"
else
    mkdir -p "$WORKSPACE_DIR"
    echo "✅ Workspace creado"
fi

# Mostrar información de Java
echo -e "\n=== Información de Java ==="
"$JAVA_BIN" -version
echo -e "\n"
"$JAVA_BIN" -XshowSettings:properties -version 2>&1 | grep -E "java.(home|library|vendor|version)"

# Probar JDTLS - versión mínima
echo -e "\n=== Test 1: JDTLS mínimo sin opciones adicionales ==="
"$JAVA_BIN" \
    -Declipse.application=org.eclipse.jdt.ls.core.id1 \
    -Dosgi.bundles.defaultStartLevel=4 \
    -Declipse.product=org.eclipse.jdt.ls.core.product \
    -Xms256m \
    -Xmx512m \
    -jar "$LAUNCHER_JAR" \
    -configuration "$CONFIG_DIR" \
    -data "$WORKSPACE_DIR" &

JDTLS_PID=$!
echo "PID: $JDTLS_PID"
sleep 2

if ps -p $JDTLS_PID > /dev/null; then
    echo "✅ JDTLS está ejecutándose con PID $JDTLS_PID"
    kill $JDTLS_PID
    echo "JDTLS detenido"
else
    echo "❌ JDTLS falló al iniciar"
fi

# Probar JDTLS - con lombok
echo -e "\n=== Test 2: JDTLS con Lombok ==="
"$JAVA_BIN" \
    -javaagent:"$LOMBOK_JAR" \
    -Declipse.application=org.eclipse.jdt.ls.core.id1 \
    -Dosgi.bundles.defaultStartLevel=4 \
    -Declipse.product=org.eclipse.jdt.ls.core.product \
    -Xms256m \
    -Xmx512m \
    -jar "$LAUNCHER_JAR" \
    -configuration "$CONFIG_DIR" \
    -data "$WORKSPACE_DIR" &

JDTLS_PID=$!
echo "PID: $JDTLS_PID"
sleep 2

if ps -p $JDTLS_PID > /dev/null; then
    echo "✅ JDTLS con Lombok está ejecutándose con PID $JDTLS_PID"
    kill $JDTLS_PID
    echo "JDTLS detenido"
else
    echo "❌ JDTLS con Lombok falló al iniciar"
fi

# Probar JDTLS - con opciones de módulos Java
echo -e "\n=== Test 3: JDTLS con opciones de módulos ==="
"$JAVA_BIN" \
    --add-modules=ALL-SYSTEM \
    --add-opens java.base/java.util=ALL-UNNAMED \
    --add-opens java.base/java.lang=ALL-UNNAMED \
    -Declipse.application=org.eclipse.jdt.ls.core.id1 \
    -Dosgi.bundles.defaultStartLevel=4 \
    -Declipse.product=org.eclipse.jdt.ls.core.product \
    -Xms256m \
    -Xmx512m \
    -jar "$LAUNCHER_JAR" \
    -configuration "$CONFIG_DIR" \
    -data "$WORKSPACE_DIR" &

JDTLS_PID=$!
echo "PID: $JDTLS_PID"
sleep 2

if ps -p $JDTLS_PID > /dev/null; then
    echo "✅ JDTLS con opciones de módulos está ejecutándose con PID $JDTLS_PID"
    kill $JDTLS_PID
    echo "JDTLS detenido"
else
    echo "❌ JDTLS con opciones de módulos falló al iniciar"
fi

echo -e "\n=== Test 4: Verificar bibliotecas de sistema ==="
echo "Verificando bibliotecas JNI:"
ls -la "$JAVA_HOME/lib" | grep -E "jli|jvm|java"
echo -e "\nVerificando bibliotecas macOS:"
otool -L "$JAVA_HOME/lib/libjli.dylib" | head -n 10

echo -e "\n=== Recomendaciones ==="
echo "1. Si alguno de los tests fue exitoso, use esa configuración en jdtls.lua"
echo "2. Verifique permisos de los directorios de trabajo"
echo "3. Pruebe ejecutar Neovim con sudo para descartar problemas de permisos"
echo "4. Pruebe la actualización de JDTLS a una versión compatible con Java 21"
echo "5. Verifique compatibilidad entre JDTLS y su versión de Java"

# Generar archivo de configuración básico basado en el test exitoso
echo -e "\n=== Generando configuración básica ==="
echo "Archivo jdtls_config_simple.lua creado en ~/.config/nvim/"

cat > "$HOME/.config/nvim/jdtls_config_simple.lua" << 'EOF'
-- JDTLS configuración ultra simple basada en diagnóstico
local home = os.getenv("HOME")
local java_home = os.getenv("JAVA_HOME") or "/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home"
local java_binary = java_home .. "/bin/java"
local jdtls_path = home .. "/workspaces/utils/jdt-language-server-1.52.0-202510230337"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name
local config_dir = jdtls_path .. "/config_mac"
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", true)

-- Ultra simple command
local cmd = {
    java_binary,
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Xms256m",
    "-Xmx512m",
    "-jar", launcher_jar,
    "-configuration", config_dir,
    "-data", workspace_dir
}

return {
    'mfussenegger/nvim-jdtls',
    config = function()
        -- Ensure workspace exists
        os.execute("mkdir -p " .. workspace_dir)

        vim.api.nvim_create_autocmd({"FileType"}, {
            pattern = {"java"},
            callback = function()
                local jdtls = require('jdtls')
                local config = {
                    cmd = cmd,
                    root_dir = require('jdtls.setup').find_root({'pom.xml', 'build.gradle', '.git'}),
                    settings = {
                        java = {
                            configuration = {
                                runtimes = {{
                                    name = "JavaSE-21",
                                    path = java_home,
                                }}
                            }
                        }
                    }
                }
                jdtls.start_or_attach(config)
            end
        })
    end,
}
EOF

echo -e "\nScript completado. Verifique los resultados arriba."