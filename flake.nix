{
  description = "Syshotdev's beginner flake that also has modules";

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
    # Everything inside this "let" statement are variables
    inherit (self) outputs;

    # Will make `computer` equal to the --flake .#{COMPUTER_NAME} eventually
    computer = "home-computer";
    # I saw a lot of repetitive code, so put it into variable
    specialArgs = {inherit inputs outputs nixpkgs computer;};
  in {
    # Everything inside these brackets are attributes, accessable via outputs.attribute
    systemModules = import ./modules/system; # Modules for system
    homeModules = import ./modules/home; # Modules for users
    scriptModules = import ./modules/scripts/temp.nix; # Scripts that I've made

    # Custom packages (to be built) not in the nix repository
    # This variable *only* lists the paths to the packages, you have to build them and include them into pkgs.
    customPackages = import ./modules/custom-packages;

    overlays = import ./modules/overlays {inherit inputs; };

    # NixOS configuration entrypoint
    # Available through 'sudo nixos-rebuild switch --flake .#computername'
    nixosConfigurations = {
      home-computer = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgs;
        modules = [
          home-manager.nixosModules.home-manager{
            home-manager.extraSpecialArgs = specialArgs;
          }
          
          ./computers/home-computer/configuration.nix
        ];
      };
      work-laptop = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgs;
        modules = [
          home-manager.nixosModules.home-manager{
            home-manager.extraSpecialArgs = specialArgs;
          }
          
          ./computers/work-laptop/configuration.nix
        ];
      };
    };
  };
}
