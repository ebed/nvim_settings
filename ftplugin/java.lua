local jdtls = require('jdtls')
local home = vim.loop.os_homedir()
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = table.concat({home, 'workspaces', 'Pagerduty', project_name}, '/')

local root_markers = {'.git', 'mvnw', 'gradlew'}
local root_dir = require('jdtls.setup').find_root(root_markers)

local is_maven = root_dir and vim.fn.filereadable(root_dir .. "/pom.xml") == 1
local is_gradle = root_dir and (vim.fn.filereadable(root_dir .. "/build.gradle") == 1 or vim.fn.filereadable(root_dir .. "/build.gradle.kts") == 1)


if root_dir then
  jdtls.start_or_attach({
  cmd = {
    'jdtls',
    '-configuration', workspace_dir,
    '-data', workspace_dir,
    '--jvm-arg=-Dlog.level=ALL', -- Habilita logs detallados
  },
    root_dir = root_dir,
    workspace_folder = workspace_dir,
  })

  if is_maven then
    vim.api.nvim_create_user_command("JavaBuild", function()
      vim.cmd("split | terminal mvn clean install")
    end, {})
    vim.api.nvim_create_user_command("JavaRun", function()
      vim.cmd("split | terminal mvn exec:java")
    end, {})
  elseif is_gradle then
    vim.api.nvim_create_user_command("JavaBuild", function()
      vim.cmd("split | terminal ./gradlew build")
    end, {})
    vim.api.nvim_create_user_command("JavaRun", function()
      vim.cmd("split | terminal ./gradlew run")
    end, {})
  end
else
  vim.notify('No Java project root found!', vim.log.levels.WARN)
end
