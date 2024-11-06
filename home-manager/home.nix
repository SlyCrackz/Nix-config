{ pkgs, ... }:

{
  home.username = "crackz";

  # Enabling Flakes
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  xdg.enable = true;

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}

