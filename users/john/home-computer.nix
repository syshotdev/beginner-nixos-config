# Configuration of the user "john" for computer "home-computer"
{
  pkgs,
  ...
}: 
{
  imports = [
    ./base.nix # Import all base settings
  ];

  home.packages = with pkgs; [ 
    # prismlauncher # This is Minecraft
    # nvidia-system-monitor-qt
  ];
}

