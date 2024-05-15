{ lib, pkgs, home, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Extra dependencies for steamVR
  programs.steam.package = pkgs.steam.override {
    extraPkgs = pkgs: with pkgs; [ 
      libcap 
      procps
      usbutils
    ];
  };
}
