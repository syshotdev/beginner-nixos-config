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
    mbbz-hf

    fsv # File System Visualizer (For figuring out what's taking all my storage)

    pinta # MS paint but linux

    # Nvidia specific stuff
    (unstable.blender.override { cudaSupport = true; })
    nvidia-system-monitor-qt

    autokey # Macro creator

    # VR
    unstable.alvr
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

    gdb # temporary C debugger
  ];
}
