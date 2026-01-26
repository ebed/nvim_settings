-- after/ftplugin/sql.lua

local function is_blank(s)
  return s:match("^%s*$") ~= nil
end
local function ends_sc(s)
  return s:match(";%s*$") ~= nil
end

local function run_stmt()
  local cur, last = vim.fn.line("."), vim.fn.line("$")
  local s = cur
  while s > 1 do
    local p = vim.fn.getline(s - 1)
    if is_blank(p) or ends_sc(p) then
      break
    end
    s = s - 1
  end
  local e = cur
  while e <= last do
    local l = vim.fn.getline(e)
    if ends_sc(l) then
      break
    end
    if is_blank(l) then
      e = e - 1
      break
    end
    e = e + 1
  end
  if e < s then
    e = s
  end
  if e > last then
    e = last
  end
  vim.cmd(("%d,%dDB"):format(s, e))
end

-- Limpia cualquier mapping previo en este buffer
pcall(vim.keymap.del, "n", "<​CR>", { buffer = 0 })
pcall(vim.keymap.del, "x", "<​CR>", { buffer = 0 })
pcall(vim.keymap.del, "s", "<​CR>", { buffer = 0 })

-- Normal: Enter => ejecutar statement actual
vim.keymap.set(
  "n",
  "<​CR>",
  run_stmt,
  { buffer = 0, silent = true, noremap = true, desc = "DB: run current statement" }
)

-- Visual: Enter => ejecutar selección (debe empezar con ":" para pasar el rango '<,>')
vim.keymap.set(
  "x",
  "<​CR>",
  [[:<C-u>DB<CR>]],
  { buffer = 0, silent = true, noremap = true, desc = "DB: run visual selection" }
)

-- Ejecutar todo el archivo
vim.keymap.set("n", "<leader><CR>", function()
  vim.cmd("%DB")
end, { buffer = 0, silent = true, noremap = true, desc = "DB: run whole file" })

-- Alternativa por si quieres otra tecla además de <CR>
vim.keymap.set("n", "g<CR>", run_stmt, { buffer = 0, silent = true, noremap = true, desc = "DB: run stmt (alt)" })
