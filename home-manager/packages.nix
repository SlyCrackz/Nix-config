{ pkgs, unstablepkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs.gnupg
    pkgs.pass
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
    pkgs.obsidian
    pkgs.veracrypt
  ];
}
