{ config, pkgs, lib, ... }:

{
  imports = [
    ./modules/home/git.nix
    ./modules/home/sway.nix
    ./modules/home/shell.nix
    ./modules/home/packages.nix
    ./modules/home/terminal.nix
  ];
  home-manager.users.crackz = {
    home.username = "crackz";
    home.homeDirectory = "/home/crackz";
    home.sessionPath = [
    "/home/crackz/.local/bin/"
    ];

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

    # Use your own sway config file
    xdg.configFile."sway/config".source = pkgs.lib.mkOverride 0 (builtins.toPath ./sway/config);
    
    xdg.userDirs = {
      desktop = "/home/crackz/desktop";
      download = "/home/crackz/downloads";
      documents = "/home/crackz/documents";
      music = "/home/crackz/music";
      pictures = "/home/crackz/pictures";
      videos = "/home/crackz/videos";
    };

   home.stateVersion = "24.05";
   programs.home-manager.enable = true;
  };
}

