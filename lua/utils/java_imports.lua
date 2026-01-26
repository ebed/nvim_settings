-- Utility functions for Java import management with wildcard support
local M = {}

-- Collapse multiple imports from same package to wildcard
-- Threshold: minimum number of imports to collapse to *
function M.collapse_imports_to_wildcard(threshold)
  threshold = threshold or 3

  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Parse imports
  local imports_by_package = {}
  local import_lines = {}
  local non_import_lines = {}
  local import_section_start = nil
  local import_section_end = nil

  for i, line in ipairs(lines) do
    -- Detect regular (non-static) imports
    local pkg, class = line:match("^import%s+([a-zA-Z0-9_.]+)%.([A-Z][a-zA-Z0-9_]*)%s*;%s*$")

    if pkg and class then
      if not import_section_start then
        import_section_start = i
      end
      import_section_end = i

      if not imports_by_package[pkg] then
        imports_by_package[pkg] = {}
      end
      table.insert(imports_by_package[pkg], class)
      table.insert(import_lines, { line_num = i, pkg = pkg, class = class })
    end
  end

  -- Check if any package needs wildcard
  local packages_to_wildcard = {}
  for pkg, classes in pairs(imports_by_package) do
    if #classes >= threshold then
      packages_to_wildcard[pkg] = true
    end
  end

  -- If no packages need collapsing, do nothing
  if vim.tbl_count(packages_to_wildcard) == 0 then
    vim.notify("No imports to collapse (threshold: " .. threshold .. ")", vim.log.levels.INFO)
    return
  end

  -- Build new import section
  local new_imports = {}
  local processed_packages = {}

  for pkg, classes in pairs(imports_by_package) do
    if packages_to_wildcard[pkg] and not processed_packages[pkg] then
      table.insert(new_imports, string.format("import %s.*;", pkg))
      processed_packages[pkg] = true
    elseif not packages_to_wildcard[pkg] then
      for _, class in ipairs(classes) do
        table.insert(new_imports, string.format("import %s.%s;", pkg, class))
      end
    end
  end

  -- Sort imports
  table.sort(new_imports)

  -- Replace import section
  if import_section_start and import_section_end then
    vim.api.nvim_buf_set_lines(bufnr, import_section_start - 1, import_section_end, false, new_imports)

    local collapsed_count = vim.tbl_count(packages_to_wildcard)
    vim.notify(string.format("Collapsed %d package(s) to wildcard", collapsed_count), vim.log.levels.INFO)
  end
end

-- Enhanced organize imports: First use JDTLS, then collapse to wildcards
function M.organize_imports_with_wildcards(threshold)
  threshold = threshold or 3

  -- First, use JDTLS to organize imports normally
  local ok, jdtls = pcall(require, 'jdtls')
  if ok and type(jdtls.organize_imports) == "function" then
    jdtls.organize_imports()

    -- Wait for JDTLS to finish, then collapse
    vim.defer_fn(function()
      M.collapse_imports_to_wildcard(threshold)
    end, 500)
  else
    vim.notify("JDTLS not available", vim.log.levels.ERROR)
  end
end

return M
