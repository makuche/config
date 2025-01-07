vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.opt.shiftwidth = 4

vim.opt.number = true

vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

vim.opt.undofile = true -- Save undo history

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.tabstop = 4 -- How many columns a tab counts for
vim.opt.shiftwidth = 4 -- Size of an indent
vim.opt.expandtab = false -- Use spaces instead of tabs
vim.opt.softtabstop = 4 -- How many columns when you press Tab

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true

-- Detect Ansible files (for LSP)
vim.filetype.add {
  pattern = {
    -- Detect ansible files based on common patterns
    ['playbooks/.*.yml'] = 'yaml.ansible',
    ['roles/.*/tasks/.*.yml'] = 'yaml.ansible',
    ['roles/.*/handlers/.*.yml'] = 'yaml.ansible',
    ['roles/.*/defaults/.*.yml'] = 'yaml.ansible',
    ['roles/.*/vars/.*.yml'] = 'yaml.ansible',
    ['group_vars/.*.yml'] = 'yaml.ansible',
    ['host_vars/.*.yml'] = 'yaml.ansible',
    -- Match files that contain ansible common patterns
    ['.*ansible.*/*.yml'] = 'yaml.ansible',
  },
}
