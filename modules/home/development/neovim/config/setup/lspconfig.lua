--[[
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

require'lspconfig'.dockerls.setup{capabilities=capabilities}

-- Vim stuff
require'lspconfig'.lua_ls.setup{capabilities=capabilities}
require'lspconfig'.vimls.setup{capabilities=capabilities}

-- Godot
require'lspconfig'.csharp_ls.setup{capabilities=capabilities}
require'lspconfig'.gdscript.setup{capabilities=capabilities}

-- Java
require'lspconfig'.gradle_ls.setup{capabilities=capabilities}
require'lspconfig'.jdtls.setup{capabilities=capabilities}

-- Rust
require'lspconfig'.rust_analyzer.setup{capabilities=capabilities}

-- "See :help vim.diagnostic.* for more documentation" - Matt Cairnes
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

    vim.api.nvim_set_keymap('n', '<leader>ca', '<cmd>CodeActionMenu<cr>', { noremap = true })
    vim.keymap.set('n', 'rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>fm', function()
      vim.lsp.buf.format { async = true }
    end, opts)

    vim.keymap.set('n', 'wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', 'wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', 'wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
  end
}) ]]--

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local servers = { 'dockerls', 'lua_ls', 'vimls', 'csharp_ls', 'gdscript', 'gradle_ls', 'jdtls', 'rust_analyzer' }

-- For every server, add these keymaps
for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup {
    capabilities = capabilities,
    -- Add client if you need it
    on_attach = function(bufnr)
      -- Key mappings for LSP
      local opts = { buffer = bufnr }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', 'rn', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', '<leader>fm', function()
        vim.lsp.buf.format { async = true }
      end, opts)
      vim.keymap.set('n', 'wa', vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set('n', 'wr', vim.lsp.buf.remove_workspace_folder, opts)
      vim.keymap.set('n', 'wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)
    end
  }
end


-- Specific lua-for-neovim setup
require'lspconfig'.lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  settings = {
    Lua = {}
  }
}
