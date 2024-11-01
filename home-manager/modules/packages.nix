{ pkgs, unstablepkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs.google-chrome
    pkgs.firefox
    pkgs.gnupg
    pkgs.pass
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
    pkgs.obsidian
    unstablepkgs.neovim
    pkgs.zulu
  ];
}
