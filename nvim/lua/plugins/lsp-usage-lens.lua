return {
  dir = vim.fn.stdpath 'config' .. '/lua/plugins/lsp-usage-lens',
  name = 'lsp-usage-lens',
  config = function()
    local ok, module = pcall(require, 'plugins.lsp-usage-lens.init')
    if not ok then
      vim.notify('Failed to load module: ' .. tostring(module), vim.log.levels.ERROR)
      return
    end

    -- Only setup once
    if not module._setup_complete then
      module.setup {
        window = {
          width = 60,
          border = 'rounded',
          position = 'right',
        },
      }
      module._setup_complete = true
    end
  end,
}
