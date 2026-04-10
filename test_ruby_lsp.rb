#!/usr/bin/env ruby

# Este es un archivo de prueba para verificar si ruby_lsp se inicia correctamente

class TestClass
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def greet
    puts "Hola, #{@name}!"
  end
end

# Crear una instancia y saludar
test = TestClass.new("Usuario")
test.greet