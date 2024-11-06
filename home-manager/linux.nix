{ pkgs, ... }:

{
  home.homeDirectory = "/home/crackz";
  home.sessionPath = [
    "/home/crackz/.local/bin/"
  ];
  home.packages = [
    pkgs.firefox
    pkgs.cava
  ];
}
