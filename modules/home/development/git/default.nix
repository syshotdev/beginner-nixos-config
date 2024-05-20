{user, nickname, email, ...}: {
  programs.git = {
    enable = true;
    userName = "${nickname}";
    userEmail = "${email}";
    extraConfig = {
      init = {defaultBranch = "main";};
      pull = {rebase = true;};
      rebase = {
        autostash = true;
        autosquash = true;
      };
      push = {autoSetupRemote = true;};
      commit = {gpgsign = true;};
      rerere = {enabled = true;};
      gpg = {format = "ssh";};
      user = {signingkey = "/home/${user}/.ssh/id_ed25519.pub";};
      core = {
        whitespace = "trailing-space,space-before-tab";
        editor = "vim";
      };
    };
  };
}
