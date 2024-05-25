{ pkgs ? import <nixpkgs> { } }: rec {
  godot4-mono = pkgs.callPackage ./godot4-mono {};
}
