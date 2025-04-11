-- Integración con telescope para listar topics
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values

-- Función para obtener topics y mostrarlos en telescope
local function kafka_topics()
  local job = vim.fn.jobstart('kafka-topics --bootstrap-server localhost:9092 --list', {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        local topics = {}
        for _, topic in ipairs(data) do
          if topic ~= "" then
            table.insert(topics, topic)
          end
        end
        
        pickers.new({}, {
          prompt_title = 'Kafka Topics',
          finder = finders.new_table({
            results = topics,
          }),
          sorter = conf.generic_sorter({}),
        }):find()
      end
    end,
  })
end

-- Crear comando para telescope
vim.api.nvim_create_user_command('TelescopeKafkaTopics', kafka_topics, {})
