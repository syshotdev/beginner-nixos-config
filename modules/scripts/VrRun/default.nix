# Activate command "vr-run" to run apps in a vr sandbox, 
# with all of the environment variables, optimizations, and fixes applied

# Requires steam to be installed
{ pkgs, ... }:

let
  vr-run = pkgs.writeScriptBin "vr-run"
    (builtins.readFile ./VrRun.sh);
in {
  environment.systemPackages = [
    pkgs.patchelf # Dependency
    vr-run
  ];
}
