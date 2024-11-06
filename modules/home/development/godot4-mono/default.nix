with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "godot4-mono";
  src = fetchFromGitHub {
    owner = "godotengine";
    repo = "godot";
    rev = "4.2.2-stable";
    hash = "sha256-anJgPEeHIW2qIALMfPduBVgbYYyz1PWCmPsZZxS9oHI=";
  };
  # Honestly I don't know how to add dependencies
  # This is useful but didn't solve my question:
  # https://blog.ielliott.io/nix-docs/mkDerivation.html
}

