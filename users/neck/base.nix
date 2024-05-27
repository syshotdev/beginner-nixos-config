# Base configuration of the user "neck", meaning every machine inherits this stuff
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: 
let
  user = "neck";
  nickname = "syshotdev"; # Difference being that user is computer's user, and nickname is what your username online is.
  email = "syshotdev@gmail.com";
in {
  imports = [
    (import ../home-manager-boilerplate-code.nix { inherit user pkgs outputs; } )

    # Why all of these "user nickname email" stuff? For some reason, that's the only way
    # the packages know that they exist. The stuff up top (like inputs, pkgs, ..) get imported anyways
    (import ../../modules/home/art { inherit user nickname email; })
    (import ../../modules/home/communication { inherit user nickname email; })
    (import ../../modules/home/development { inherit user nickname email lib outputs inputs; })
    (import ../../modules/home/sound { inherit user nickname email; })
    (import ../../modules/home/other { inherit user nickname email; })
  ];

  # This is for adding packages that you don't need to configure through .nix files
  home.packages = with pkgs; [ 
    discord
    keepassxc
    rhythmbox
    
    ferium # Minecraft

    gnome.gnome-system-monitor

    jdk
  ];
}
