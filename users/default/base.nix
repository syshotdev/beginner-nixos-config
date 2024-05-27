# Base file that all of the different variations of this user (for different computers) share
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: 
let
  # User specific variables. TODO: Change these
  user = "john"; # Computer user's name
  nickname = "Ilovecats0013"; # What they call you online (can be the same as computer username)
  email = "default@default.com";
in {
  imports = [
    (import ../home-manager-boilerplate-code.nix { inherit user pkgs outputs; } ) # Required

    # Disable these imports by either commenting them out or deleting them

    # Why all of these "user nickname email" stuff? For some reason, that's the only way
    # the packages know that the imports exist.
    (import ../../modules/home/art { inherit user nickname email; })
    (import ../../modules/home/communication { inherit user nickname email; })
    (import ../../modules/home/development { inherit user nickname email lib; })
    (import ../../modules/home/sound { inherit user nickname email; })
    (import ../../modules/home/other { inherit user nickname email; })
  ];

  # This is for adding packages that you don't need to configure through .nix files
  # https://search.nixos.org for packages
  home.packages = with pkgs; [ 
    # discord
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
