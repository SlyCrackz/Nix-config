{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    fastfetch
    pavucontrol
    btop
    mangohud
    pulseaudio
    home-manager
    nh
    xfce.thunar
    pavucontrol
    protonup-qt
    appimage-run
    unzip
    unrar
    nix-output-monitor
    nvd
    protontricks
    icu
  ];

  programs.dconf.enable = true;

  programs.zsh.enable = true;

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  programs.nix-ld.enable = true;
  #programs.nix-ld.libraries = with pkgs; [
  # Add any missing dynamic libraries for unpackaged programs
  # here, NOT in environment.systemPackages
  #];
}
