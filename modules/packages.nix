{ config, pkgs, lib, ... }:

{
  options = {
    nixPackages.enableCorePackages = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable core packages like fastfetch, wget, unzip, etc.";
    };

    nixPackages.enableDesktopPackages = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable desktop-specific packages like clipboard tools, multimedia support, and dconf.";
    };

    nixPackages.enableGamingPackages = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable gaming-related packages like Steam, Mangohud, and Gamemode.";
    };
  };

  config = let
    # Core Packages - available on all systems
    corePackages = lib.optionals config.nixPackages.enableCorePackages (with pkgs; [
      fastfetch
      btop
      nh
      file
      unzip
      unrar
      nix-output-monitor
      nvd
      wget
    ]);

    # Desktop Packages - specific to desktop and laptop setups
    desktopPackages = lib.optionals config.nixPackages.enableDesktopPackages (with pkgs; [
      wl-clipboard
      xdotool
      xorg.xprop
      xorg.xwininfo
      unixtools.xxd
      libimobiledevice  # iPhone mounting
      ifuse             # iPhone mounting
      icu
      sbctl             # lanzaboote
      home-manager
      pulseaudio
    ]);

    # Gaming Packages - only for gaming setups (e.g., desktop)
    gamingPackages = lib.optionals config.nixPackages.enableGamingPackages (with pkgs; [
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
    programs.steam.enable = config.nixPackages.enableGamingPackages;
    programs.steam.gamescopeSession.enable = config.nixPackages.enableGamingPackages;
    programs.gamemode.enable = config.nixPackages.enableGamingPackages;

    programs.zsh.enable = config.nixPackages.enableCorePackages;

    # Enable dconf only if desktop packages are enabled
    programs.dconf.enable = config.nixPackages.enableDesktopPackages;
  };
}
