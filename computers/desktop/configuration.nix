# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  computer,
  ...
}: 
{
  imports = [
    outputs.systemModules.optimizations.cpu
    outputs.systemModules.optimizations.gpu
    outputs.systemModules.optimizations.intelCPU
    outputs.systemModules.optimizations.nvidia
    outputs.systemModules.steam

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ../base.nix # Base system settings
  ];

  environment.systemPackages = with pkgs; [ appimagekit ];

  # Users are defined in the (root)/users/ dir.
  # Defining users separately allows user-specific packages and personalized config like git username.
  users.users = {
    "neck" = {
      # TODO: Be sure to change this (using passwd) after rebooting!
      # Another TODO: Hash the passwords
      initialPassword = "e";
      isNormalUser = true;
      extraGroups = ["wheel" "dialout"];
    };
  };

  # Create the users from (root)/users/{name}/{computer-specific config}.nix (Works on every nixos rebuild)
  home-manager.users.neck = import ../../users/neck/${computer}.nix;

  nixpkgs.overlays = [outputs.overlays.unstable-packages]; # I think this adds unstable packages

  # I don't know what this code does. Let's call it "magic" and not touch it for now
  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

    settings.trusted-users = ["sudo" "neck"]; # Who is given sudo permissions
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
