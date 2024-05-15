{...}: {
  programs.git = {
    enable = true;
    userName = "Syshotdev";
    userEmail = "syshotdev@gmail.com";
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
      user = {signingkey = "/home/neck/.ssh/id_ed25519.pub";};
      core = {
        whitespace = "trailing-space,space-before-tab";
        editor = "vim";
      };
    };
  };
}
