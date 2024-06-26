-- For this to work, remember to put this into godot external editors:
-- --server ./godothost --remote-send "<C-\>:n {file}<CR>{line}G{col}|"

-- Basically the same thing as doing nvim --listen ./godothost
-- local gdproject = io.open(vim.fn.getcwd()..'/project.godot', 'r')
-- if gdproject then
--     io.close(gdproject)
--     vim.fn.serverstart './godothost'
-- end


local port = os.getenv('GDScript_Port') or '6005'
local cmd = vim.lsp.rpc.connect('127.0.0.1', port)
local pipe = '/tmp/godot.pipe'

vim.lsp.start({
  name = 'Godot',
  cmd = cmd,
  root_dir = vim.fs.dirname(vim.fs.find({ 'project.godot', '.git' }, { upward = true })[1]),
  on_attach = function(client, bufnr)
    vim.api.nvim_command('echo serverstart("' .. pipe .. '")')
  end
})

--[[
Extra docs lol:

Once this is set up, Godot's External Editor settings need to be updated to use Neovim with the following settings:

Use External Editor: On
Exec Path: nvim
Exec Flags: --server /tmp/godot.pipe --remote-send "<esc>:n {file}<CR>:call cursor({line},{col})<CR>"
]] --
