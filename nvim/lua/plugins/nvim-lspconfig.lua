return { -- LSP Config & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    'saghen/blink.cmp',
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { 'j-hui/fidget.nvim', opts = {} },

    -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    { 'folke/neodev.nvim', opts = {} },
  },
  config = function()
    -- Language Servers are external tools i.e. must be installed separately from
    -- Neovim, which is what Mason is used for

    --  This function gets run when a buffer is opened, which corresponds to a file that is associated with an lsp
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end
        -- jump to the definition of a symbol (could be a function or variable)
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        -- jump to the type of symbol
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        -- jump to references of symbol
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        --  useful when language has ways of declaring types without implementation.
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        -- fuzzy find all the symbols in your current document.
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        -- fuzzy find all the symbols in your current workspace.
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        -- rename the variable under your cursor.
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        -- execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        -- opens a popup with documentation
        map('K', vim.lsp.buf.hover, 'Hover Documentation')

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- The following autocommand is used to enable inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    require('lspconfig').lua_ls.setup { capabilities = capabilities }
    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- Enable the following language servers
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    local servers = {
      bashls = {
        filetypes = { 'sh', 'bash' },
      },
      clangd = {
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'h', 'hpp' },
      },
      dockerls = {
        filetypes = { 'dockerfile' },
      },
      gopls = {
        filetypes = { 'go', 'gomod' },
      },
      html = {
        filetypes = { 'html' },
      },
      htmx = {
        filetypes = { 'html' },
      },
      jdtls = {
        filetypes = { 'java' },
      },
      jsonls = {
        filetypes = { 'json', 'jsonc' },
      },
      texlab = {
        filetypes = { 'tex', 'latex' },
        settings = {
          texlab = {
            auxDirectory = '.',
            bibtexFormatter = 'texlab',
            build = {
              args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
              executable = 'latexmk',
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
            latexFormatter = 'latexindent',
            latexindent = {
              ['local'] = nil, -- local is a reserved keyword in Lua
              modifyLineBreaks = false,
            },
          },
        },
        env = {
          PATH = vim.env.PATH,
          TEXMFHOME = vim.env.TEXMFHOME,
        },
      },
      -- texlab = {
      --   filetypes = { 'tex', 'latex' },
      -- },
      pyright = {
        filetypes = { 'python' },
      },
      -- ruff_lsp = {
      --   filetypes = { 'python' },
      -- },
      sqlls = {
        filetypes = { 'sql' },
      },
      terraformls = {
        filetypes = { 'terraform', 'tf' },
      },
      yamlls = {
        filetypes = { 'yaml', 'yml' },
        root_pattern = function(fname)
          local is_ansible = string.match(fname, 'roles/.*/*.yml$') or string.match(fname, 'playbooks/.*%.yml$') or string.match(fname, 'inventory/.*%.yml$')
          return not is_ansible
        end,
      },
      ansiblels = {
        -- Configure ansible-language-server
        filetypes = { 'yaml.ansible' },
        settings = {
          ansible = {
            validation = {
              lint = {
                enabled = true,
              },
            },
          },
        },
      },
      rust_analyzer = {
        filetypes = { 'rust' },
      },
      -- tsserver = {
      --   filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
      -- },
      -- rust_analyzer = {
      -- },
      -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
      --
      -- Some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim
      --
      -- But for many setups, the LSP (`tsserver`) will work just fine
      -- tsserver = {},
      --

      lua_ls = {
        -- cmd = {...},
        -- filetypes = { ...},
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
    }

    -- Ensure the servers and tools above are installed
    --  To check the current status of installed tools and/or manually install
    --  other tools, you can run
    --    :Mason
    --
    --  You can press `g?` for help in this menu.
    require('mason').setup()

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua', -- Used to format Lua code
      'latexindent',
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for tsserver)
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }

    -- setup nixd LSP separately, since its currently not availabnle through Mason
    require('lspconfig').nixd.setup {
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
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { '*.py', 'tex', 'latex', '*.nix' },
      callback = function()
        vim.api.nvim_create_autocmd('BufWritePre', {
          callback = function()
            vim.lsp.buf.format { async = false }
          end,
        })
      end,
    })
  end,
}
