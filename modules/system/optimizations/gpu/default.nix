{ config, lib, pkgs, ... }:
{
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    # Mesa is general opengl drivers (I think)
    extraPackages = [ pkgs.mesa.drivers ];
  };
}
