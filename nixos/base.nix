# This configuration file is shared by ALL of the accounts, 
# to quickly set up essential services.
# Credits: my original config (made by the nixos installer), github user MattCairns with his
# nixos config, vimjoyer's videos, and a couple other people who are on GitHub. Thank you guys
{
  config,
  pkgs,
  user,
  lib,
  inputs,
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
  networking.hostName = "nixos";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true; # Other options when I understand what they do
  };

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
    desktopManager.mate.enable = true;

    xkb.layout = "us"; # Probably keyboard layout
    xkb.variant = ""; # No idea what this means
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

  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
  };

  
  nixpkgs.config.allowUnfree = true; # Allow proprietary packages

  # Packages that should be enabled with every account.
  # (Might change this to be in the "Modules" area, 
  # for extra customizability)
  environment.systemPackages = with pkgs; [
    git
    firefox
    rhythmbox
    wget
  ];

  system.stateVersion = "23.05"; # Version of system
}

