{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: 
let
  user = "default";
  nickname = "default"; # Difference being that user is computer's user, and nickname is what your username online is.
  email = "default@default.com";
in {
  # You can import other home-manager modules here
  imports = [
    # Imports home-manager and a lot of packages, which we disable in this file
    ../../modules/home
  ];

  enableCategories = {
    art.enable = true;
  };
  categories.other.enable = true;

  # This is for adding packages that you don't need to configure... Like at all.
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
