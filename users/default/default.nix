{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: 
let
  # User specific variables. TODO: Change these
  user = "default";
  nickname = "default"; # Difference being that user is computer's user, and nickname is what your username online is.
  email = "default@default.com";
in {
  imports = [
    # Disable these imports by either commenting them out or deleting them

    # Why all of these "user nickname email" stuff? For some reason, that's the only way
    # the packages know that they exist. The stuff up top (like inputs, pkgs, ..) get imported anyways
    (import ../../modules/home/art { inherit user nickname email; })
    (import ../../modules/home/communication { inherit user nickname email; })
    (import ../../modules/home/development { inherit user nickname email; })
    (import ../../modules/home/sound { inherit user nickname email; })
    (import ../../modules/home/other { inherit user nickname email; })
  ];

  # This is for adding packages that you don't need to configure through .nix files
  home.packages = with pkgs; [ 
    discord
    keepassxc
    audacity
    rhythmbox
    ferium # Minecraft
    nvidia-system-monitor-qt
    blender
    zoom-us
  ];

  # Enable home-manager and git (Essential)
  programs.home-manager.enable = true;
  programs.git.enable = true;


  home = {
    /* initialPassword = "e";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [  TODO: Add your SSH public key(s) here, if you plan on using SSH to connect ];
    extraGroups = ["wheel" "dialout"]; */

    username = "${user}";
    homeDirectory = "/home/${user}";
  };

  nixpkgs.config.allowUnfree = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
