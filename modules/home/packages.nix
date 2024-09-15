{ config, pkgs, lib, ... }:

{
  home-manager.users.crackz = {
    home.packages = [
      pkgs.firefox
      pkgs.autotiling-rs
      pkgs.wmenu
      pkgs.mako
      pkgs.grim
      pkgs.slurp
      pkgs.wl-clipboard
      pkgs.rustup
      pkgs.clang
      pkgs.kanshi
      pkgs.waybar
      pkgs.cava
      pkgs.jq
      pkgs.vesktop
      pkgs.pavucontrol
      pkgs.zellij
      pkgs.nodejs
      pkgs.lazydocker
      pkgs.lazygit
      pkgs.protonup-qt
      pkgs.fzf
      pkgs.ripgrep
      pkgs.cmatrix
      pkgs.appimage-run
      pkgs.unzip
      pkgs.obs-studio
    ];
    programs.bash.enable = true;
  };
}
