{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # Java for minecraft
    # Only two that work (I think)
    #jdk17
    jdk21_headless

    # WEBKIT_DISABLE_DMABUF_RENDERER=1
    # WEBKIT_DISABLE_COMPOSITING_MODE=1
    # export LD_LIBRARY_PATH=$(nix build --print-out-paths --no-link nixpkgs#libGL)/lib
    # JVM args: -Dfml.earlyprogresswindow=false
    prismlauncher

    unstable.cubiomes-viewer # Seed finder for Minecraft

    glfw
    glxinfo # LibGL info
    pciutils # lspci
  ];
}
