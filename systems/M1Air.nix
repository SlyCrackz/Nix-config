{ pkgs, ... }:

{
  # Unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enables Nix flakes and nix-command support
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.systemPackages = [ pkgs.home-manager ];
  
  services.nix-daemon.enable = true;

  # NO TOUCHY
  system.stateVersion = 5;
}
