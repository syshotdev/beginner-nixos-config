-- For this to work, remember to put this into godot external editors:
-- --server ./godothost --remote-send "<C-\>:n {file}<CR>{line}G{col}|"

-- Basically the same thing as doing nvim --listen ./godothost
-- local gdproject = io.open(vim.fn.getcwd()..'/project.godot', 'r')
-- if gdproject then
--     io.close(gdproject)
--     vim.fn.serverstart './godothost'
-- end

-- Used for removing the annoying error (EECON REFUSED BLAH BLAH BLAH)
local function is_port_open(host, port)
  local command = string.format("nc -z -v -w5 %s %s", host, port)
  local result = os.execute(command)
  return result == 0
end

-- I'm gonna be honest this has never worked

local port = os.getenv('GDScript_Port') or '6005'
local host = '127.0.0.1'

if is_port_open(host, port) then
  local cmd = vim.lsp.rpc.connect(host, port)
  local pipe = '/tmp/godot.pipe'

  vim.lsp.start({
    name = 'Godot',
    cmd = cmd,
    root_dir = vim.fs.dirname(vim.fs.find({ 'project.godot', '.git' }, { upward = true })[1]),
    on_attach = function(client, bufnr)
      vim.api.nvim_command('echo serverstart("' .. pipe .. '")')
    end
  })
else
  -- print("Info: GDScript LSP couldn't connect to " .. host .. ":" .. port)
end

--[[
Extra docs lol:

Once this is set up, Godot's External Editor settings need to be updated to use Neovim with the following settings:

Use External Editor: On
Exec Path: nvim
Exec Flags: --server /tmp/godot.pipe --remote-send "<esc>:n {file}<CR>:call cursor({line},{col})<CR>"
]]--
