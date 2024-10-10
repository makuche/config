return {
  'AlexvZyl/nordic.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('nordic').load()
    vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = '#4c4846', underline = true })
    vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = '#4c4846', underline = true })
    vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = '#4c4846', underline = true })
  end,
},
{ 'norcalli/nvim-colorizer.lua' },
-- Highlight todo, notes, etc in comments
{ 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } }
