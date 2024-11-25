{ config, lib, pkgs, ... }:
{
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    # https://discourse.nixos.org/t/getting-an-error-has-anything-regarding-opengl-in-nixpkgs/3641/3
    setLdLibraryPath = true;
    # Mesa is general opengl drivers (I think)
    extraPackages = [ pkgs.mesa.drivers ];
  };
}
