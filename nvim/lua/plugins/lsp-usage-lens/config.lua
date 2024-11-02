local M = {}

M.default_config = {
  -- Keep the original configuration options
  target_symbol_kinds = {
    12, -- Function
    13, -- Method
  },
  wrapper_symbol_kinds = {
    5, -- Class
    11, -- Interface
    23, -- Namespace
  },
  ignore_filetype = {
    'help',
    'markdown',
    'text',
    'txt',
  },
  -- Add new window-specific options
  window = {
    width = 60,
    height = 20,
    border = 'rounded',
    position = 'right',
  },
  include_declaration = false,
}

M.config = vim.deepcopy(M.default_config)

function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})
end

return M
