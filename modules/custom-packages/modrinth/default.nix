{pkgs, lib, ...}: 
# For anyone trying to implement appimage stuff, wiki:
# https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-appimageTools
# And you have to install appimagekit rather than appimageTools
pkgs.appimageTools.wrapType2 { # or wrapType1
  name = "modrinth";
  src = pkgs.fetchurl {
    url = "https://launcher-files.modrinth.com/versions/0.7.1/linux/modrinth-app_0.7.1_amd64.AppImage";
    hash = "sha256-JPalOzTuyJ2fhlHaq4cdW+D+JhbajRY2CXKMLBkGwMU=";
  };
  extraPkgs = pkgs: with pkgs; [ libthai ];
}
