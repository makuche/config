return {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  config = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'c', 'cpp', 'go', 'python' },
      callback = function()
        vim.bo.tabstop = 4
        vim.bo.shiftwidth = 2
        vim.bo.expandtab = true
      end,
    })
  end,
}
