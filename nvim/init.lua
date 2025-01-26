require 'options'
require 'keymaps'
require 'plugin-manager'

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  desc = 'Remove trailing whitespace before buffer is written to file',
  pattern = { '*' },
  callback = function()
    if vim.g.remove_trailing_whitespace then
      vim.cmd [[%s/\s\+$//e]]
    end
  end,
})
vim.remove_trailing_whitespace = true -- add variable to control this behavior

local plugins = {
  require 'plugins.telescope', -- fuzzy find everything
  -- Colorize
  require 'plugins.color-scheme',
  require 'plugins.colorizer',
  require 'plugins.todo-highlight',

  -- LSP and tree-sitter
  require 'plugins.nvim-lspconfig',
  require 'plugins.treesitter',
  require 'plugins.lsp-lens', -- displays reference and definition info

  -- require 'plugins.vim-sleuth',  -- automatic tabs TODO: Check if required, and if, adapt
  require 'plugins.gitsigns',
  -- require 'plugins.avante', -- Cursor (IDE) like functionalities
  require 'plugins.which-key', -- previews key-bindings
  require 'plugins.autocompletion',
  require 'plugins.autoformat',
  require 'plugins.mini',
  require 'plugins.comment',
  require 'plugins.debug',
  -- require 'plugins.indent_line',
  require 'plugins.autopairs',
  -- require 'plugins.neo-tree',
  require 'plugins.auto-indent',
  require 'plugins.lsp-usage-lens',
  require 'plugins.oil',

  require 'plugins.llama',
}
local opts = {

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
}
require('lazy').setup(plugins, opts)

-- see `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
