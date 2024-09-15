{
  description = "Home Manager and NixOS configuration of crackz with unstable packages";

  inputs = {
    # Define both stable and unstable nixpkgs
    unstablenixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { unstablenixpkgs, nixpkgs, home-manager, ... } @ inputs:
    let
      # Define both stable and unstable packages
      unstablepkgs = unstablenixpkgs.legacyPackages.x86_64-linux;
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      # NixOS system configuration
      nixosConfigurations.nixbox = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix  # Your NixOS configuration file
        ];
        specialArgs = { inherit inputs; };
      };

      # Home Manager configuration
      homeConfigurations."crackz" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here
        modules = [ ./home.nix ];

      };
    };
}

