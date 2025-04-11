-- Configuración con toggleterm.nvim
require('toggleterm').setup{
  -- Configuración básica de toggleterm
  size = 20,
  open_mapping = [[<c-\>]],
  direction = 'float',
}

-- Funciones helper para Kafka
local Terminal = require('toggleterm.terminal').Terminal

-- Crear terminal dedicada para Kafka
local kafka_term = Terminal:new({
  cmd = "kafka-console-consumer --bootstrap-server localhost:9092 --topic ",
  hidden = true,
  direction = "float",
})

-- Función para consumir mensajes de un topic
function _KAFKA_CONSUME()
  vim.ui.input({
    prompt = "Enter topic name: ",
  }, function(topic)
    if topic then
      kafka_term:change_cmd("kafka-console-consumer --bootstrap-server localhost:9092 --topic " .. topic)
      kafka_term:toggle()
    end
  end)
end

-- Crear comando de Neovim
vim.api.nvim_create_user_command('KafkaConsume', _KAFKA_CONSUME, {})

-- Keymapping para consumir mensajes
vim.keymap.set('n', '<leader>kc', ':KafkaConsume<CR>', {silent = true, desc = 'Consume Kafka Topic'})
