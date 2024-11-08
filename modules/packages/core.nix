{ pkgs, ... }:

{
  # Unrar
  nixpkgs.config.allowUnfree = true;

  # Define system-wide packages here
  environment.systemPackages = with pkgs; [
    # Core tools for all systems
    fastfetch
    btop
    file
    unzip
    unrar
    wget
    rustup #we want to move to nixshells but nvim doesnt like NOT having these
    clang # read above ^
  ];
}

