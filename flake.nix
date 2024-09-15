{
  description = "NixOS configuration of crackz with unstable packages";

  inputs = {
    # Stable Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    # Unstable Nixpkgs for cutting-edge packages
    unstablenixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { nixpkgs, unstablenixpkgs, ... } @ inputs:
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
    };
}

