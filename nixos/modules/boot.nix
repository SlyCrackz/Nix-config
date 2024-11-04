{ lib, ... }:

{
  # System bootloader and kernel parameters
  boot.supportedFilesystems = [ "zfs" ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "elevator=none" ];
  boot.kernelModules = [ "zram" "kvm-intel" ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  # Lanzaboote
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  # ZFS configuration
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zpool import rpool
    zfs rollback -r rpool/encrypted/local/root@blank
  '';
}
