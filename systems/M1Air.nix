{ pkgs, ... }:

{
  # Enables Nix flakes and nix-command support
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.systemPackages = with pkgs; [
    htop
  ];

  nixPackages.enableCorePackages = true;
  
  services.nix-daemon.enable = true;

  # NO TOUCHY
  system.stateVersion = 5;
}
