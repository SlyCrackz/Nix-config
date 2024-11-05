{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    fastfetch
    btop
    mangohud
    pulseaudio
    home-manager
    nh
    file
    protonup-qt
    appimage-run
    unzip
    unrar
    nix-output-monitor
    nvd
    protontricks
    wl-clipboard
    wget
    gcc
    glibc
    xdotool
    xorg.xprop
    xorg.xwininfo
    unixtools.xxd
    yad #for steamtinkerlaunch
    icu
    sbctl #lanzaboote
    libimobiledevice #iphone mounting
    ifuse #iphone mounting
  ];

  programs.dconf.enable = true;

  programs.zsh.enable = true;

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  programs.nix-ld = {
    enable = true;
  };
}
