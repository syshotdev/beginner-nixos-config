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
    pinta # MS paint but linux

    # Nvidia specific stuff
    (blender.override { cudaSupport = true; })
    nvidia-system-monitor-qt

    autokey # Macro creator

    kdenlive # Video Editor
    glaxnimate # Dependency for KDenLive

    handbrake # Turn video formats into other video formats

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

    # ---------- MINECRAFT -----------

    # Java for minecraft
    #temurin-jre-bin-21 # Java runtime, not needed rn but maybe useful
    #unstable.jdk22
    #zulu17
    #jdk17
    jdk21_headless

    # WEBKIT_DISABLE_DMABUF_RENDERER=1
    # WEBKIT_DISABLE_COMPOSITING_MODE=1
    # export LD_LIBRARY_PATH=$(nix build --print-out-paths --no-link nixpkgs#libGL)/lib
    #unstable.modrinth-app-unwrapped # DOES NOT WORK!

    # JVM args: -Dfml.earlyprogresswindow=false
    #prismlauncher-unwrapped # The only launcher that worked (lol)
    prismlauncher

    unstable.cubiomes-viewer # Seed finder for Minecraft

    # Maybe required packages for Minecraft?
    glfw
    glxinfo # LibGL info
    pciutils # lspci
  ];
}
