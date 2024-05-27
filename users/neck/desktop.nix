{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
/*1let
  godot4-mono = pkgs.callPackage outputs.customPackages.godot4-mono { };
in*/
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
    (pkgs.callPackage outputs.customPackages.godot4-mono { })
  ];
}
