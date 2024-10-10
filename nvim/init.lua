-- `:checkhealth`

-- leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- With this, neovim treats .h files as C files, so LSP works within header files
vim.g.c_syntax_for_h = true

require 'options'
require 'keymaps'
require 'plugin-manager'

-- :help lua-guide-autocommands
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = { '*' },
  command = [[%s/\s\+$//e]],
})

--
require('lazy').setup({
  require 'plugins.color-scheme',
  require 'plugins.lsp-lens',
  require 'plugins.vim-sleuth',
  require 'plugins.gitsigns',
  require 'plugins.avante',
  require 'plugins.which-key',
  require 'plugins.telescope',
  require 'plugins.nvim-lspconfig',
  require 'plugins.treesitter',
  require 'plugins.autocompletion',
  require 'plugins.autoformat',
  require 'plugins.mini',
  require 'plugins.comment',
  require 'plugins.debug',
  require 'plugins.indent_line',
  require 'plugins.autopairs',
  require 'plugins.neo-tree',
  -- require 'plugins.gitsigns',
  -- "gc" to comment visual regions/lines

}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
