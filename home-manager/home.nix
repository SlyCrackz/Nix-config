{ pkgs, ... }:

{
  home.username = "crackz";
  home.homeDirectory = "/home/crackz";
  home.sessionPath = [
    "/home/crackz/.local/bin/"
  ];


  # Enabling Flakes
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  xdg.enable = true;

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}

