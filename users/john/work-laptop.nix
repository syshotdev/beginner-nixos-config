# Configuration of the user "john" for computer "work-laptop"
{
  pkgs,
  ...
}: 
{
  imports = [
    ./base.nix # Import all base settings
  ];

  home.packages = with pkgs; [ 
    # thunderbird
    # nvidia-system-monitor-qt
  ];
}

