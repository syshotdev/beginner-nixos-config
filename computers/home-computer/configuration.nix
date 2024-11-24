# Configuration file for computer "home-computer"
{
  inputs,
  outputs,
  computer,
  config,
  lib,
  pkgs,
  ...
}: 
{
  imports = [
    # Default optimizations, also try intel-cpu and nvidia-gpu
    # outputs.systemModules.optimizations.cpu
    # outputs.systemModules.optimizations.gpu

    outputs.scriptModules

    # Enable steam
    # outputs.systemModules.steam

    ./hardware-configuration.nix
    ../base.nix
  ];

  # Computer-wide packages
  environment.systemPackages = with pkgs; [
    # Idk what to put here
  ];

  # Give permissions to the users
  users.users = {
    "john" = {
      initialPassword = "e";
      isNormalUser = true;
      extraGroups = ["wheel" "dialout"];
    };
    "work" = {
      initialPassword = "e";
      isNormalUser = true;
      extraGroups = ["wheel" "dialout"];
    };
  };

  # Create the users. /users/{user}/{computer}.nix (Works on every nixos rebuild)
  home-manager.users.john = import ../../users/john/${computer}.nix;
  home-manager.users.work = import ../../users/work/${computer}.nix;

  nix.settings.trusted-users = ["sudo" "john" "work"]; # Who is given sudo permissions

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
