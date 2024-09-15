{ config, pkgs, lib, ... }:

{
  home-manager.users.crackz = {
    home.username = "crackz";
    home.homeDirectory = "/home/crackz";
    home.packages = [
      pkgs.firefox
      pkgs.autotiling-rs
      pkgs.wmenu
      pkgs.mako
      pkgs.grim
      pkgs.slurp
      pkgs.wl-clipboard
      pkgs.rustup
      pkgs.clang
      pkgs.kanshi
      pkgs.waybar
      pkgs.cava
      pkgs.jq
      pkgs.vesktop
      pkgs.pavucontrol
      pkgs.zellij
      pkgs.nodejs
      pkgs.lazydocker
      pkgs.lazygit
      pkgs.protonup-qt
      pkgs.fzf
      pkgs.ripgrep
      pkgs.cmatrix
      pkgs.appimage-run
      pkgs.unzip
    ];
    programs.bash.enable = true;

    programs = {
      nushell = { enable = true;
        # The config.nu can be anywhere you want if you like to edit your Nushell with Nu
        # for editing directly to config.nu 
        extraConfig = ''
         let carapace_completer = {|spans|
         carapace $spans.0 nushell $spans | from json
         }
         $env.config = {
          show_banner: false,
          completions: {
          case_sensitive: false # case-sensitive completions
          quick: true    # set to false to prevent auto-selecting completions
          partial: true    # set to false to prevent partial filling of the prompt
          algorithm: "fuzzy"    # prefix or fuzzy
          external: {
          # set to false to prevent nushell looking into $env.PATH to find more suggestions
              enable: true 
          # set to lower can improve completion performance at the cost of omitting some options
              max_results: 100 
              completer: $carapace_completer # check 'carapace_completer' 
            }
          }
         } 
         $env.PATH = ($env.PATH | 
         split row (char esep) |
         prepend /home/myuser/.apps |
         append /usr/bin/env
         )
         '';
         shellAliases = {
         v = "nvim";
         ff = "fastfetch";
         };
     };  
     carapace.enable = true;
     carapace.enableNushellIntegration = true;

     starship = { enable = true;
         settings = {
          add_newline = false;
           character = { 
           success_symbol = "[➜](bold green)";
           error_symbol = "[➜](bold red)";
         };
      };
    };
  };

    programs.git = {
      enable = true;
      userName  = "slycrackz";
      userEmail = "slycrackz@slycrackz.xyz";
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

    

    wayland.windowManager.sway = {
      enable = true;

      # Keep other options like environment and extra commands
      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
        export WLR_DRM_DEVICES=/dev/dri/card1
     '';

      # Any other extra options you might want
      extraOptions = [ "--unsupported-gpu" ];
    };

    # Use your own sway config file
    xdg.configFile."sway/config".source = pkgs.lib.mkOverride 0 (builtins.toPath ./sway/config);
    xdg.userDirs = {
      desktop = "$HOME/desktop";
      download = "$HOME/downloads";
      documents = "$HOME/documents";
      music = "$HOME/music";
      pictures = "$HOME/pictures";
      videos = "$HOME/videos";
    };


    programs.foot = {
    enable = true;
    settings = {
      main = {
        #term = "xterm-256color";
        font = "IntoneMono Nerd Font:size=11";
        dpi-aware = "yes";
        shell = "${pkgs.nushell}/bin/nu";  # Path to Nushell binary
      };

      colors = {
      foreground = "ebdbb2";  # $text
      background = "282828";  # $base

      regular0 = "282828";  # $base
      regular1 = "fb4934";  # $red
      regular2 = "b8bb26";  # $green
      regular3 = "d79921";  # $yellow
      regular4 = "83a598";  # $blue
      regular5 = "d3869b";  # $mauve
      regular6 = "689d6a";  # $teal
      regular7 = "ebdbb2";  # $text

      bright0 = "928374";  # $overlay1
      bright1 = "fb4934";  # $red
      bright2 = "b8bb26";  # $green
      bright3 = "d79921";  # $yellow
      bright4 = "83a598";  # $blue
      bright5 = "d3869b";  # $mauve
      bright6 = "689d6a";  # $teal
      bright7 = "fbf1c7";  # $rosewater
      };


      mouse = {
        hide-when-typing = "yes";
      };
  };
};


   home.stateVersion = "24.05";
   programs.home-manager.enable = true;
  };
}

