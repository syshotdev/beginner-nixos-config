{
  description = "Syshotdev's system configuration flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # Cutting edge unstable releases
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
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

    # Will make `computer` equal to the --flake .#{COMPUTER_NAME} eventually
    computer = "desktop";
    # I saw a lot of repetitive code, so put it into variable
    specialArgs = {inherit inputs outputs nixpkgs computer;};
  in {
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);


    systemModules = import ./modules/system; # Modules for system
    homeModules = import ./modules/home; # Modules for users
    # Use the "import" keyword pls (I changed the insides and now it requires not importing it)
    scriptModules = import ./modules/scripts; # Scripts that I've made, modules because they're optional

    # Custom packages (to be built) not in the nix repository
    # This variable *only* lists the paths to the packages, you have to build them and include them into pkgs.
    customPackages = import ./modules/custom-packages;

    overlays = import ./modules/overlays {inherit inputs; };

    # NixOS configuration entrypoint
    # Available through 'sudo nixos-rebuild switch --flake .#computername'
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgs;
        modules = [
          home-manager.nixosModules.home-manager{
            home-manager.extraSpecialArgs = specialArgs;
          }
          
          ./computers/default/configuration.nix
        ];
      };
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgs;
        modules = [
          home-manager.nixosModules.home-manager{
            home-manager.extraSpecialArgs = specialArgs;
          }
          
          ./computers/desktop/configuration.nix
        ];
      };
      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgs;
        modules = [
          home-manager.nixosModules.home-manager{
            home-manager.extraSpecialArgs = specialArgs;
          }
          
          ./computers/laptop/configuration.nix
        ];
      };
    };
  };
}
