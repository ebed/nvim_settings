-- agent_pr.lua
local M = {}
local utils = require("config.copilotchat.utils")

function M.create_pr()
  local current_branch = utils.get_current_branch()
  if current_branch == "main" or current_branch == "master" then
    vim.ui.input({ prompt = "You are on main/master. Enter new branch name: ", default = "feature/" }, function(branch_name)
      if branch_name and branch_name ~= "" then
        utils.switch_or_create_branch(branch_name)
        vim.notify("Switched to branch: " .. branch_name, vim.log.levels.INFO)
        M._create_pr_flow(branch_name)
      else
        vim.notify("Branch name required.", vim.log.levels.ERROR)
      end
    end)
  else
    M._create_pr_flow(current_branch)
  end
end

function M.generate_pr_description(changes)
  local template = utils.load_template("pr_template.txt")
  local prompt = "Generate a pull request description based on these changes:\n" .. changes .. "\nTemplate:\n" .. template
  local description = utils.llm_call(prompt) -- Usa OpenAI API o CopilotChat
  return description
end

function M.start_development()
  vim.ui.input({ prompt = "Branch name for development: ", default = "feature/" }, function(branch_name)
    if branch_name and branch_name ~= "" then
      utils.switch_or_create_branch(branch_name)
      vim.notify("Switched to branch: " .. branch_name, vim.log.levels.INFO)
    else
      vim.notify("Branch name required.", vim.log.levels.ERROR)
    end
  end)
end

function M._create_pr_flow(branch_name)
  local changes = utils.get_git_diff()
  local template = utils.load_template("pr_template.txt")
  local prompt = "Generate a pull request description based on these changes:\n" .. changes .. "\nTemplate:\n" .. template
  local description = utils.llm_call(prompt)
  utils.git_add_commit_push(description)
  utils.create_pull_request(description)
end


vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    local current_branch = require("config.copilotchat.utils").get_current_branch()
    if current_branch == "main" or current_branch == "master" then
      require("config.copilotchat.agent_pr").start_development()
    else
      require("config.copilotchat.agent_pr").show_git_log()
    end
  end,
  group = vim.api.nvim_create_augroup("CopilotChatBranchGuard", { clear = true }),
  desc = "Prompt for new branch if saving on main/master",
})

function M.show_git_log()
  -- Get git diff
  local diff = require("config.copilotchat.utils").get_git_diff()
  -- Create a new scratch buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(diff, "\n"))
  -- Set buffer options: read-only, nofile
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "readonly", true)
  -- Open split below
  vim.cmd("botright split")
  vim.api.nvim_win_set_buf(0, buf)
  -- Map 'q' to close window
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
  -- Optional: set window height
  vim.cmd("resize 15")
end


return M

