return {
    'VidocqH/lsp-lens.nvim',
    config = function()
      local SymbolKind = vim.lsp.protocol.SymbolKind
      require('lsp-lens').setup {
        enable = true,
        include_declaration = false,
        sections = {
          definition = true,
          references = true,
          implementation = true,
          git_authors = false,
        },
        -- Target Symbol Kinds to show lens information
        target_symbol_kinds = { SymbolKind.Function, SymbolKind.Method, SymbolKind.Interface, SymbolKind.Class, SymbolKind.Struct },
        -- Symbol Kinds that may have target symbol kinds as children
        wrapper_symbol_kinds = { SymbolKind.Class, SymbolKind.Struct },
      }
    end,
  }
