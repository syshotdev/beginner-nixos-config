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
    appimage-run

    # Godot
    (pkgs.callPackage outputs.customPackages.godot4-mono { })

    # WEBKIT_DISABLE_DMABUF_RENDERER=1
    unstable.modrinth-app 
  ];
}
