{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./base.nix # Import all base settings for user NECK
  ];

  home.packages = with pkgs; [ 
    # Art
    obs-studio
    audacity
    blender
    pinta # MS paint but linux

    # Godot
    (pkgs.callPackage outputs.customPackages.godot4-mono { })
  ];
}
