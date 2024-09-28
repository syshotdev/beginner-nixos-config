# TODO: Find a way to add bannedwords.txt to the directory of checknames.sh
{ pkgs, ... }:
let
  check-names = pkgs.writeScriptBin "check-names" 
    (builtins.readFile ./CheckNames.sh);
in {
  environment.systemPackages = [
    check-names
  ];
}
