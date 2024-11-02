local M = {}
M._setup_complete = false
local api = vim.api
local lsp = vim.lsp
local config = require 'plugins.lsp-usage-lens.config'
local utils = require 'plugins.lsp-usage-lens.utils'

vim.notify 'Loading init.lua for lsp-usage-lens'
-- Get the correct LSP client method based on Neovim version
local lsp_get_clients = vim.version().minor >= 10 and lsp.get_clients or lsp.get_active_clients

local methods = {
  'textDocument/implementation',
  'textDocument/definition',
  'textDocument/references',
}

local state = {
  buf = nil, -- Buffer for the usage window
  win = nil, -- Window for the usage window
}

-- Get functions from document symbols (from your original code)
local function get_functions(result)
  local ret = {}
  for _, v in pairs(result or {}) do
    if vim.tbl_contains(config.config.target_symbol_kinds, v.kind) then
      if v.range and v.range.start then
        table.insert(ret, {
          name = v.name,
          rangeStart = v.range.start,
          rangeEnd = v.range['end'],
          selectionRangeStart = v.selectionRange.start,
          selectionRangeEnd = v.selectionRange['end'],
        })
      end
    end

    if vim.tbl_contains(config.config.wrapper_symbol_kinds, v.kind) then
      ret = utils:merge_table(ret, get_functions(v.children))
    end
  end
  return ret
end

-- Count results from LSP response
local function result_count(results)
  local ret = 0
  for _, res in pairs(results or {}) do
    for _, _ in pairs(res.result or {}) do
      ret = ret + 1
    end
  end
  return ret
end

-- Create display content
local function create_usage_content(functions_with_counts)
  local lines = {
    'LSP Usage Overview',
    string.rep('=', 40),
    '',
  }

  -- Sort by reference count
  table.sort(functions_with_counts, function(a, b)
    return (a.counts.reference or 0) > (b.counts.reference or 0)
  end)

  for _, func in ipairs(functions_with_counts) do
    local line =
      string.format('%s (refs: %d, impl: %d, def: %d)', func.name, func.counts.reference or 0, func.counts.implementation or 0, func.counts.definition or 0)
    table.insert(lines, line)
  end

  return lines
end

local function show_usage_window(content)
  -- Create or get buffer
  if not state.buf or not api.nvim_buf_is_valid(state.buf) then
    state.buf = api.nvim_create_buf(false, true)
  end

  -- Add a header showing the keymaps
  local header = {
    'Project-wide LSP Usage Overview',
    string.rep('=', 60),
    'Press q, <Esc>, or <C-c> to close this window',
    '',
  }

  -- Combine header with content
  local full_content = vim.list_extend(header, content)

  -- Make buffer modifiable, set content, then make unmodifiable
  api.nvim_buf_set_option(state.buf, 'modifiable', true)
  api.nvim_buf_set_lines(state.buf, 0, -1, false, full_content)
  api.nvim_buf_set_option(state.buf, 'modifiable', false)

  -- Calculate window size
  local width = config.config.window.width
  local height = #full_content + 2

  -- Create window config
  local win_opts = {
    relative = 'editor',
    width = width,
    height = height,
    col = vim.o.columns - width - 4,
    row = 2,
    style = 'minimal',
    border = config.config.window.border,
  }

  -- Create or update window
  if not state.win or not api.nvim_win_is_valid(state.win) then
    state.win = api.nvim_open_win(state.buf, true, win_opts) -- Changed to true to focus the window
  else
    api.nvim_win_set_config(state.win, win_opts)
    api.nvim_set_current_win(state.win) -- Focus the window
  end

  -- Set window options
  api.nvim_win_set_option(state.win, 'wrap', false)
  api.nvim_win_set_option(state.win, 'cursorline', true)

  -- Set buffer options
  api.nvim_buf_set_option(state.buf, 'bufhidden', 'wipe')
  api.nvim_buf_set_option(state.buf, 'buftype', 'nofile')
  api.nvim_buf_set_option(state.buf, 'swapfile', false)

  -- Clear existing keymaps
  api.nvim_buf_set_keymap(state.buf, 'n', 'q', '', {})
  api.nvim_buf_set_keymap(state.buf, 'n', '<Esc>', '', {})
  api.nvim_buf_set_keymap(state.buf, 'n', '<C-c>', '', {})

  -- Set new keymaps
  local close_cmd = string.format('<cmd>lua vim.api.nvim_win_close(%d, true)<CR>', state.win)

  -- Set keymaps with specific modes
  vim.keymap.set('n', 'q', close_cmd, { buffer = state.buf, silent = true, nowait = true })
  vim.keymap.set('n', '<Esc>', close_cmd, { buffer = state.buf, silent = true, nowait = true })
  vim.keymap.set('n', '<C-c>', close_cmd, { buffer = state.buf, silent = true, nowait = true })

  -- Add autocmd to make sure window can be closed
  vim.api.nvim_create_autocmd({ 'BufLeave', 'BufWinLeave' }, {
    buffer = state.buf,
    callback = function()
      if state.win and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_win_close(state.win, true)
      end
    end,
  })
end

-- Main function to show usage lens
function M.show_usage_lens()
  local bufnr = api.nvim_get_current_buf()

  -- Check if LSP is attached
  local has_lsp = false
  for _, client in pairs(lsp_get_clients { bufnr = bufnr }) do
    if client.supports_method 'textDocument/documentSymbol' then
      has_lsp = true
      break
    end
  end

  if not has_lsp then
    vim.notify('No LSP client attached', vim.log.levels.WARN)
    return
  end

  -- Get document symbols
  local params = { textDocument = lsp.util.make_text_document_params() }
  lsp.buf_request(bufnr, 'textDocument/documentSymbol', params, function(err, symbols)
    if err or not symbols then
      return
    end

    local functions = get_functions(symbols)
    local functions_with_counts = {}
    local pending = #functions

    if pending == 0 then
      vim.notify('No functions found', vim.log.levels.INFO)
      return
    end

    -- Get counts for each function
    for _, func in ipairs(functions) do
      local counts = {}
      local params = {
        textDocument = lsp.util.make_text_document_params(),
        position = {
          line = func.selectionRangeStart.line,
          character = func.selectionRangeStart.character,
        },
        context = { includeDeclaration = config.config.include_declaration },
      }

      -- Get all counts in parallel
      local function check_done()
        pending = pending - 1
        if pending == 0 then
          show_usage_window(create_usage_content(functions_with_counts))
        end
      end

      local function_info = {
        name = func.name,
        counts = counts,
      }
      table.insert(functions_with_counts, function_info)

      -- Get references
      lsp.buf_request_all(bufnr, methods[3], params, function(results)
        counts.reference = result_count(results)
        check_done()
      end)

      -- Get implementations
      lsp.buf_request_all(bufnr, methods[1], params, function(results)
        counts.implementation = result_count(results)
        check_done()
      end)

      -- Get definitions
      lsp.buf_request_all(bufnr, methods[2], params, function(results)
        counts.definition = result_count(results)
        check_done()
      end)
    end
  end)
end

function M.setup(opts)
  if M._setup_complete then
    return
  end

  config.setup(opts)
  api.nvim_create_user_command('LspUsageLens', M.show_usage_lens, {})
  M._setup_complete = true
end

return M
