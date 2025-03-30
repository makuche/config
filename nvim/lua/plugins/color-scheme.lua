return {
  'nuvic/flexoki-nvim',
  lazy = false,
  priority = 1000,
  config = function()
    vim.opt.termguicolors = true
    vim.cmd.colorscheme 'flexoki'
    vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = '#4c4846', underline = true })
    vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = '#4c4846', underline = true })
    vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = '#4c4846', underline = true })
    vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'TelescopeTitle', { bg = 'none' })
  end,
}
