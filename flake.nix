{
  description = "Syshotdev's system configuration flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;

    # I saw a lot of repetitive code, so put it into variables
    computer = "desktop"; 
    specialArgs = {inherit inputs outputs computer nixpkgs;};
  in {
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);


    systemModules = import ./modules/system; # Modules for system
    homeModules = import ./modules/home; # Modules for users

    # Custom packages (to be built) not in the nix repository
    # This variable *only* lists the paths to the packages, you have to build them and include them into pkgs.
    customPackages = import ./modules/custom-packages;

    overlays = import ./modules/overlays {inherit inputs; };

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#computername'
    nixosConfigurations = {
      "${computer}" = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgs;
        modules = [
          home-manager.nixosModules.home-manager{
            home-manager.extraSpecialArgs = specialArgs;
          }
          
          ./computers/${computer}/configuration.nix
        ];
      };
    };

    # No more home-manager configurations :)
    # Now computers import users, and users are rebuilt on nixos-rebuild
  };
}
