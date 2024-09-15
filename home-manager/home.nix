{ config, pkgs, lib, ... }:

{
  imports = [
    ./modules/git.nix
    ./modules/sway.nix
    ./modules/shell.nix
    ./modules/packages.nix
    ./modules/terminal.nix
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



    gtk = {
      enable = true;
      theme = {
        name = "Breeze-Dark";
        package = pkgs.libsForQt5.breeze-gtk;
      };
      iconTheme = {
        name = "breeze-icons";
        package = pkgs.libsForQt5.breeze-icons; 
      };
      cursorTheme = {
        name = "capitaine-cursors";
        package = pkgs.capitaine-cursors;
      };
      gtk3 = {
        extraConfig.gtk-application-prefer-dark-theme = true;
      };
    };

    home.pointerCursor = {
      gtk.enable = true;
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
      size = 16;
    };

    xdg.enable = true;

    # Use your own sway config file
    xdg.configFile."sway/config".source = pkgs.lib.mkOverride 0 (builtins.toPath ./sway/config);
    
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

