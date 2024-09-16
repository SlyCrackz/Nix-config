{ config, pkgs, lib, ... }:

{
    home.packages = [
      pkgs.firefox
      pkgs.gnupg
      pkgs.pass
      pkgs.rustup
      pkgs.clang
      pkgs.cava
      pkgs.jq
      pkgs.vesktop
      pkgs.zellij
      pkgs.nodejs
      pkgs.lazydocker
      pkgs.lazygit
      pkgs.fzf
      pkgs.tree
      pkgs.ripgrep
      pkgs.cmatrix
      pkgs.jetbrains.idea-community-bin
      pkgs.kdePackages.kdenlive
    ];
    
    programs.bash.enable = true;

    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      ];
    };
}
