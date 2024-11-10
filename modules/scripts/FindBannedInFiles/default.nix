# TODO: Find a way to add bannedwords.txt to the directory of FindBannedInFiles.sh
{ pkgs, ... }:
let
  find-banned-in-files = pkgs.writeScriptBin "find-banned-in-files" 
    (builtins.readFile ./FindBannedInFiles.sh);
in {
  environment.systemPackages = [
    find-banned-in-files
  ];
}
