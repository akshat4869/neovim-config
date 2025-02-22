require("akshat.set")
require("akshat.remap")
require("akshat.lazy_init")

-- Create an autocommand group to specify key bindings for LSP
local augroup = vim.api.nvim_create_augroup
local akshatGroup = augroup('akshat', {})
local autocmd = vim.api.nvim_create_autocmd

autocmd('LspAttach', {
    group = akshatGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
        vim.keymap.set("n", "gtd", function() vim.lsp.buf.type_definition() end, opts)
        vim.keymap.set("n", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "<C-e>", function() vim.diagnostic.open_float({scope="line"}) end, opts)
    end
})
