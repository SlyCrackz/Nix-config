{ pkgs, ... }:

{
  # Define system-wide packages here
  environment.systemPackages = with pkgs; [
    # Core tools for all systems
    fastfetch
    btop
    nh
    file
    unzip
    unrar
    nix-output-monitor
    nvd
    wget
  ];
}

