{pkgs, user, ...}:
let
  # Use `fetchGit` to download the repository
  handTrackingRepo = pkgs.fetchgit {
    url = "https://gitlab.freedesktop.org/monado/utilities/hand-tracking-models";
    #rev = "master"; # You can specify a commit hash or branch name
    sha256 = "sha256-2bkwTCrvoGO9YSg1NHWljFDpxy3QwLcFrw2XtPvmqCI="; # replace with actual hash
  };
in {
  services.monado = {
    enable = true;
    defaultRuntime = true; # Register as default OpenXR runtime
  };
  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
  };

  # Hand tracking
  system.activationScripts.copyMonadoModels = ''
    mkdir -p ~/.local/share/monado
    cp -r ${handTrackingRepo} ~/.local/share/monado/
  '';
}
