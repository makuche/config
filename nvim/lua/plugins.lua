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
					ensure_installed = {
						"bash",
						"c",
						"diff",
						"html",
						"lua",
						"luadoc",
						"markdown",
						"markdown_inline",
						"python",
						"vim",
						"vimdoc",
					},
					sync_install = true,
					auto_install = true,
					highlight = {
						enable = true,
					},
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
			opts = {
				registries = {
					"github:mason-org/mason-registry",
					"github:Crashdummyy/mason-registry",
				},
			},
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
			dependencies = {
				"saghen/blink.cmp",
				{ "williamboman/mason.nvim", config = true },
				"williamboman/mason-lspconfig.nvim",
				"WhoIsSethDaniel/mason-tool-installer.nvim",
				{ "j-hui/fidget.nvim", opts = {} },
			},
			config = function()
				vim.api.nvim_create_autocmd("LspAttach", {
					group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
					callback = function(event)
						local map = function(keys, func, desc)
							vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
						end

						-- Jump to the definition of a symbol
						map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
						-- Jump to the type of symbol
						map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
						-- Jump to references of symbol
						map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
						-- Jump to implementation
						map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
						-- Fuzzy find all symbols in current document
						map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
						-- Fuzzy find all symbols in current workspace
						map(
							"<leader>ws",
							require("telescope.builtin").lsp_dynamic_workspace_symbols,
							"[W]orkspace [S]ymbols"
						)
						-- Rename the variable under cursor
						map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
						-- Execute a code action
						map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
						-- Opens a popup with documentation
						map("K", vim.lsp.buf.hover, "Hover Documentation")
						-- Goto Declaration (e.g., header in C)
						map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

						-- Highlight references of the word under cursor when paused
						local client = vim.lsp.get_client_by_id(event.data.client_id)
						if client and client.server_capabilities.documentHighlightProvider then
							local highlight_augroup =
								vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
							vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
								buffer = event.buf,
								group = highlight_augroup,
								callback = vim.lsp.buf.document_highlight,
							})

							vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
								buffer = event.buf,
								group = highlight_augroup,
								callback = vim.lsp.buf.clear_references,
							})

							vim.api.nvim_create_autocmd("LspDetach", {
								group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
								callback = function(event2)
									vim.lsp.buf.clear_references()
									vim.api.nvim_clear_autocmds({
										group = "kickstart-lsp-highlight",
										buffer = event2.buf,
									})
								end,
							})
						end

						-- Toggle inlay hints if supported
						if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
							map("<leader>th", function()
								vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
							end, "[T]oggle Inlay [H]ints")
						end
					end,
				})

				-- Get capabilities from blink.cmp
				local capabilities = require("blink.cmp").get_lsp_capabilities()

				-- Language server configurations
				local servers = {
					bashls = {
						filetypes = { "sh", "bash" },
					},
					clangd = {
						filetypes = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
					},
					dockerls = {
						filetypes = { "dockerfile" },
					},
					gopls = {
						filetypes = { "go", "gomod" },
					},
					html = {
						filetypes = { "html" },
					},
					jsonls = {
						filetypes = { "json", "jsonc" },
					},
					texlab = {
						filetypes = { "tex", "latex" },
						settings = {
							texlab = {
								auxDirectory = ".",
								bibtexFormatter = "texlab",
								build = {
									args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
									executable = "latexmk",
									onSave = true,
								},
								chktex = {
									onEdit = false,
									onOpenAndSave = false,
								},
								diagnosticsDelay = 300,
								formatterLineLength = 80,
								forwardSearch = {
									args = {},
								},
								latexFormatter = "latexindent",
								latexindent = {
									["local"] = nil,
									modifyLineBreaks = false,
								},
							},
						},
						env = {
							PATH = vim.env.PATH,
							TEXMFHOME = vim.env.TEXMFHOME,
						},
					},
					pyright = {
						filetypes = { "python" },
					},
					sqlls = {
						filetypes = { "sql" },
					},
					terraformls = {
						filetypes = { "terraform", "tf" },
					},
					yamlls = {
						filetypes = { "yaml", "yml" },
					},
					ts_ls = {
						filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
					},
				}

				-- Ensure servers and tools are installed
				require("mason").setup()

				local ensure_installed = vim.tbl_keys(servers or {})
				vim.list_extend(ensure_installed, {
					"stylua",
					"latexindent",
					"black",
					"netcoredbg",
					"debugpy",
				})
				require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

				require("mason-lspconfig").setup({
					handlers = {
						function(server_name)
							local server = servers[server_name] or {}
							server.capabilities =
								vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
							require("lspconfig")[server_name].setup(server)
						end,
					},
				})

				-- Setup nixd LSP separately (not available in Mason)
				vim.lsp.config.nixd = {
					cmd = { "nixd" },
					settings = {
						nixd = {
							expr = "import <nixpkgs> { }",
						},
						formatting = {
							command = { "alejandra" },
						},
					},
				}
				vim.lsp.enable("nixd")
				vim.lsp.enable("roslyn")
			end,
		},
		{
			"seblyng/roslyn.nvim",
			opts = {
				filewatching = "auto",
			},
		},
		{
			"VidocqH/lsp-lens.nvim",
			config = function()
				local SymbolKind = vim.lsp.protocol.SymbolKind
				require("lsp-lens").setup({
					enable = true,
					include_declaration = false,
					sections = {
						definition = true,
						references = true,
						implementation = true,
						git_authors = false,
					},
					target_symbol_kinds = {
						SymbolKind.Function,
						SymbolKind.Method,
						SymbolKind.Interface,
						SymbolKind.Class,
						SymbolKind.Struct,
					},
					wrapper_symbol_kinds = { SymbolKind.Class, SymbolKind.Struct },
				})
			end,
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
				signature = { enabled = true, trigger = { enabled = true } },

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
		{
			"stevearc/conform.nvim",
			lazy = false,
			keys = {
				{
					"<leader>f",
					function()
						require("conform").format({ async = true, lsp_fallback = true })
					end,
					mode = "",
					desc = "[F]ormat buffer",
				},
			},
			opts = {
				notify_on_error = false,
				format_on_save = function(bufnr)
					local disable_filetypes = { c = true, cpp = true }
					return {
						timeout_ms = 500,
						lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
					}
				end,
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "black" },
					nix = { "alejandra" },
					tex = { "latexindent" },
					latex = { "latexindent" },
				},
			},
		},
		{ "qvalentin/helm-ls.nvim", ft = "helm" }, -- required to get helm file detection working properly
		{
			"lewis6991/gitsigns.nvim",
			opts = {
				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", bang = true })
						else
							gitsigns.nav_hunk("next")
						end
					end, { desc = "Jump to next git [c]hange" })

					map("n", "[c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							gitsigns.nav_hunk("prev")
						end
					end, { desc = "Jump to previous git [c]hange" })

					-- Actions
					map("v", "<leader>hs", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "stage git hunk" })
					map("v", "<leader>hr", function()
						gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "reset git hunk" })
					map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" })
					map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })
					map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" })
					map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "git [u]ndo stage hunk" })
					map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" })
					map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })
					map("n", "<leader>hb", gitsigns.blame_line, { desc = "git [b]lame line" })
					map("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" })
					map("n", "<leader>hD", function()
						gitsigns.diffthis("@")
					end, { desc = "git [D]iff against last commit" })
					-- Toggles
					map(
						"n",
						"<leader>tb",
						gitsigns.toggle_current_line_blame,
						{ desc = "[T]oggle git show [b]lame line" }
					)
					map("n", "<leader>tD", gitsigns.toggle_deleted, { desc = "[T]oggle git show [D]eleted" })
				end,
			},
		},
		{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true, opts = ... },
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
			"nvim-telescope/telescope.nvim",
			event = "VimEnter",
			branch = "master",
			dependencies = {
				"nvim-lua/plenary.nvim",
				{
					"nvim-telescope/telescope-fzf-native.nvim",
					build = "make",
					cond = function()
						return vim.fn.executable("make") == 1
					end,
				},
				{ "nvim-telescope/telescope-ui-select.nvim" },
				{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
			},
			config = function()
				require("telescope").setup({
					extensions = {
						["ui-select"] = {
							require("telescope.themes").get_dropdown(),
						},
					},
				})

				-- Enable Telescope extensions if installed
				pcall(require("telescope").load_extension, "fzf")
				pcall(require("telescope").load_extension, "ui-select")
			end,
		},
		{
			"stevearc/oil.nvim",
			opts = {},
			dependencies = { { "nvim-mini/mini.icons", opts = {} } },
		},
		{
			"windwp/nvim-autopairs",
			opts = {
				disable_filetype = { "TelescopePrompt", "vim" },
			},
		},
		{
			"echasnovski/mini.nvim",
			config = function()
				-- Better Around/Inside textobjects
				require("mini.ai").setup({ n_lines = 500 })
				-- Add/delete/replace surroundings (brackets, quotes, etc.)
				require("mini.surround").setup()
				-- Simple statusline
				local statusline = require("mini.statusline")
				statusline.setup({ use_icons = vim.g.have_nerd_font })
				statusline.section_location = function()
					return "%2l:%-2v"
				end
			end,
		},
		{
			"numToStr/Comment.nvim",
			opts = {},
		},
		{
			"NvChad/nvim-colorizer.lua",
			opts = {
				user_default_options = {
					names = false,
				},
			},
		},
		{
			"folke/todo-comments.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			opts = {},
		},
		{
			"mfussenegger/nvim-dap",
			dependencies = {
				"rcarriga/nvim-dap-ui",
				"nvim-neotest/nvim-nio",
				"nicholasmata/nvim-dap-cs",
				"mfussenegger/nvim-dap-python",
			},
			config = function()
				local dap = require("dap")
				local dapui = require("dapui")

				-- Setup dap-cs (auto-configures netcoredbg adapter)
				require("dap-cs").setup()

				-- Setup dap-python (use Mason's debugpy)
				require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")

				-- Setup dap-ui
				dapui.setup()

				-- Auto open/close UI
				dap.listeners.before.attach.dapui_config = function()
					dapui.open()
				end
				dap.listeners.before.launch.dapui_config = function()
					dapui.open()
				end
				dap.listeners.before.event_terminated.dapui_config = function()
					dapui.close()
				end
				dap.listeners.before.event_exited.dapui_config = function()
					dapui.close()
				end

				-- Keybindings
				vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "[D]ebug [B]reakpoint" })
				vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "[D]ebug [C]ontinue" })
				vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "[D]ebug Step [O]ver" })
				vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "[D]ebug Step [I]nto" })
				vim.keymap.set("n", "<leader>du", dap.step_out, { desc = "[D]ebug Step O[u]t" })
				vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "[D]ebug [R]EPL" })
				vim.keymap.set("n", "<leader>dt", dapui.toggle, { desc = "[D]ebug [T]oggle UI" })
				vim.keymap.set("n", "<leader>dq", function()
					dap.terminate()
					dapui.close()
				end, { desc = "[D]ebug [Q]uit" })
			end,
		},
	},
	-- Use writable location for lockfile (nvim config is read-only via Nix)
	lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
})
local colors = vim.fn.getcompletion("", "color")
local idx = 0

local function cycle_colorscheme()
	idx = idx % #colors + 1
	vim.cmd("colorscheme " .. colors[idx])
	print(colors[idx])
end

vim.keymap.set("n", "<C-k>", cycle_colorscheme)
