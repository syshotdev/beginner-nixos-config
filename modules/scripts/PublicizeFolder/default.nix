
{ pkgs, ... }:
let
  publicize-folder = pkgs.writeScriptBin "rebuild" 
    (builtins.readFile ./PublicizeFolder.sh);
in {
  environment.systemPackages = [
    publicize-folder
  ];
}
