local opts = { noremap = true }
local map = vim.keymap.set;

-- TODO: Remove 'opts' and replace with desc and noremap
-- Double quotes used because "lua require('')" messes stuff up
map('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>", opts)
map('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>", opts)
map('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>", opts)

-- Toggle Spectre for mass finding and renaming of words
map('n', '<leader>fr', "<cmd>lua require('spectre').toggle()<cr>", { desc = "Toggle Spectre", noremap = true })

-- (File)TreeToggle
map('n', '<leader>tt', '<cmd>NvimTreeToggle<cr>', opts)

-- <C-\> for terminal

-- Splits
map('n', '<leader>wh', '<cmd>split<cr>', opts)
map('n', '<leader>wv', '<cmd>vsplit<cr>', opts)

-- Navigate between splits
map('n', '<C-h>', '<cmd>wincmd h<cr>', opts)
map('n', '<C-j>', '<cmd>wincmd j<cr>', opts)
map('n', '<C-k>', '<cmd>wincmd k<cr>', opts)
map('n', '<C-l>', '<cmd>wincmd l<cr>', opts)

-- Tabs (I think they're like workspaces?)
map('n', '<leader>tn', '<cmd>tabnew<cr>', opts)
map('n', '<leader>th', '<cmd>tabprevious<cr>', opts)
map('n', '<leader>tl', '<cmd>tabnext<cr>', opts)
map('n', '<leader>tc', '<cmd>tabclose<cr>', opts)

-- Resize splits
map('n', '<C-Down>', '<cmd>resize +2<cr>', opts)
map('n', '<C-Up>', '<cmd>resize -2<cr>', opts)
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', opts)
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', opts)

-- Decimate the splits
map('n', '<C-q>', function()
  if vim.bo.modifiable and not vim.bo.readonly then
    vim.cmd('wq')
  else
    vim.cmd('q!')
  end
end, opts)


-- Key mappings for LSP
-- All of these do basically the same thing
map('n', '<leader>gd', vim.lsp.buf.definition, opts)
map('n', '<leader>gD', vim.lsp.buf.declaration, opts)
map('n', '<leader>gi', vim.lsp.buf.implementation, opts)

-- Where has this thing been used
map('n', '<leader>gr', vim.lsp.buf.references, opts)

-- c(code) a(action)
map('n', '<leader>ca', vim.lsp.buf.code_action, opts)
map('n', '<leader>cr', vim.lsp.buf.rename, opts)
map('n', '<leader>cf', function()
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

map('n', '<leader>D', vim.lsp.buf.type_definition, opts)
map('n', '<leader>fh', builtin.help_tags, {})
map('n', 'K', vim.lsp.buf.hover, opts)
map('n', '<C-k>', vim.lsp.buf.signature_help, opts)
map('n', 'wa', vim.lsp.buf.add_workspace_folder, opts)
map('n', 'wr', vim.lsp.buf.remove_workspace_folder, opts)
map('n', 'wl', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, opts)
]]
--
