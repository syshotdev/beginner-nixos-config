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

    # ---------- MINECRAFT -----------

    # Java for minecraft
    #temurin-jre-bin-21 # Java runtime, not needed rn but maybe useful
    unstable.jdk22

    # WEBKIT_DISABLE_DMABUF_RENDERER=1
    # WEBKIT_DISABLE_COMPOSITING_MODE=1
    # export LD_LIBRARY_PATH=$(nix build --print-out-paths --no-link nixpkgs#libGL)/lib
    #unstable.modrinth-app-unwrapped # DOES NOT WORK!

    # JVM args: -Dfml.earlyprogresswindow=false
    prismlauncher-unwrapped # The only launcher that worked (lol)

    # Maybe required packages for Minecraft?
    glxinfo # LibGL info
    pciutils # lspci
  ];
}
