-- kafka_clusters.lua
local M = {}

M.clusters = {
  dev = {
    bootstrap_servers = "localhost:9092",
    security_protocol = "PLAINTEXT",
  },
  prod = {
    bootstrap_servers = "prod-kafka:9092",
    security_protocol = "SASL_SSL",
    sasl_mechanism = "PLAIN",
    -- Agregar otras configuraciones necesarias
  }
}

return M
