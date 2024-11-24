{ pkgs, config, ... }:
let
  # Helper function for making commands that you can execute via terminal
  mkScript = name: scriptPath: extraPackages:
    (pkgs.writeScriptBin name (builtins.readFile scriptPath));
in {
  # I really should figure out a way to OPTIONALLY add these scripts
  environment.systemPackages = [
    # TODO: Find a way to add bannedwords.txt to the directory of FindBannedInFiles.sh
    # Looking at it again, the forum thread that I made had the answer lol,
    # I just forgot to listen to him. Poor guy
    pkgs.ripgrep
    (mkScript "find-banned-in-files" ./FindBannedInFiles.sh)
    (mkScript "publicize-folder" ./PublicizeFolder.sh)
    (mkScript "rebuild" ./RebuildSystem.sh)
    pkgs.patchelf
    (mkScript "vr-run" ./VrRun.sh)
    pkgs.ntfs3g
    (mkScript "force-mount-drive" ./ForceMountDrive.sh)
  ];
}
