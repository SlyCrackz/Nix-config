{ pkgs, config, lib, ... }:

{
  options = {
    sddmCustom.wallpaperPath = lib.mkOption {
      type = lib.types.str;
      description = "Path to the wallpaper file for SDDM.";
    };
  };

  config = let
    # Package the wallpaper from the provided path
    background-package = pkgs.stdenvNoCC.mkDerivation {
      name = "background-image";
      src = config.sddmCustom.wallpaperPath;
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out
        cp $src $out/wallpaper.png
      '';
    };
  in {
    # Enable SDDM with the custom background
    services.xserver.enable = true;
    services.displayManager.sddm = {
      enable = true;
      theme = "breeze";
      wayland.enable = true;
      wayland.compositor = "kwin";
    };

    # Set the SDDM theme configuration to use the custom background
    environment.systemPackages = [
      (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
        [General]
        background=${background-package}/wallpaper.png
      '')
    ];

    # Enable Plasma 6 and exclude specific packages
    services.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = with pkgs.libsForQt5; [
      kate
      elisa
      okular
      konsole
      oxygen
    ];
  };
}
