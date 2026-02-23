local builtin = require("telescope.builtin")

-- Telescope keybindings
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sF", function()
	builtin.find_files({ hidden = true, prompt_title = "Find Files (incl. Hidden)" })
end, { desc = "[S]earch [F]iles (hidden)" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sG", function()
	builtin.live_grep({ additional_args = { "--hidden" }, prompt_title = "Live Grep (incl. Hidden)" })
end, { desc = "[S]earch by [G]rep (hidden)" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

-- Search in current buffer
vim.keymap.set("n", "<leader>/", function()
	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })

-- Search Neovim configuration files
vim.keymap.set("n", "<leader>sn", function()
	builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- fyi: native vim split keybinds:
--   <C-w>s  horizontal split
--   <C-w>v  vertical split
--   <C-w>q  close split
-- navigation across splits (and tmux panes) is handled by smart-splits.nvim via C-h/j/k/l

-- Diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", function()
	vim.diagnostic.config({ underline = true })
	local _, winnr = vim.diagnostic.open_float()
	if winnr then
		vim.api.nvim_create_autocmd("WinClosed", {
			pattern = tostring(winnr),
			once = true,
			callback = function()
				vim.diagnostic.config({ underline = false })
			end,
		})
	else
		vim.diagnostic.config({ underline = false })
	end
end, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
