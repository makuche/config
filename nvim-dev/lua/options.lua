vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.splitbelow = true
vim.opt.splitright = true
-- vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus" -- vim clipboard uses system clipboard
vim.opt.scrolloff = 999 -- keep cursor in center, nicer for e.g. when using AR screen
vim.opt.virtualedit = "block"  -- nicer experience when using visual block mode
vim.opt.inccommand = "split" -- shows all changes of substitute command 
vim.opt.ignorecase = true -- autocomplete of builtin commands
vim.opt.termguicolors = true

-- diagnostics
vim.diagnostic.config(
    {
        virtual_lines=true
    })
vim.keymap.set('n', '<leader>td', function()
    local enabled = vim.diagnostic.is_enabled()
    print("toggling diagnostics")
    vim.diagnostic.enable(not enabled)
end, { desc = '[T]oggle [D]iagnostics' })
local test = 1
