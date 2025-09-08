-- NOTE: CTRL [h|l|j|k] is managed via tmux

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Linter, Formatter, Diagnostic
vim.keymap.set('n', '<leader>f', function()
  require('conform').format { bufnr = 0 }
end)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>zig', '<cmd>LspRestart<cr>')

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Open filetree
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

-- this requires tmux-sessionizer located under /usr/local/bin/tmux-sessionizer
-- TODO: Same is used within tmux, check whether to use it only within tmux
vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww $HOME/.local/bin/tmux-sessionizer<CR>')

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

vim.keymap.set('x', '<leader>p', [["_dP]])

vim.keymap.set('n', '<leader>ss', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set('n', '<leader><leader>', function()
  vim.cmd 'so'
end)

-- AI stuff
vim.keymap.set('n', '<leader>cc', '<cmd>ClaudeCode<CR>', { desc = 'Toggle Claude Code' })
