# Configuration of the user "work" for computer "home-computer"
{
  pkgs,
  ...
}: 
{
  imports = [
    ./base.nix # Import all base settings
  ];

  home.packages = with pkgs; [ 
    # zoom-us
    # nvidia-system-monitor-qt
  ];
}

