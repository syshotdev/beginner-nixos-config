-- Btw this was a config that I basically stole from MattCairnes's Nixos config.

-- Set no wrapping of text and <leader> key
vim.cmd [[
    set nowrap
    let mapleader = " "
]]


---------- QOL settings ----------

-- Working directories 
HOME = os.getenv("HOME")
vim.opt.backupdir = HOME .. '/.config/nvim/tmp/backup_files/'
vim.opt.directory = HOME .. '/.config/nvim/tmp/swap_files/'
vim.opt.undodir = HOME .. '/.config/nvim/tmp/undo_files/'

-- Indentation, how big in spaces and is it spaces and do I indent in functions?
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.bo.softtabstop = 2

-- No idea
vim.opt.scrolloff=10

-- Uhhh when you make a tab it opens to the right and bottom
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Line numbers stuff
vim.opt.number = true
vim.opt.numberwidth = 1
vim.opt.relativenumber = true

-- Clipboard for neovim (unnamedplus means system or whatever)
vim.opt.clipboard = 'unnamedplus'


---------- File tree ----------

-- Vim file tree disable
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour (For nvim-tree)
vim.opt.termguicolors = true

-- Nvim tree for file explorer
require("nvim-tree").setup()


---------- Other things that I didn't implement ----------

-- Don't know what this means
vim.opt.colorcolumn = '100'

vim.cmd([[
set completeopt=menu,menuone,noselect
]])

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ LSP Diagnostics ]]
local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
vim.diagnostic.config({
  virtual_text = true,
  update_in_insert = false,
})
-- You will likely want to reduce updatetime which affects CursorHold
-- note: this setting is global and should be set only once
vim.o.updatetime = 100
vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
