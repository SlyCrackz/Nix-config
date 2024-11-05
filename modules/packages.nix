{ config, pkgs, lib, ... }:

{
  options = {
    nixboxPackages.enableCorePackages = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable core packages like fastfetch, wget, unzip, etc.";
    };

    nixboxPackages.enableDesktopPackages = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable desktop-specific packages like clipboard tools, multimedia support, and dconf.";
    };

    nixboxPackages.enableGamingPackages = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable gaming-related packages like Steam, Mangohud, and Gamemode.";
    };
  };

  config = let
    # Core Packages - available on all systems
    corePackages = lib.optionals config.nixboxPackages.enableCorePackages (with pkgs; [
      fastfetch
      btop
      nh
      file
      unzip
      unrar
      nix-output-monitor
      nvd
      wget
      gcc
      glibc
      home-manager
      pulseaudio
    ]);

    # Desktop Packages - specific to desktop and laptop setups
    desktopPackages = lib.optionals config.nixboxPackages.enableDesktopPackages (with pkgs; [
      wl-clipboard
      xdotool
      xorg.xprop
      xorg.xwininfo
      unixtools.xxd
      libimobiledevice  # iPhone mounting
      ifuse             # iPhone mounting
      icu
      sbctl             # lanzaboote
      nix-ld
    ]);

    # Gaming Packages - only for gaming setups (e.g., desktop)
    gamingPackages = lib.optionals config.nixboxPackages.enableGamingPackages (with pkgs; [
      mangohud
      protontricks
      protonup-qt
      appimage-run
      yad
    ]);
  in
  {
    # Combine selected packages based on the enabled groups
    environment.systemPackages = corePackages ++ desktopPackages ++ gamingPackages;

    # Enable Steam and related gaming settings only if gaming packages are enabled
    programs.steam.enable = config.nixboxPackages.enableGamingPackages;
    programs.steam.gamescopeSession.enable = config.nixboxPackages.enableGamingPackages;
    programs.gamemode.enable = config.nixboxPackages.enableGamingPackages;

    programs.zsh.enable = config.nixboxPackages.enableCorePackages;

    # Enable dconf only if desktop packages are enabled
    programs.dconf.enable = config.nixboxPackages.enableDesktopPackages;
  };
}
