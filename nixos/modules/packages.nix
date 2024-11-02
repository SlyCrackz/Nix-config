{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    fastfetch
    btop
    mangohud
    pulseaudio
    home-manager
    nh
    protonup-qt
    appimage-run
    unzip
    unrar
    nix-output-monitor
    nvd
    protontricks
    wget
    xdotool
    xorg.xprop
    xorg.xwininfo
    unixtools.xxd
    yad #for steamtinkerlaunch
    icu
  ];

  programs.dconf.enable = true;

  programs.zsh.enable = true;

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  programs.nix-ld.enable = true;
}
