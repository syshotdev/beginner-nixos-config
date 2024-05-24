{
  description = "A copy of a template with some changes for nixos";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

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

    # For the configuration.nix file, users should be sudo, set their passwords, check the checkbox
    # of "isNormalUser" and all of the user specific stuff. Maybe in the home-manager configuration
    # I can do that? It seems that I should be able to, however, I see that the home-manager probably
    # doesn't have permissions to do sudo for users, and maybe I can't even configure anything through
    # home-manager. I guess it's fine to add users manually inside configuration.nix, 
    # but it's just another step that's a hassle and doesn't seem necessary.

    nixosModules = import ./modules/system;

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
