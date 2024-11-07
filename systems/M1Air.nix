{ pkgs, ... }:

{
  # Unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enables Nix flakes and nix-command support
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.systemPackages = [ pkgs.home-manager ];
 
  environment.variables = {
    FLAKE = "/Users/crackz/Public/Nix-config";
  };

  networking.hostName = "M1Air";
  networking.localHostName = "M1Air";
  
  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts-emoji
    intel-one-mono
    (nerdfonts.override { fonts = [ "IntelOneMono" ]; })
  ];

  services.nix-daemon.enable = true;

  # NO TOUCHY
  system.stateVersion = 5;
}
