# This file was inspired by Matt Cairn's config on github, go check him out for a more full config
{
  pkgs,
  ...
}:
{
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraLuaConfig = ''
      -- Remember to put options in front of keymaps, as leader key won't work!
      -- https://neovim.discourse.group/t/how-to-set-leader-key-in-lua/175/3
      ${builtins.readFile config/options.lua}
      ${builtins.readFile config/keymaps.lua}
      ${builtins.readFile config/setup/gdscript.lua} -- Set up GDScript for Godot
    '';

    plugins = with pkgs.vimPlugins; [
      # Colorscheme
      { 
        plugin = gruvbox;
        config = "vim.cmd[[colorscheme gruvbox]]";
      	type = "lua";
      }
      {
        plugin = lualine-nvim;
        config = "
          require('lualine').setup {
            options = {
              theme = 'gruvbox',
            }
          }
        ";
	      type = "lua";
      }
      # Tabs, like in firefox
      {
        plugin = bufferline-nvim;
        config = builtins.readFile config/setup/telescope.lua;
        type = "lua";
      }
      # Toggle terminal
      {
        plugin = toggleterm-nvim;
        config = builtins.readFile config/setup/toggleterm.lua;
        type = "lua";
      }


      # Syntax highlighting
      {
        plugin = nvim-treesitter;
        config = ''
          require('nvim-treesitter.configs').setup {}
        '';
        type = "lua";
      }
      nvim-treesitter.withAllGrammars
      indentLine # Indent line
      # Better syntax-highlighting and indenting
      vim-nix
      vim-godot

      # Tree structure on the side with nvim-tree
      nvim-tree-lua
      nvim-web-devicons


      # File searching via telescope
      {
        plugin = telescope-nvim;
        config = builtins.readFile config/setup/telescope.lua;
	      type = "lua";
      }
      telescope-fzf-native-nvim # To fix fuzzy finding to be better
      # Tool to replace a word in all files
      nvim-spectre
      
      # What buttons do I press to do a command again?
      {
        plugin = which-key-nvim;
        config = ''require("which-key").setup {}'';
	      type = "lua";
      }

      # Signs for git
      {
        plugin = gitsigns-nvim;
        config = ''require("gitsigns").setup {}'';
	      type = "lua";
      }

      # Make it easier to pair up brackets [] and (){}<>
      {
        plugin = nvim-autopairs;
        config = ''require("nvim-autopairs").setup {}'';
	      type = "lua";
      }

      # LSP stuff (autocompletion)
      {
        plugin = nvim-lspconfig;
        config = builtins.readFile config/setup/lspconfig.lua;
	      type = "lua";
      }
      {
        plugin = nvim-cmp;
        config = builtins.readFile config/setup/cmp.lua;
	      type = "lua";
      }
      cmp-nvim-lsp
      luasnip
    ];
  };

  home.packages = with pkgs; [
    xsel # Add things to clipboard

    rust-analyzer
    jdt-language-server # Java
    gdtoolkit # GDscript
    lua-language-server
    ccls # C
    csharp-ls
    nil # Nix

    # Packages that are required as dependencies
    gcc
  ];
}
