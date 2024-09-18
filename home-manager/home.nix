{ pkgs, ... }:

{
  imports = [
    ./modules/git.nix
    ./modules/sway/sway.nix
    ./modules/shell.nix
    ./modules/packages.nix
    ./modules/terminal.nix
    ./modules/media-tools.nix
    ./modules/yazi.nix
    ./modules/gaming.nix
  ];
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



  xdg.userDirs = {
    desktop = "~/desktop";
    download = "~/downloads";
    documents = "~/documents";
    music = "~/media/music";
    pictures = "~/media/pictures";
    videos = "~/media/videos";
  };

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}

