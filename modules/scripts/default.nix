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
}
