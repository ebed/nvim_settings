-- Global defaults (will be overridden per filetype where needed)
vim.opt.foldmethod = "expr"
-- Use Treesitter foldexpr if available (fallback decided later per filetype)
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldcolumn = "0"
vim.opt.foldtext = ""
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 10
vim.opt.foldenable = true

-- Debug command to inspect current folding state
vim.api.nvim_create_user_command("FoldDebug", function()
  local msg = table.concat({
    "method=" .. vim.wo.foldmethod,
    "expr=" .. vim.wo.foldexpr,
    "lvl(cur)=" .. vim.fn.foldlevel("."),
    "closed=" .. (vim.fn.foldclosed(".") or -1),
  }, " | ")
  vim.notify("[FoldDebug] " .. msg)
end, {})

-- Helper: choose correct foldexpr for current Neovim version
local function treesitter_foldexpr()
  if vim.fn.has("nvim-0.10") == 1 then
    return "v:lua.vim.treesitter.foldexpr()"
  else
    return "nvim_treesitter#foldexpr()"
  end
end

-- Ensure Treesitter folding for specific languages (Elixir, Ruby-like, Lua, etc.)
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "elixir", "heex", "surface", "eelixir",
    "lua", "ruby", "java"
  },
  callback = function(ev)
    local ft = ev.match
    -- Only proceed if a parser exists (avoid errors)
    local ok_parsers, parsers = pcall(require, "nvim-treesitter.parsers")
    if not ok_parsers or not parsers.has_parser(ft) then
      vim.notify("[folds] Treesitter parser missing for " .. ft .. " (install it with :TSInstall " .. ft .. ")", vim.log.levels.WARN)
      return
    end

    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = treesitter_foldexpr()
    vim.opt_local.foldlevel = 99
    vim.opt_local.foldlevelstart = 99
    vim.opt_local.foldenable = true
    vim.opt_local.foldnestmax = 10

    -- Optional: custom fold text (compact)
    _G.FoldTextCompact = _G.FoldTextCompact or function()
      local start_line = vim.fn.getline(vim.v.foldstart):gsub("^%s*", "")
      local lines_count = vim.v.foldend - vim.v.foldstart + 1
      return ("  %s  … (%d lines) "):format(start_line, lines_count)
    end
    vim.opt_local.foldtext = "v:lua.FoldTextCompact()"
  end,
})

-- Fallback manual mapping helpers (optional):
-- Keymaps to open/close all folds quickly (silent buffer local when entering supported filetypes)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "elixir", "heex", "surface", "lua", "ruby" },
  callback = function()
    local opts = { silent = true, buffer = true }
    vim.keymap.set("n", "<leader>fo", "zR", opts) -- Open all
    vim.keymap.set("n", "<leader>fc", "zM", opts) -- Close all
    vim.keymap.set("n", "<leader>f.", "za", opts) -- Toggle current
  end,
})
