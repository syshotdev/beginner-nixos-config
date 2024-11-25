{ pkgs, config, ... }:
let
  # Helper function for making commands that you can execute via terminal
  mkScript = name: scriptPath:
    (pkgs.writeScriptBin name (builtins.readFile scriptPath));
in {
  # I really should figure out a way to OPTIONALLY add these scripts
  environment.systemPackages = with pkgs; [
    # TODO: Find a way to add bannedwords.txt to the directory of FindBannedInFiles.sh
    # Looking at it again, the forum thread that I made had the answer lol,
    # I just forgot to listen to him. Poor guy
    ripgrep
    (mkScript "find-banned-in-files" ./FindBannedInFiles.sh)
    (mkScript "publicize-folder" ./PublicizeFolder.sh)
    (mkScript "rebuild" ./RebuildSystem.sh)
    steam-run
    patchelf
    (mkScript "vr-run" ./VrRun.sh)
    ntfs3g
    (mkScript "force-mount-drive" ./ForceMountDrive.sh)
  ];
}
