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

    # What the computer is called, we use it alot so we put it into a variable.
    computer = "nixos"; 
  in {
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);


    nixosModules = import ./modules/system;

    customPackages = forAllSystems # Custom packages not in the nix repository
      (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./modules/customPackages { inherit inputs outputs; }
      );

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      "${computer}" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs computer;};
        modules = [
          ./computers/${computer}/configuration.nix
        ];
      };
    };

    # I want each user to have thier own home packages, and be able to enable/disable packages from
    # this configuration. However, it seems that we'll have to import home.nix into every single user's
    # configuration file and that's extra boilerplate that I don't want.
    # Also, how do I make new users? Do I just put it into users/{name}/default.nix and include it here?
    # How do I import the username? Idk it's all so confusing

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # Default user. Has everything disabled, but full config to allow easy setting up.
      "default@${computer}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs computer;};
        modules = [
          ./users/default
        ];
      };
      # My account, has every home package enabled. The name is an inside joke
      "neck@${computer}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs computer;};
        modules = [
          ./users/neck
        ];
      };
    };
  };
}
