#!/bin/bash

# Configura el nivel de log al máximo
export NVIM_LUA_LOG_LEVEL=trace

# Lanza Neovim con el archivo Ruby de prueba
nvim -c "lua vim.lsp.set_log_level('trace')" test_ruby.rb