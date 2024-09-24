{
  # Write script named "check-names" to path
  check-names = ./CheckNames/default.nix;
  #check-names = pkgs.writeScriptBin "check-names" (builtins.readFile ./CheckNames/CheckNames.sh);
}
