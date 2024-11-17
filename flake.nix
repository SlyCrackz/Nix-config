{
  description = "System and Home-Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    unstablenixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixified-ai.url = "github:nixified-ai/flake";
    nvchad-starter = {
      url = "github:SlyCrackz/NvChad";
      flake = false;
    };
    nvchad4nix = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nvchad-starter.follows = "nvchad-starter";
    };
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, unstablenixpkgs, home-manager, lanzaboote, nixified-ai, nvchad4nix, nvchad-starter, darwin, ... }:
    let
      unstablePkgs = unstablenixpkgs.legacyPackages.x86_64-linux;
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      darwinPkgs = nixpkgs.legacyPackages.aarch64-darwin;
      unstableDarwinPkgs = unstablenixpkgs.legacyPackages.aarch64-darwin;
    in
    {
      # NixOS system configuration
      nixosConfigurations.nixbox = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = pkgs;
        config = {
          allowUnfree = true;
        };
        modules = [
          lanzaboote.nixosModules.lanzaboote
          ./systems/nixbox/configuration.nix
          ./systems/nixbox/hardware-configuration.nix
          ./modules/packages/core.nix
          ./modules/packages/extra.nix
          ./modules/ai.nix
          ./modules/pipewire.nix
          ./modules/tailscale.nix
          ./modules/plasma.nix
        ];
        specialArgs = {
          nixified-ai = nixified-ai;
        };
      };

      # macOS system configuration
      darwinConfigurations."m1air" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./systems/m1air.nix
          ./modules/packages/core.nix
        ];
      };

      # Home Manager configurations
      homeConfigurations = {
        "crackz" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          modules = [
            ./home-manager/home.nix
            ./home-manager/linux.nix
            ./modules/home-modules/git.nix
            ./modules/home-modules/shell.nix
            ./home-manager/packages.nix
            ./modules/home-modules/foot.nix
            ./modules/home-modules/media-tools.nix
            ./modules/home-modules/gaming.nix
            ./modules/home-modules/yazi.nix
            ./modules/home-modules/nvchad.nix
            ./modules/home-modules/java.nix
          ];
          extraSpecialArgs = {
            unstablepkgs = unstablePkgs;
            nvchad4nix = nvchad4nix;
            nvchad-starter = nvchad-starter;
          };
        };

        # Minimal macOS configuration on MacBookAir
        "crackz@m1air" = home-manager.lib.homeManagerConfiguration {
          pkgs = darwinPkgs;
          modules = [
            ./home-manager/home.nix
            ./home-manager/mac.nix
            ./home-manager/packages.nix
            ./modules/home-modules/git.nix
            ./modules/home-modules/nvchad.nix
            ./modules/home-modules/kitty.nix
            ./modules/home-modules/shell.nix
            ./modules/home-modules/yazi.nix
          ];
          extraSpecialArgs = {
            unstablepkgs = unstableDarwinPkgs;
            nvchad4nix = nvchad4nix;
            nvchad-starter = nvchad-starter;
          };
        };
      };

      # caddy configuration
      nixosConfigurations.ct-caddy-101 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/container-base.nix
          ./modules/packages/core.nix
          ./systems/ct-caddy-101.nix
        ];
      };

      # Factorio server configuration
      nixosConfigurations.ct-factorio-120 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/container-base.nix
          ./modules/packages/core.nix
          ./systems/ct-factorio-120.nix
        ];
      };

      # Hydra server configuration
      nixosConfigurations.ct-hydra-110 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/container-base.nix
          ./modules/packages/core.nix
          ./systems/ct-hydra-110.nix
        ];
      };

      # Hydra server configuration
      nixosConfigurations.template-nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = pkgs;
        modules = [
          ./modules/container-base.nix
        ];
      };
    };
}
