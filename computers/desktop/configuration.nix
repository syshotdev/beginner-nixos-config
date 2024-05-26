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
    outputs.nixosModules.optimizations.cpu
    outputs.nixosModules.optimizations.gpu
    outputs.nixosModules.optimizations.intelCPU
    outputs.nixosModules.optimizations.nvidia
    outputs.nixosModules.steam

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ../base.nix # Base system settings
  ];

  networking.hostName = "${computer}";

  # Users are defined in the (root)/users/ dir.
  # Defining users separately allows user-specific packages and personalized config like git username.
  users.users = {
    "neck" = {
      # TODO: Be sure to change this (using passwd) after rebooting!
      initialPassword = "e";
      isNormalUser = true;
      extraGroups = ["wheel" "dialout"];
    };
  };

  # Create the users from (root)/users/{name}/{computer-specific config}.nix (Works on every nixos rebuild)
  home-manager.users.neck = import ../../users/neck/${computer}.nix;


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
  system.stateVersion = "23.11";
}
