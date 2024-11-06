{ pkgs, ... }:
let
  rebuild-system = pkgs.writeScriptBin "rebuild" 
    (builtins.readFile ./RebuildSystem.sh);
in {
  environment.systemPackages = [
    rebuild-system
  ];
}

