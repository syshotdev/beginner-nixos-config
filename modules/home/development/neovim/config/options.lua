-- Btw this was a config that I basically stole from MattCairnes's Nixos config.

-- Set no wrapping of text and <leader> key
vim.cmd [[
    set nowrap
]]

local opt = vim.opt
local bo = vim.bo
local g = vim.g

g.mapleader = ' '

---------- Colorscheme stuff ---------- 

opt.background = 'dark'
g.gruvbox_contrast_dark = 'medium'
g.gruvbox_invert_selection = '0'

-- No italics because it would take too much work for a joke

---------- QOL settings ----------

-- Working directories 
HOME = os.getenv("HOME")
opt.backupdir = HOME .. '/.config/nvim/tmp/backup_files/'
opt.directory = HOME .. '/.config/nvim/tmp/swap_files/'
opt.undodir = HOME .. '/.config/nvim/tmp/undo_files/'

-- Indentation, how big in spaces and is it spaces and do I indent in functions?
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
bo.softtabstop = 2

-- No idea
opt.scrolloff=10

-- Uhhh when you make a tab it opens to the right and bottom
opt.splitright = true
opt.splitbelow = true

-- Line numbers stuff
opt.number = true
opt.numberwidth = 1
opt.relativenumber = true

-- Clipboard for neovim (unnamedplus means system or whatever)
opt.clipboard = 'unnamedplus'

-- Use mouse
opt.mouse = 'a'

-- Makes it easier to type commands?:
opt.smartcase = true


---------- File tree ----------

-- Vim file tree disable
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour (For nvim-tree)
opt.cursorline = true
opt.termguicolors = true

-- Nvim tree for file explorer
require("nvim-tree").setup()


---------- Other things that I didn't implement ----------

-- Don't know what this means
opt.colorcolumn = '100'

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
