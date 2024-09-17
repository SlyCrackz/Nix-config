{ pkgs, ... }:

{
  home.packages = with pkgs; [
    grim
    mako
    slurp
    wl-clipboard
    wmenu
    autotiling-rs
    kanshi
    libnotify
    waybar
  ];
  # Use your own sway config file
  xdg.configFile."sway/config".source = pkgs.lib.mkOverride 0 (builtins.toPath ./config);
  
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
      extraSessionCommands =
      #    export SDL_VIDEODRIVER=wayland
      #    export QT_QPA_PLATFORM=wayland
      ''    
          export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
          export _JAVA_AWT_WM_NONREPARENTING=1
          export MOZ_ENABLE_WAYLAND=1
          export WLR_DRM_DEVICES=/dev/dri/card1
      '';
      # Any other extra options you might want
      extraOptions = [ "--unsupported-gpu" ];
    };
}
