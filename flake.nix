{
  description = "My NixOS configuration with home-manager";

  inputs = {
    # Nixpkgs base (stable)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nixpkgs unstable for Neovim only
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux";
      unstablePkgs = import inputs.nixpkgs-unstable {
        system = system;
      };
    in
    {
      # NixOS Configuration
      nixosConfigurations = {
        nixbox = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager

            # Apply an overlay to use Neovim from nixpkgs-unstable only
            {
              nixpkgs.overlays = [
                (final: prev: {
                  neovim = unstablePkgs.neovim;  # Neovim from unstable
                })
              ];
            }
          ];
        };
      };

      # Home Manager Configuration
      homeConfigurations = {
        crackz = nixpkgs.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
          };
          modules = [
            ./home.nix
          ];
        };
      };
    };
}

