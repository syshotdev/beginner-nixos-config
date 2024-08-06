# This configuration file is shared by ALL of the computers, 
# to quickly set up essential services.
# Credits: my original config (made by the nixos installer), github user MattCairns with his
# nixos config, vimjoyer's videos, and a couple other people who are on GitHub. Thank you guys
{
  config,
  pkgs,
  user,
  lib,
  inputs,
  computer,
  ...
}: {
  # Bootloader stuff, like grub and if the system can boot
  boot.loader = {
    timeout = 120; # Seconds till grub chooses option to boot
    efi.canTouchEfiVariables = true;
    grub.enable = true;
    grub.efiSupport = true;
    grub.device = "nodev"; # Let the bootloader decide where to put grub (not manual)
  };

  # Hostname on network
  networking.hostName = "${computer}";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true; 
  };

  # Disable IPv6
  networking.enableIPv6 = false;
  boot.kernelParams = ["ipv6.disable=1"]; # Firefox takes a long time to load and apparantly this helps


  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8"; # (Select internationalisation properties.) What does that mean???
  # I'm not sure what this option does, but maybe something with time and identification.
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION= "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Extra nix options, like enabling flakes.
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
  };

  # Enable X11 and Cinnamon (For showing the desktop)
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.cinnamon.enable = true;

    # Settings for desktop, like theme and keybinds
    desktopManager.cinnamon = {
      extraGSettingsOverridePackages = with pkgs; [];
      extraGSettingsOverrides = '' '';
    };

    xkb.layout = "us"; # Probably keyboard layout
    xkb.variant = ""; # No idea what this means
  };

  environment.etc."dconf/db/local.d/00_custom-keybindings" = {
    text = ''
      [org/cinnamon/desktop/keybindings/custom-keybindings/custom0]
      name='Take Screenshot'
      command='gnome-screenshot -a'
      binding=['<Super><Shift>s']
    '';
  };

  environment.etc."dconf/db/local.d/locks/keybindings" = {
    text = ''
      # Prevent overriding custom keybindings
    '';
  };

  systemd.services.dconf-update = {
    description = "Update dconf database";
    after = [ "multi-user.target" ];
    serviceConfig.ExecStart = "${pkgs.dconf}/bin/dconf update";
    wantedBy = [ "multi-user.target" ];
  };

  # Sound stuff
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true; # This to make less audio stuttering
  services.pipewire = { 
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # This is for specifically (my) brother printer, may work with other companieisdxjcgbdsklhes printers
  services.printing = {
    enable = true;

    drivers = with pkgs; [ 
      gutenprint
      #gutenprintBin
      brlaser 
      brgenml1lpr
      brgenml1cupswrapper
    ];
  };
  services.avahi = { # Also printing stuff
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
  


  # Fonts because Chinese / Unicode characters don't show up correctly
  # fira-code because I'm a coder
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-extra
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    fira-code
  ];

  nixpkgs.config.allowUnfree = true; # Allow proprietary packages

  # Packages that should be enabled with every account.
  # (Might change this to be in the "Modules" area, 
  # for extra customizability)
  environment.systemPackages = with pkgs; [
    git
    firefox
    rhythmbox
    wget
    ripgrep
  ];

  system.stateVersion = "24.05"; # Version of system
}
