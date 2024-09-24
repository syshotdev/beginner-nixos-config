# This file houses all of my extra configs that I personally want on every one of my computers
# The reason this is separate from base.nix is because I don't think people would like these
# special scripts/utilities.
{
  config,
  pkgs,
  user,
  lib,
  inputs,
  computer,
  ...
}: {
  imports = [
    ./base.nix
  ];
}
