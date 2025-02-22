return {
    'neovim/nvim-lspconfig',

    dependencies =
    {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/nvim-cmp',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'stevearc/conform.nvim'
    },

    config = function()
        -- Setup code formatter
        local conform = require("conform")
        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "black" },
                cpp = { "clang-format" },
                c = { "clang-format" },

                -- Optional: fallback formatter for any file type
                ["_"] = { "trim_whitespace" }
            },

            -- Optional: Manual formatting command
            format_after_save = nil,
        })

        -- Auto format command
        vim.keymap.set({ "n", "v" }, "<leader>fc", function()
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 500,
            })
        end, { desc = "Format file or range" })

        -- Add cmp_nvim_lsp capabilities settings to lspconfig
        -- This should be executed before you configure any language server
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        -- mason automatically manages LSP servers
        require("mason").setup()
        require('mason-lspconfig').setup({
            ensure_installed =
            {
                "lua_ls",
                "clangd",
                "cmake",
                "dockerls",
                "pyright"
            },

            handlers =
            {
                function(server_name)
                    require('lspconfig')[server_name].setup({ capabilities = capabilities })
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
            },
        })

        local cmp = require('cmp')
        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
           mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            float = {
                max_width = 80,
                max_height = 10,
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },

            update_in_insert = true,
        })
    end
}
