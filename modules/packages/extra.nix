{ pkgs, ... }:

{
  # Define system-wide packages here
  environment.systemPackages = with pkgs; [
  # Desktop utilities
    unixtools.xxd
    libimobiledevice
    ifuse
    icu
    sbctl
    wl-clipboard

    # Gaming-related tools (these will be included on systems where applicable)
    mangohud
    protontricks
    protonup-qt
    appimage-run
    yad
    nix-output-monitor
    nvd
    nh
  ];

    # Enable Steam and related gaming settings only if gaming packages are enabled
    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;
    programs.gamemode.enable = true;

    programs.zsh.enable = true;
}

