local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- vim (!) global variable mapleader is set to " "
vim.g.mapleader = " "
vim.g.maplocalleader = "\\" -- TODO: check this
vim.keymap.set("n", "<Space>", "<Nop>") -- TODO: check this


-- Setup lazy.nvim
require("lazy").setup({
	{
	"rebelot/kanagawa.nvim",
	config = function()
		vim.cmd.colorscheme("kanagawa-wave")
	end,
	},
    {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    config = function()
        require("nvim-treesitter.configs").setup {
            ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
            sync_install = false,
            auto_install = true, -- installs the parser for languages that are not defined in 'ensure_installed'
            highlight = {
                enable = true,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<Leader>ss",
                node_incremental = "<Leader>si",
                scope_incremental = "<Leader>sc",
                node_decremental = "<Leader>sd",
            },
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true, -- moves cursor to the closest match, i.e. no need to be on the underlying object
                keymaps = {
                ["af"] = "@function.outer", -- example: 'daf' to delete function
                ["if"] = "@function.inner", -- example: 'dif' to delete only the body of the function
            },
            },
        },
    }
    end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",

    },
})
