{pkgs, ...}:

{
  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs.jetbrains.idea-community-bin
    pkgs.zulu
  ];
}
