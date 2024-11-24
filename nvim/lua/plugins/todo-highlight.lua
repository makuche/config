return {
  'folke/todo-comments.nvim',
  config = function()
    require('todo-comments').setup()
  end,
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = { signs = false },
}
