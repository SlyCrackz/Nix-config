{ pkgs, ... }:

{
    home.packages = [
      pkgs.kdePackages.kdenlive  # Enable Kdenlive by adding it to the home packages
    ];

      programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      ];
    };
}
