# TODO: Find a way to add bannedwords.txt to the directory of checknames.sh
{ pkgs, ... }:
let
  check-names = { pkgs, ... }:
  pkgs.writeScriptBin "check-names" 
    (builtins.readFile ./CheckNames.sh);
in {
  /*environment.variables = {
    BANNED_WORDS = (builtins.readFile ./bannedwords.txt);
  };*/

  environment.systemPackages = [
    (check-names pkgs) # Execute function "check-names" with args pkgs
  ];
}
