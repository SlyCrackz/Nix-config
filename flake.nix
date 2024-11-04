{
  description = "System and Home-Manager Flake";

  inputs = {
    # Stable Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    # Unstable Nixpkgs for cutting-edge packages
    unstablenixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # Lanzaboot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, unstablenixpkgs, home-manager, lanzaboote, ... }:
    let
      # Define both stable and unstable packages
      unstablepkgs = unstablenixpkgs.legacyPackages.x86_64-linux;
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      # NixOS system configuration
      nixosConfigurations.nixbox = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          lanzaboote.nixosModules.lanzaboote
          ./nixbox/configuration.nix # Point to the NixOS system config file
          ./nixbox/hardware-configuration.nix
          ./nixbox/boot.nix
          ./nixbox/plasma.nix
          ./nixbox/network.nix
          ./nixbox/packages.nix
          ./nixbox/services.nix
        ];
      };

      # Home Manager configuration
      homeConfigurations.crackz = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home-manager/home.nix # Point to the Home Manager config file
          ./home-manager/git.nix
          ./home-manager/shell.nix
          ./home-manager/packages.nix
          ./home-manager/terminal.nix
          ./home-manager/media-tools.nix
          ./home-manager/gaming.nix
          ./home-manager/yazi.nix
        ];
        extraSpecialArgs = {
          unstablepkgs = unstablepkgs;
        };
      };

      # caddy configuration
      nixosConfigurations.ct-caddy-101 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/container-base.nix # Point to the container config file
          ./modules/services/caddy.nix
        ];
      };

      # factorio server
      nixosConfigurations.ct-factorio-120 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/container-base.nix
          ./modules/services/factorio-server.nix
        ];
      };
    };
}

