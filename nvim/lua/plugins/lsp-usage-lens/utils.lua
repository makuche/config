local M = {}

function M:merge_table(t1, t2)
  for _, v in pairs(t2) do
    table.insert(t1, v)
  end
  return t1
end

function M:table_find(tbl, pred)
  for _, v in pairs(tbl) do
    if v == pred then
      return true
    end
  end
  return false
end

local requesting = {}

function M:is_buf_requesting(bufnr)
  return requesting[bufnr] or -1
end

function M:set_buf_requesting(bufnr, state)
  requesting[bufnr] = state
end

return M
