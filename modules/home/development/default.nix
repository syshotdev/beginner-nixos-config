{user, nickname, email, ...}:
{
  imports = [
    (import ./git { inherit user nickname email; }) # Git specifically requires these variables to compile
    ./neovim
  ];
}
