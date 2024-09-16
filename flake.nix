{
  description = "Combined Home Manager and NixOS configuration for crackz";

  inputs = {
    # Stable Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    # Unstable Nixpkgs for cutting-edge packages
    unstablenixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, unstablenixpkgs, home-manager, ... } @ inputs:
    let
      # Define both stable and unstable packages
      unstablepkgs = unstablenixpkgs.legacyPackages.x86_64-linux;
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      # NixOS system configuration
      nixosConfigurations.nixbox = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/configuration.nix  # Point to the NixOS system config file
        ];
        specialArgs = { inherit inputs; };
      };

      # Home Manager configuration
      homeConfigurations.crackz = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home-manager/home.nix  # Point to the Home Manager config file
        ];
      };
    };
}

