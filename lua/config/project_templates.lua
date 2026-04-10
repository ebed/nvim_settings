-- Project Templates
-- Layouts predefinidos que aplicas manualmente

local M = {}

-- Template: Backend development
function M.backend_layout()
  -- Main code window
  vim.cmd("edit .")

  -- Vertical split para tests
  vim.cmd("vsplit")
  vim.cmd("wincmd l")

  -- Terminal horizontal abajo
  vim.cmd("split")
  vim.cmd("wincmd j")
  vim.cmd("resize 15")
  vim.cmd("terminal")

  -- Volver al main
  vim.cmd("wincmd k")
  vim.cmd("wincmd h")

  vim.notify("🏗️  Backend layout ready", vim.log.levels.INFO)
end

-- Template: Frontend + preview
function M.frontend_layout()
  -- Code
  vim.cmd("edit .")

  -- Browser preview (terminal con dev server)
  vim.cmd("split")
  vim.cmd("resize 20")
  vim.cmd("terminal npm run dev")

  vim.cmd("wincmd k")

  vim.notify("🎨 Frontend layout ready", vim.log.levels.INFO)
end

-- Template: Full-stack
function M.fullstack_layout()
  -- Explorer izquierda
  vim.cmd("Snacks explorer")

  -- Code centro
  vim.cmd("wincmd l")

  -- Terminal derecha (para logs)
  vim.cmd("vsplit")
  vim.cmd("terminal")

  -- Terminal abajo (para comandos)
  vim.cmd("wincmd h")
  vim.cmd("split")
  vim.cmd("wincmd j")
  vim.cmd("resize 12")
  vim.cmd("terminal")

  -- Volver al code
  vim.cmd("wincmd k")

  vim.notify("🚀 Full-stack layout ready", vim.log.levels.INFO)
end

-- Template: Solo lectura / review
function M.review_layout()
  -- Solo explorer + main buffer
  vim.cmd("Snacks explorer")
  vim.cmd("wincmd l")

  vim.notify("📖 Review layout ready", vim.log.levels.INFO)
end

-- Comandos para invocar templates
vim.api.nvim_create_user_command("LayoutBackend", M.backend_layout, {})
vim.api.nvim_create_user_command("LayoutFrontend", M.frontend_layout, {})
vim.api.nvim_create_user_command("LayoutFullstack", M.fullstack_layout, {})
vim.api.nvim_create_user_command("LayoutReview", M.review_layout, {})

-- Keybindings opcionales
vim.keymap.set("n", "<leader>lb", M.backend_layout, { desc = "Layout: Backend" })
vim.keymap.set("n", "<leader>lf", M.frontend_layout, { desc = "Layout: Frontend" })
vim.keymap.set("n", "<leader>ls", M.fullstack_layout, { desc = "Layout: Full-stack" })
vim.keymap.set("n", "<leader>lr", M.review_layout, { desc = "Layout: Review" })

return M
