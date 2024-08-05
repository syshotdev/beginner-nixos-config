vim.keymap.set('n', 'ff', "<cmd>lua require('telescope.builtin').find_files()<cr>", { noremap = true })
vim.keymap.set('n', 'fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>", { noremap = true })
vim.keymap.set('n', 'fb', "<cmd>lua require('telescope.builtin').buffers()<cr>", { noremap = true })

-- Key mappings for LSP
local opts = { noremap = true, silent = true }
-- All of these do basically the same thing but declaration doesn't work
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

-- Where has this thing been used
vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

-- c(code) ...
vim.keymap.set('n', 'ca', vim.lsp.buf.code_action, opts)
vim.keymap.set('n', 'cn', vim.lsp.buf.rename, opts)
vim.keymap.set('n', 'cf', function()
  vim.lsp.buf.format { async = true }
end, opts)

--[[
-- I don't think these work/I don't need them rn:
-- 

vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
vim.keymap.set('n', 'wa', vim.lsp.buf.add_workspace_folder, opts)
vim.keymap.set('n', 'wr', vim.lsp.buf.remove_workspace_folder, opts)
vim.keymap.set('n', 'wl', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, opts)
]]--
