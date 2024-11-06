# The terminal that this nixos instance uses
# I picked kitty because unicode support, hardware accel, tilability, fuzzy finding, and more
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kitty
    fzf
    fd
  ];

  fonts.packages = with pkgs; [
    nerdfonts
    jetbrains-mono
  ];

  # Link Kitty configuration
  environment.etc."xdg/kitty/kitty.conf".source = ./kitty.conf;
  environment.etc."xdg/kitty/gruvbox.conf".source = ./gruvbox.conf;

  # Link Fzf configuration
  environment.etc."profile.d/fzf.sh".text = ''
    # Enable fuzzy auto-completion and key bindings
    [ -f /etc/profile.d/fzf.bash ] && source /etc/profile.d/fzf.bash
    [ -f /etc/profile.d/fzf.zsh ] && source /etc/profile.d/fzf.zsh
  '';

  # Set kitty as default terminal
  environment.variables = {
    TERMINAL = "kitty";
  };
}
