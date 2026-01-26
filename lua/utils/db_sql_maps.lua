-- lua/utils/db_sql_maps.lua
-- Este módulo se carga SIEMPRE al iniciar Neovim. No depende de ningún plugin.

-- Detecta tus archivos reales sin extensión con patrón ...-query-YYYY-MM-DD[-HH-MM-SS] y fuerza filetype=sql
do
  local grp = vim.api.nvim_create_augroup("DBQueryFiletypeDetect", { clear = true })
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = grp,
    pattern = "*",
    callback = function(ev)
      if vim.bo[ev.buf].buftype ~= "" then
        return
      end -- solo archivos reales
      local fname = vim.fn.expand("%:t")
      local matches = fname:match("query%-%d%d%d%d%-%d%d%-%d%d$")
        or fname:match("query%-%d%d%d%d%-%d%d%-%d%d%-%d%d%-%d%d%-%d%d$")
      if matches and (vim.bo[ev.buf].filetype == "" or vim.bo[ev.buf].filetype == "mysql") then
        vim.bo[ev.buf].filetype = "sql"
      end
    end,
  })
end

-- Funciones helper y ejecución de bloque
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

-- Aplica mappings buffer-local para SQL/MySQL/PLSQL.
-- Además, los re-aplica al entrar al buffer por si otro plugin los pisa.
do
  local function apply_sql_maps(buf)
    local ft = vim.bo[buf].filetype
    if ft ~= "sql" and ft ~= "mysql" and ft ~= "plsql" then
      return
    end
    if ft == "dbout" then
      return
    end

    -- Borra cualquier mapping previo de <CR> en este buffer
    pcall(vim.keymap.del, "n", "<​CR>", { buffer = buf })
    pcall(vim.keymap.del, "x", "<​CR>", { buffer = buf })
    pcall(vim.keymap.del, "s", "<​CR>", { buffer = buf })

    -- Normal: Enter => ejecutar bloque actual
    vim.keymap.set(
      "n",
      "<​CR>",
      run_stmt,
      { buffer = buf, silent = true, noremap = true, nowait = true, desc = "DB: run current statement" }
    )

    -- Visual: Enter => ejecutar selección (usar ":" para pasar el rango visual '<,>')
    vim.keymap.set(
      "x",
      "<​CR>",
      [[:<C-u>DB<CR>]],
      { buffer = buf, silent = true, noremap = true, nowait = true, desc = "DB: run visual selection" }
    )

    -- Ejecutar todo el archivo
    vim.keymap.set("n", "<leader><CR>", function()
      vim.cmd("%DB")
    end, { buffer = buf, silent = true, noremap = true, desc = "DB: run whole file" })

    -- Tecla alternativa por si quieres otra además de Enter
    vim.keymap.set("n", "g<CR>", run_stmt, { buffer = buf, silent = true, noremap = true, desc = "DB: run stmt (alt)" })
  end

  local grp = vim.api.nvim_create_augroup("DBEnterMapSQL_GLOBAL", { clear = true })

  -- Al detectar FileType, aplica mappings
  vim.api.nvim_create_autocmd("FileType", {
    group = grp,
    pattern = { "sql", "mysql", "plsql" },
    callback = function(ev)
      vim.schedule(function()
        apply_sql_maps(ev.buf)
      end)
    end,
  })

  -- Reaplica mappings al entrar a cualquier buffer SQL-like
  vim.api.nvim_create_autocmd("BufEnter", {
    group = grp,
    pattern = "*",
    callback = function(ev)
      local ft = vim.bo[ev.buf].filetype
      if ft == "sql" or ft == "mysql" or ft == "plsql" then
        vim.schedule(function()
          apply_sql_maps(ev.buf)
        end)
      end
    end,
  })

  -- Comando manual por si quieres forzar
  vim.api.nvim_create_user_command("DBMapEnable", function()
    apply_sql_maps(0)
    print("DB mappings buffer-local aplicados")
  end, {})
end
