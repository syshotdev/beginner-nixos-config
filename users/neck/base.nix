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
    # The 'inherit user nickname ...;' syntax basically imports the variables for the packages to use.
    (import ../home-manager-boilerplate-code.nix { inherit user pkgs outputs; } )

    (import outputs.homeModules.development.git { inherit user nickname email lib; })
    outputs.homeModules.development.neovim
    outputs.homeModules.other.firefox
  ];

  # This is for adding packages that you don't need to configure through .nix files
  home.packages = with pkgs; [ 
    discord
    keepassxc # Password manager
    rhythmbox # Music player

    gnome.gnome-system-monitor # Task manager for linux

    lm_sensors # See temps of CPU

    yt-dlp # Youtube video downloader
    ffmpeg # Converts videos into audio formats and also other things
  ];
}
