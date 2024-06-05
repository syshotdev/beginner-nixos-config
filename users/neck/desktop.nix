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

    pinta # MS paint but linux

    # Godot
    mono
    (pkgs.callPackage outputs.customPackages.godot4-mono { })

    # ---------- MINECRAFT -----------

    # Java for minecraft
    #temurin-jre-bin-21 # Java runtime, not needed rn but maybe useful
    #unstable.jdk22
    #zulu17
    jdk17

    # WEBKIT_DISABLE_DMABUF_RENDERER=1
    # WEBKIT_DISABLE_COMPOSITING_MODE=1
    # export LD_LIBRARY_PATH=$(nix build --print-out-paths --no-link nixpkgs#libGL)/lib
    #unstable.modrinth-app-unwrapped # DOES NOT WORK!

    # JVM args: -Dfml.earlyprogresswindow=false
    #prismlauncher-unwrapped # The only launcher that worked (lol)
    prismlauncher

    # Maybe required packages for Minecraft?
    glfw
    glxinfo # LibGL info
    pciutils # lspci
  ];
}
