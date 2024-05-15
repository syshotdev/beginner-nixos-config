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
      commit = {};
      rerere = {enabled = true;};
      core = {
        whitespace = "trailing-space,space-before-tab";
        editor = "vim";
      };
    };
  };
}
