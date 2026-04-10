#!/usr/bin/env ruby

# Este script verifica que ruby-lsp esté instalado y funcionando correctamente
require 'rubygems'

puts "Verificando ruby-lsp..."
puts "Ruby version: #{RUBY_VERSION}"

begin
  gem 'ruby-lsp'
  require 'ruby_lsp'
  puts "✅ ruby-lsp está instalado correctamente."
  puts "Versión: #{RubyLsp::VERSION}"
  puts "Ruta de la gema: #{Gem.loaded_specs['ruby-lsp'].full_gem_path}"
rescue LoadError => e
  puts "❌ Error al cargar ruby-lsp: #{e.message}"
  puts "Asegúrate de que la gema está instalada con: gem install ruby-lsp"
end

puts "\nVerificando capacidades del servidor LSP..."
begin
  require 'ruby_lsp/requests'
  puts "✅ Módulo de solicitudes LSP está disponible."

  # Listar algunas de las capacidades del servidor
  puts "Capacidades disponibles:"
  RubyLsp::Requests.constants.sort.each do |const|
    puts "  - #{const}"
  end
rescue LoadError => e
  puts "❌ Error al cargar módulos LSP: #{e.message}"
end

puts "\nVerificando entorno..."
puts "GEM_HOME: #{ENV['GEM_HOME']}"
puts "GEM_PATH: #{ENV['GEM_PATH']}"
puts "PATH: #{ENV['PATH']}"

puts "\nListado de gemas relacionadas:"
system('gem list | grep -i lsp')