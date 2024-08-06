local opts = { noremap = true }


-- Double quotes used because "lua require('')" messes stuff up
vim.keymap.set('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>", opts)
vim.keymap.set('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>", opts)
vim.keymap.set('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>", opts)

-- (File)TreeToggle
vim.keymap.set('n', '<leader>tt', '<cmd>NvimTreeToggle<cr>', opts)

-- <C-\> for terminal

-- Splits
vim.keymap.set('n', '<leader>wh', '<cmd>split<cr>', opts)
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<cr>', opts)

-- Navigate between splits
vim.keymap.set('n', '<C-h>', '<cmd>wincmd h<cr>', opts)
vim.keymap.set('n', '<C-j>', '<cmd>wincmd j<cr>', opts)
vim.keymap.set('n', '<C-k>', '<cmd>wincmd k<cr>', opts)
vim.keymap.set('n', '<C-l>', '<cmd>wincmd l<cr>', opts)

-- Tabs (I think they're like workspaces?)
vim.keymap.set('n', '<leader>tn', '<cmd>tabnew<cr>', opts)
vim.keymap.set('n', '<leader>th', '<cmd>tabprevious<cr>', opts)
vim.keymap.set('n', '<leader>tl', '<cmd>tabnext<cr>', opts)
vim.keymap.set('n', '<leader>tc', '<cmd>tabclose<cr>', opts)

-- Resize splits
vim.keymap.set('n', '<C-Down>', '<cmd>resize +2<CR>', opts)
vim.keymap.set('n', '<C-Up>', '<cmd>resize -2<CR>', opts)
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', opts)
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', opts)

-- Decimate the splits
vim.keymap.set('n', '<C-q>', function()
  if vim.bo.modifiable and not vim.bo.readonly then
    vim.cmd('wq')
  else
    vim.cmd('q!')
  end
end, opts)


-- Key mappings for LSP
-- All of these do basically the same thing
vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, opts)
vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, opts)
vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, opts)

-- Where has this thing been used
vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, opts)

-- c(code) a(action)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, opts)
vim.keymap.set('n', '<leader>cf', function()
  vim.lsp.buf.format { async = true }
end, opts)

local function close_all_tabs_and_save()
  local tabpages = vim.api.nvim_list_tabpages()
  for _, tabpage in ipairs(tabpages) do
    local windows = vim.api.nvim_tabpage_list_wins(tabpage)
    for _, win in ipairs(windows) do
      local buf = vim.api.nvim_win_get_buf(win)
      local readonly = vim.api.nvim_buf_get_option(buf, 'readonly')
      if not readonly then
        vim.cmd('write')
      end
      vim.cmd('bdelete! ' .. buf)
    end
  end
end

-- QuitAllForce
vim.api.nvim_create_user_command('QuitAllForce', close_all_tabs_and_save, {})

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
]]
--
