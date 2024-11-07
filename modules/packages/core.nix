{ pkgs, ... }:

{
  # Define system-wide packages here
  environment.systemPackages = with pkgs; [
    # Core tools for all systems
    fastfetch
    btop
    file
    unzip
    unrar
    cargo
    rustc
    wget
  ];
}

