-- [[ Configure LSP ]]
return {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',

        -- Useful status updates for LSP
        {'j-hui/fidget.nvim', opts = {}},

        {'Decodetalkers/csharpls-extended-lsp.nvim'}, {'SmiteshP/nvim-navic'}
    },
    config = function()
        vim.diagnostic.config({
            severity_sort = true,
            underline = true,
            signs = true,
            virtual_text = {spacing = 2},
            float = {border = 'rounded', source = 'if_many'}
        })

        require('mason').setup()

        require('mason-tool-installer').setup({
            ensure_installed = {
                'lua-language-server', 'clangd', 'ols',
                -- 'gopls',
                'html-lsp', 'typescript-language-server',
                'tailwindcss-language-server', 'stylua', 'codelldb', 'delve'
            }
        })

        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-attach',
                                                {clear = true}),

            callback = function(event)
                local fzf = require('fzf-lua')

                local client = vim.lsp.get_client_by_id(event.data.client_id)

                if client and client.server_capabilities.documentSymbolProvider then
                    require('nvim-navic').attach(client, event.buf)
                end

                -- Workaround: OLS doesn't show diagnostics on file open, only after save.
                -- https://github.com/DanielGavin/ols/issues/1206
                if client and client.name == "ols" then
                    vim.lsp.buf_notify( event.buf, "textDocument/didSave", {
                        textDocument = { uri = vim.uri_from_bufnr( event.buf ) },
                    } )
                end

                local map = function(keys, func, desc, mode)
                    mode = mode or 'n'

                    vim.keymap.set(mode, keys, func,
                                   {buffer = event.buf, desc = 'LSP: ' .. desc})
                end

                map('gd', function()
                    if client and client.name == 'csharp_ls' then
                        vim.lsp.buf.definition()
                    else
                        fzf.lsp_definitions()
                    end
                end, '[G]oto [D]efinition')

                map('gr', fzf.lsp_references, '[G]oto [R]eferences')
                map('gI', fzf.lsp_implementations,
                    '[G]oto [I]mplementation')

                map('<leader>D', fzf.lsp_typedefs,
                    'Type [D]efinition')
                map('<leader>ds', fzf.lsp_document_symbols,
                    '[D]ocument [S]ymbols')
                map('<leader>ws', fzf.lsp_live_workspace_symbols,
                    '[W]orkspace [S]ymbols')

                map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                map('K', vim.lsp.buf.hover, 'Hover Documentation')

                map('<C-k>', vim.lsp.buf.signature_help,
                    'Signature Documentation')

                map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                map('<leader>wa', vim.lsp.buf.add_workspace_folder,
                    '[W]orkspace [A]dd Folder')

                map('<leader>wr', vim.lsp.buf.remove_workspace_folder,
                    '[W]orkspace [R]emove Folder')

                map('<leader>wl', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, '[W]orkspace [L]ist Folders')

                map('<C-k>', function()
                    vim.lsp.buf.signature_help({border = 'rounded'})
                end, 'Show Signature', {'i', 'v'})

                if client and
                    client.server_capabilities.documentHighlightProvider then
                    local group = vim.api.nvim_create_augroup(
                                      'kickstart-lsp-highlight', {clear = false})

                    vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
                        group = group,
                        buffer = event.buf,
                        callback = vim.lsp.buf.document_highlight
                    })

                    vim.api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI'},
                                                {
                        group = group,
                        buffer = event.buf,
                        callback = vim.lsp.buf.clear_references
                    })
                end
            end
        })

        local servers = {
            gopls = {},
            ols = {
                init_options = {
                    checker_args = '-strict-style',
                    enable_inlay_hints_params = true,
                    enable_inlay_hints_default_params = true,
                    enable_inlay_hints_implicit_return = true,
                    enable_semantic_tokens = true,
                    enable_checker_only_saved = true,
                },
            },
            clangd = {},
            tailwindcss = {},
            ts_ls = {},
            html = {
                filetypes = {'html', 'twig', 'hbs'},
                init_options = {
                    configurationSection = {'html', 'css', 'javascript'},
                    embeddedLanguages = {css = true, javascript = true},
                    provideFormatter = false
                }
            },
            lua_ls = {
                settings = {
                    Lua = {
                        runtime = {version = 'LuaJIT'},
                        telemetry = {enable = false},
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                '${3rd}/luv/library',
                                unpack(vim.api.nvim_get_runtime_file('', true))
                            }
                        },
                        completion = {callSnippet = 'Replace'},
                        diagnostics = {disable = {'missing-fields'}}
                    }
                }
            }
        }

        vim.lsp.config('*', {capabilities = capabilities})

        for server_name, config in pairs(servers) do
            vim.lsp.config(server_name, config)
            vim.lsp.enable(server_name)
        end


    end
}
