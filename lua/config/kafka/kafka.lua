-- En tu init.lua o en un archivo separado como kafka.lua

local kafka_config = {
  -- Definir comandos personalizados para Kafka
  commands = {
    -- Crear comandos de Neovim para operaciones comunes de Kafka
    vim.api.nvim_create_user_command('KafkaListTopics', function()
      -- Usar terminal integrado para ejecutar kafka-topics --list
      vim.cmd('terminal kafka-topics --bootstrap-server localhost:9092 --list')
    end, {}),

    vim.api.nvim_create_user_command('KafkaDescribeTopic', function(opts)
      -- Describir un topic específico
      local topic = opts.args
      vim.cmd(string.format('terminal kafka-topics --bootstrap-server localhost:9092 --describe --topic %s', topic))
    end, {nargs = 1}),
  }
}

-- Keymappings útiles
local kafka_mappings = {
  -- Mapear teclas para comandos comunes
  vim.keymap.set('n', '<leader>kl', ':KafkaListTopics<CR>', {silent = true, desc = 'List Kafka Topics'}),
  vim.keymap.set('n', '<leader>kd', ':KafkaDescribeTopic ', {desc = 'Describe Kafka Topic'}),
}
