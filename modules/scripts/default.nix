{ pkgs, config, ... }:
let
  # Helper function for making commands that you can execute via terminal
  mkScript = name: scriptPath: extraPackages:
    (pkgs.writeScriptBin name (builtins.readFile scriptPath)).overrideAttrs (old: {
      buildInputs = old.buildInputs or [] ++ extraPackages;
    });
in {
  # I really should figure out a way to OPTIONALLY add these scripts
  environment.systemPackages = [
    # TODO: Find a way to add bannedwords.txt to the directory of FindBannedInFiles.sh
    (mkScript "find-banned-in-files" ./FindBannedInFiles.sh [ pkgs.ripgrep ])
    (mkScript "publicize-folder" ./PublicizeFolder.sh [])
    (mkScript "rebuild" ./RebuildSystem.sh [])
    (mkScript "vr-run" ./VrRun.sh [ pkgs.patchelf ])
    (mkScript "force-mount-drive" ./ForceMountDrive.sh [ pkgs.ntfs3g ])
  ];
  # Alright the conundrum is: scriptModules is importing this file
  # It basically expects a SET not a FUNCTION, and that means we can't use pkgs in this script
  # and we can basically only list paths.
  # We can list paths to files that are functions, and then define all the scripts there but
  # I'm just super bummed out that I can't use all of this really smart code in this default.nix
  # because nix works in increasingly more and more confusing ways.
  #find-banned-in-files = mkScript "find-banned-in-files" ./FindBannedInFiles.sh [ pkgs.ripgrep ];
  #scripts = scripts;
  # To access put scriptModules.scripts in imports and it'll install all of 'em
  # Add all scripts to environment.systemPackages when imported
  #environment.systemPackages = config.environment.systemPackages or [] ++ scripts;
}
