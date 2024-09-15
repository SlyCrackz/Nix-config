{ config, pkgs, lib, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    fastfetch
    lf
    pavucontrol
    btop
    pass
    gnupg
    mangohud
    inputs.unstablenixpkgs.legacyPackages.${pkgs.system}.neovim
    libnotify
    pulseaudio
    tree
  ];
 
  programs.dconf.enable = true;
  
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  programs.nix-ld.enable = true;
  #programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  #];
}
