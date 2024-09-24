/*{ pkgs, ... }:
let
  check-names = ./CheckNames.sh;
  banned-words = "";# = ./bannedwords.txt;
in
pkgs.stdenv.mkDerivation {
  name = "check-names";

  src = check-names;

  installPhase = ''
    # Create output dir for bannedwords and script
    mkdir -p $out/bin

    echo "Script path: ${check-names}"
    echo "Banned words path: ${banned-words}"
    echo "Output directory: $out/bin"

    # Copy the script and the bannedwords.txt
    #cp ${check-names} $out/bin/CheckNames.sh
    #cp ${banned-words} $out/bin/bannedwords.txt
    #chmod +x $out/bin/CheckNames.sh
  '';
}*/
/*{ pkgs, ... }:
let
  check-names = { pkgs, ... }:
  pkgs.writeScriptBin "check-names" ''
    #!/bin/bash
    bannedwordsfile="${builtins.storePath ./bannedwords.txt}"
    bash ${builtins.storePath ./CheckNames.sh} "$bannedwordsfile"
  '';
in {
  environment.systemPackages = [
    (check-names pkgs)
  ];
}*/

/*
{ pkgs, ... }:
let
  banned-words = ./bannedwords.txt;

  # Write the CheckNames.sh script and reference the bannedwords.txt from the store
  check-names = pkgs.writeScriptBin "check-names" ''
    #!/bin/bash
    bannedwordsfile=${banned-words}
    bash ${./CheckNames.sh} "$bannedwordsfile"
  '';  
in {
  environment.systemPackages = [
    check-names
  ];
}
*/

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


/*
{ pkgs, ... }:
let
  hello-world = { pkgs, ... }:
    pkgs.writeShellScriptBin "hello-there.sh" ''
      echo "hello there" | lolcat
    '';
in {
  environment.systemPackages = [
    (({ pkgs, ... }:
    pkgs.writeShellScriptBin "hello-there.sh" ''
      echo "hello there" | lolcat
    '') pkgs)
  ];
}
*/
