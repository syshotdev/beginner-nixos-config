# What's the point of this base.nix if it's already in {specific_user}'s directory?
# This base.nix is actually for specifically home-manager, so we don't need to type all of this stuff (again)
{user, pkgs, outputs, ...}:
{
  # Enable home-manager and git (Essential)
  programs.home-manager.enable = true;
  programs.git.enable = true;


  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
  };

  nixpkgs.config = {
    allowUnfree = true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = (_: true); # Ima be honest Idk if it was an issue in the first place
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
