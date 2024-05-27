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
    zoom-us
    obs-studio
    audacity

    # Nvidia specific stuff
    (blender.override { cudaSupport = true; })
    nvidia-system-monitor-qt

    file # Package to distinguish appimages

    # Godot
    (pkgs.callPackage outputs.customPackages.godot4-mono { })
    (pkgs.callPackage outputs.customPackages.modrinth { })
  ];
}
