-- agent_pr.lua
local M = {}
local utils = require("config.copilotchat.utils")

function M.generate_pr_description(changes)
  local template = utils.load_template("pr_template.txt")
  local prompt = "Generate a pull request description based on these changes:\n" .. changes .. "\nTemplate:\n" .. template
  local description = utils.llm_call(prompt) -- Usa OpenAI API o CopilotChat
  return description
end

function M.create_pr()
  local changes = utils.get_git_diff()
  local description = M.generate_pr_description(changes)
  utils.git_add_commit_push(description)
  utils.create_pull_request(description)
end

return M

