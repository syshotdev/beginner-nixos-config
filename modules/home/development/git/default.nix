{user, nickname, email, lib, ...}: 
let
  ssh = builtins.pathExists /home/${user}/.ssh/id_ed25519.pub;
in {
  programs.git = {
    enable = true;
    userName = "${nickname}";
    userEmail = "${email}";

    # If ssh key exists, put this config. Otherwise, go with simpler config
    extraConfig = (if ssh then {
      init = {defaultBranch = "main";};
      pull = {rebase = true;};
      rebase = {
        autostash = true;
        autosquash = true;
      };
      rerere = {enabled = true;};
      push = {autoSetupRemote = true;};

      commit = {gpgsign = true;};
      gpg = {format = "ssh";};
      user = {signingkey = "/home/${user}/.ssh/id_ed25519.pub";};

      core = {
        whitespace = "trailing-space,space-before-tab";
        editor = "vim";
      };
    } else {
      init = {defaultBranch = "main";};
      pull = {rebase = true;};
      rebase = {
        autostash = true;
        autosquash = true;
      };
      rerere = {enabled = true;};
      push = {autoSetupRemote = true;};

      core = {
        whitespace = "trailing-space,space-before-tab";
        editor = "vim";
      };
      });  
  };
}
