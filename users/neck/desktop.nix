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
    outputs.homeModules.art.video_editing
    outputs.homeModules.art.video_recording
  ];

  home.packages = with pkgs; [ 
    zoom-us

    pinta # MS paint but linux

    # Nvidia specific stuff
    (blender.override { cudaSupport = true; })
    nvidia-system-monitor-qt

    autokey # Macro creator

    # VR
    alvr
    immersed-vr

    file # Package to distinguish appimages
    appimage-run

    # Tools for hard drive recovery
    ntfs3g

    # Age of Empires
    wineWowPackages.unstableFull
    dosbox-staging

    # Godot
    dotnet-sdk # To run godot
    (pkgs.callPackage outputs.customPackages.godot4-mono { })
  ];
}
