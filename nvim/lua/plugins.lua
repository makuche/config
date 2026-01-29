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
-- vim.keymap.set("n", "<Space>", "<Nop>") -- TODO: check this

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
	{
		"kepano/flexoki-neovim",
		name = "flexoki",
		config = function()
			vim.cmd.colorscheme("flexoki-dark")
			-- transparent background
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
		end,
	},
	{
		"rebelot/kanagawa.nvim",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
				sync_install = true,
				auto_install = true,
			})
			-- Enable treesitter-based highlighting
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					pcall(vim.treesitter.start)
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			-- Textobjects keymaps
			vim.keymap.set({ "x", "o" }, "af", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "if", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
			end)
		end,
	},
    {
        "williamboman/mason.nvim",
        opts = {}
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },
	{
		"neovim/nvim-lspconfig",
        config = function ()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end
                    -- jump to the definition of a symbol (could be a function or variable)
                    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                end
            })
            -- nixd not available in Mason
            vim.lsp.config.nixd = {
                cmd = { 'nixd' },
                settings = {
                    nixd = {
                        expr = 'import <nixpkgs> { }',
                    },
                    formatting = {
                        command = { 'alejandra' },
                    },
                },
            }
            vim.lsp.enable('nixd')
        end
	},
    {
        "saghen/blink.cmp",
        dependencies = { "rafamadriz/friendly-snippets" },
        version = "1.*",
        opts = {
            keymap = { preset = "default" },
            appearance = {
                nerd_font_variant = "mono",
            },

            completion = { documentation = { auto_show = true } },
            signature = { enabled = true, trigger = { enabled = true}, },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "prefer_rust_with_warning" },
        },
        opts_extend = { "sources.default" },
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    { "qvalentin/helm-ls.nvim", ft = "helm" }, -- required to get helm file detection working properly
    { "lewis6991/gitsigns.nvim" },
    { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ... },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    {
        'nvim-telescope/telescope.nvim', tag = 'v0.2.0',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        "stevearc/oil.nvim",
        opts = {},
        dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    },
    {
        "windwp/nvim-autopairs",
        opts = {
            disable_filetype = { "TelescopePrompt" , "vim" },
        }
    },
	},
	-- Use writable location for lockfile (nvim config is read-only via Nix)
	lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
})
local colors = vim.fn.getcompletion('', 'color')
local idx = 0

local function cycle_colorscheme()
  idx = idx % #colors + 1
  vim.cmd('colorscheme ' .. colors[idx])
  print(colors[idx])
end

vim.keymap.set('n', '<C-k>', cycle_colorscheme)
