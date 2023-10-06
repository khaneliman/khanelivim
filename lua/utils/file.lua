local scan = require "plenary.scandir"

local contains = function(tbl, str)
  for _, v in ipairs(tbl) do
    if v == str then return true end
  end
  return false
end

local M = {}
--- Check if a path
M.exists = function(dir, file_pattern)
  local dirs = scan.scan_dir(dir, { depth = 1, search_pattern = file_pattern })
  return contains(dirs, dir .. "/" .. file_pattern)
end
return M
