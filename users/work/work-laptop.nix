# Configuration of the user "work" for computer "work-laptop"
{
  pkgs,
  ...
}: 
{
  imports = [
    ./base.nix # Import all base settings
  ];

  # More specific packages for the computer "work-laptop"
  # Each user has specific computer configurations because of cases like these
  # These are nvidia-specific programs
  home.packages = with pkgs; [ 
    # nvidia-system-monitor-qt
    # (blender.override { cudaSupport = true; })
  ];
}

