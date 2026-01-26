#!/usr/bin/env ruby

# Archivo de prueba para verificar la inicialización de ruby-lsp
class TestClass
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def greet
    puts "Hola, #{@name}!"
  end
end

test = TestClass.new("Usuario")
test.greet