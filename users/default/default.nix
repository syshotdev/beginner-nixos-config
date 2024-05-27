{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: 
{
  imports = [
    ./base.nix # Import all base settings
  ];

  # More specific packages for the computer "default"
  home.packages = with pkgs; [ 
    # nvidia-system-monitor-qt
  ];
}

