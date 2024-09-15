{ config, pkgs, lib, ... }:

{
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
}
