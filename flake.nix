{
  description = "Nixbox Flake";

  inputs = {
    unstablenixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    # home-manager.url = "github:nix-community/home-manager"
  };

  outputs = { unstablenixpkgs, ... } @ inputs:
  let
    unstablepkgs = unstablenixpkgs.legacyPackages.x86_64-linux;
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
  in {
    packages.x86_64-linux = {
      # Use Neovim from the nixpkgs unstable input
      neovim-unstable = unstablepkgs.neovim;

      # Default package for this flake (can be any package)
      default = unstablepkgs.neovim;
    };
  };
}

