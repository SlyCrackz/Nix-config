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
      pkgs.obs-studio
      pkgs.jetbrains.idea-community-bin
    ];
    
    programs.bash.enable = true;
}
