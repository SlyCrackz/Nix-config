{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kdePackages.kdenlive
    vlc
  ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };
}
