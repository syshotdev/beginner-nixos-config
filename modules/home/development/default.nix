{user, nickname, email, lib, ...}:
{
  imports = [
    (import ./git { inherit user nickname email lib; }) # Git specifically requires these variables to compile
    ./neovim
    #./godot4-mono
  ];
}
