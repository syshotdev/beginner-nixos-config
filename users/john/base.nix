# Base configuration of the user "john". Every machine that has this user inherits this file
{
  outputs,
  lib,
  pkgs,
  ...
}: 
let
  # User specific variables. TODO: Change these!
  user = "john"; # Computer user account's name
  nickname = "Ilovecats001"; # What they call you online (can be the same as computer username)
  email = "john.johnakin@gmail.com";
in {
  imports = [
    # Disable these imports by either commenting them out or deleting them

    # The 'inherit user nickname ...;' syntax basically imports the variables for the packages to use.
    (import ../home-manager-boilerplate-code.nix { inherit user pkgs outputs; } ) # Required, no remove

    (import outputs.homeModules.development.git { inherit user nickname email lib; })
    outputs.homeModules.development.neovim
    outputs.homeModules.other.firefox
  ];

  # This is for adding packages that you don't need to configure through .nix files
  home.packages = with pkgs; [ 
    #discord
  ];
} 
