local M = {}
local hooks = require('config.copilotchat.hooks')
M.agent_pr = require("config.copilotchat.agent_pr")
M.agent_doc = require("config.copilotchat.doc_changes")
M.structure = require("config.copilotchat.structure")
M.context = require("config.copilotchat.context")

vim.api.nvim_create_user_command(
  'CopilotChatGenerateStructure', M.structure.generate_structure_for_requirement, {}
)
-- Agrega otros agentes si los tienes

return M
