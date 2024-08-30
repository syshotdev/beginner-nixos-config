local map = vim.keymap.set;

-- TODO: Remove 'opts' and replace with desc and noremap
-- Double quotes used because "lua require('')" messes stuff up
map('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>", { desc = "Find Files", noremap = true })
map('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>", { desc = "Find Words", noremap = true })
map('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>", { desc = "Find Buffers", noremap = true })

-- Toggle Spectre for mass finding and renaming of words
map('n', '<leader>fr', "<cmd>lua require('spectre').toggle()<cr>", { desc = "Toggle Spectre", noremap = true })

-- FileTree(Toggle)
map('n', '<leader>ft', '<cmd>NvimTreeToggle<cr>', { desc = "Toggle File Tree", noremap = true })

-- <C-\> for terminal

-- Splits
map('n', '<leader>wh', '<cmd>split<cr>', { desc = "Window Horizontal Split", noremap = true })
map('n', '<leader>wv', '<cmd>vsplit<cr>', { desc = "Window Vertical Split", noremap = true })

-- Navigate between splits
map('n', '<C-h>', '<cmd>wincmd h<cr>', { desc = "Move To Split Left", noremap = true })
map('n', '<C-l>', '<cmd>wincmd l<cr>', { desc = "Move To Split Right", noremap = true })
map('n', '<C-k>', '<cmd>wincmd k<cr>', { desc = "Move To Split Up", noremap = true })
map('n', '<C-j>', '<cmd>wincmd j<cr>', { desc = "Move To Split Down", noremap = true })

-- Tabs (I think they're like workspaces?)
map('n', '<leader>tn', '<cmd>tabnew<cr>', { desc = "Tab New", noremap = true })
map('n', '<leader>tc', '<cmd>tabclose<cr>', { desc = "Tab Close", noremap = true })
-- Alt for easier access between them
map('n', '<A-h>', '<cmd>tabprevious<cr>', { desc = "Tab Previous", noremap = true })
map('n', '<A-l>', '<cmd>tabnext<cr>', { desc = "Tab Next", noremap = true })

-- Resize splits
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = "Resize Left", noremap = true })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = "Resize Right", noremap = true })
map('n', '<C-Up>', '<cmd>resize -2<cr>', { desc = "Resize Up", noremap = true })
map('n', '<C-Down>', '<cmd>resize +2<cr>', { desc = "Resize Down", noremap = true })

-- Force remove split
map('n', '<C-q>', function()
  if vim.bo.modifiable and not vim.bo.readonly then
    vim.cmd('wq')
  else
    vim.cmd('q!')
  end
end, { desc = "Force Close Split", noremap = true })


-- Key mappings for LSP
-- All of these do basically the same thing
map('n', '<leader>gd', vim.lsp.buf.definition, { desc = "Goto Definition", noremap = true })
map('n', '<leader>gD', vim.lsp.buf.declaration, { desc = "Goto Declaration", noremap = true })
map('n', '<leader>gi', vim.lsp.buf.implementation, { desc = "Goto Implementation", noremap = true })

-- Where has this thing been used
map('n', '<leader>gr', vim.lsp.buf.references, { desc = "Goto References", noremap = true })

-- c(code) a(action)
map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Code Action", noremap = true })
map('n', '<leader>cr', vim.lsp.buf.rename, { desc = "Code Rename", noremap = true })
map('n', '<leader>cf', function()
  vim.lsp.buf.format { async = true }
end, { desc = "Toggle Spectre", noremap = true })
map('v', '<leader>cs', '<cmd>sort<cr>', { desc = "Code Sort", noremap = true })

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
