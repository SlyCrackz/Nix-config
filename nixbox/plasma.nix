{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
  };

  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.libsForQt5; [
  kate
  elisa
  okular
  konsole
  oxygen
  ];
}