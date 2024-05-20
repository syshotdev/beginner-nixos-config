# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  lib,
  config,
  pkgs,
  nickname,
  user,
  email,
  ...
}: {
  imports = [
    ./art
    #./communication
    #./development
    #./sound
    ./other
  ];

  # Just so you know, ChatGPT wrote this code because Idk what I'm doing
  /*options.enableCategories = lib.mkOption {
    type = lib.types.attrsOf lib.types.bool;
    default = {
      art = false;
      communication = false;
      development = false;
      sound = false;
      other = false;
    };
    example = {art = true;};
    description = "App groups for mass enabling and disabling";
  };*/

  options.enableCategories = with lib; {
    art.enable = mkEnableOption "Art programs, like blender";
    other.enable = mkEnableOption "Art programs, like blender";
  };
  # ChatGPT-written code ends here

  # Might be useful for understanding this file: https://nixos-and-flakes.thiscute.world/other-usage-of-flakes/module-system
}
