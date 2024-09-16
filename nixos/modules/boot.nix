{ config, pkgs, lib, ... }:

{
  # System bootloader and kernel parameters
  boot.supportedFilesystems = [ "zfs" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "elevator=none" ];
  boot.kernelModules = [ "zram" ];
  # ZFS configuration
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zpool import rpool
    zfs rollback -r rpool/encrypted/local/root@blank
  '';
}
