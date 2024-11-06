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

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixified-ai.url = "github:nixified-ai/flake";

    nvchad-starter = {
      url = "github:SlyCrackz/NvChad";
      flake = false;
    };
    # NvChad for Nix
    nvchad4nix = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nvchad-starter.follows = "nvchad-starter";
    };

    #nix-darwin
    darwin.url = "github:LnL7/nix-darwin";
  };

 outputs = { nixpkgs, unstablenixpkgs, home-manager, lanzaboote, nix-ld, nixified-ai, nvchad4nix, nvchad-starter, darwin, ... }:
    let
      # Define both stable and unstable packages
      unstablepkgs = unstablenixpkgs.legacyPackages.x86_64-linux;
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      darwinPkgs = nixpkgs.legacyPackages.aarch64-darwin; # Add Darwin packages for macOS
    in
    {
      # NixOS system configuration
      nixosConfigurations.nixbox = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          lanzaboote.nixosModules.lanzaboote
          nix-ld.nixosModules.nix-ld
          ./systems/nixbox/configuration.nix # Point to the NixOS system config file
          ./systems/nixbox/hardware-configuration.nix
          ./modules/packages.nix
          ./modules/ai.nix
          ./modules/pipewire.nix
          ./modules/tailscale.nix
          ./modules/plasma.nix
        ];
        specialArgs = {
          nixified-ai = nixified-ai;
        };
      };

      # macOS configuration
      darwinConfigurations.macbook = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./systems/macbook.nix # Reference the macOS system config file
        ];
      };

      # Home Manager configuration
      homeConfigurations.crackz = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home-manager/home.nix # Point to the Home Manager config file
          ./modules/home-modules/git.nix
          ./modules/home-modules/shell.nix
          ./home-manager/packages.nix
          ./modules/home-modules/terminal.nix
          ./modules/home-modules/media-tools.nix
          ./modules/home-modules/gaming.nix
          ./modules/home-modules/yazi.nix
	  ./modules/home-modules/nvchad.nix
        ];
        extraSpecialArgs = {
          unstablepkgs = unstablepkgs;
	  nvchad4nix = nvchad4nix;
	  nvchad-starter = nvchad-starter;
        };
      };

      # caddy configuration
      nixosConfigurations.ct-caddy-101 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/container-base.nix # Point to the container config file
          ./modules/packages.nix
          ./systems/ct-caddy-101.nix
        ];
      };

      # factorio server
      nixosConfigurations.ct-factorio-120 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/container-base.nix
          ./modules/packages.nix
          ./systems/ct-factorio-120.nix
        ];
      };
      
      # hydra server
      nixosConfigurations.ct-hydra-110 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/container-base.nix
          ./modules/packages.nix
          ./systems/ct-hydra-110.nix
        ];
      };
    };
}

