{ pkgs, ... }:

{
  config =
    let
      # Fetch the wallpaper from the URL
      background-package = pkgs.stdenvNoCC.mkDerivation {
        name = "background-image";
        src = pkgs.fetchurl {
          url = "https://github.com/lunik1/nixos-logo-gruvbox-wallpaper/raw/master/png/gruvbox-light-rainbow.png";
          sha256 = "cfaf892e6b4093789cc36f29b0c026a181fdc10e9f224aa8fccf298c1d3a0357";
        };
        dontUnpack = true;
        installPhase = ''
          mkdir -p $out
          cp $src $out/wallpaper.png
        '';
      };
    in
    {
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

