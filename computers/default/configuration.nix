# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # Import pre-configured system modules
    outputs.systemModules.optimizations.cpu # General optimizations
    outputs.systemModules.optimizations.gpu
    # outputs.systemModules.steam

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ../base.nix # Base system settings
  ];

  # Users are defined in the (root)/users/ dir.
  # Defining users separately allows user-specific packages and personalized config like git username.
  users.users = {
    "default" = {
      # TODO: Be sure to change this (using passwd) after rebooting!
      initialPassword = "e";
      isNormalUser = true;
      extraGroups = ["wheel" "dialout"];
    };
  };

  # Create the users. (root)/users/{user}/{computer}.nix (Works on every nixos rebuild)
  home-manager.users.default = import ../../users/default/default.nix;

  nixpkgs.overlays = [outputs.overlays.unstable-packages]; # Newer packages

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

    settings.trusted-users = ["sudo" "default"]; # TODO: Replace "default" with your user (if want to execute commands at all with sudo)
  };


  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
