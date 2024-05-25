with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "godot4-mono";
  src = fetchFromGitHub {
    owner = "godotengine";
    repo = "godot";
    rev = "4.2.2-stable";
    hash = "sha256-anJgPEeHIW2qIALMfPduBVgbYYyz1PWCmPsZZxS9oHI=";
  };
}

