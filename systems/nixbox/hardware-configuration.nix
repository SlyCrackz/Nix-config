{ config, lib, modulesPath, pkgs, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];



  fileSystems."/" =
    {
      device = "rpool/encrypted/local/root";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/1FBC-972C";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/nix" =
    {
      device = "rpool/encrypted/local/nix";
      fsType = "zfs";
    };

  fileSystems."/home" =
    {
      device = "rpool/encrypted/safe/home";
      fsType = "zfs";
    };

  fileSystems."/persist" =
    {
      device = "rpool/encrypted/safe/persist";
      fsType = "zfs";
    };

  swapDevices = [ ];

  # ZFS and Snapshots
  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot = {
      enable = true;
      frequent = 4;   # Keep the last 4 frequent snapshots
      hourly = 12;    # Keep the last 12 hourly snapshots
      daily = 7;      # Keep the last 7 daily snapshots
      weekly = 4;     # Keep the last 4 weekly snapshots
      monthly = 2;    # Keep the last 2 monthly snapshots
    };
  };

  # udev
  services.udev = {
    enable = true;
    extraRules = ''
      ACTION=="add|bind", SUBSYSTEM=="pci", DRIVERS=="nvidia", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", TEST=="power/control", ATTR{power/control}="auto"

      ACTION=="remove|unbind", SUBSYSTEM=="pci", DRIVERS=="nvidia", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", TEST=="power/control", ATTR{power/control}="on"

      DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"

      ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"

      ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"

      ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"

      ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}=="*", ATTR{link_power_management_policy}="max_performance"

      KERNEL=="ntsync", MODE="0644"
    '';
  };

  # Create a systemd service to configure ZRAM
  systemd.services.zram = {
    description = "ZRAM Swap Setup";
    wantedBy = [ "multi-user.target" ];
    after = [ "sysinit.target" ]; # Ensure this runs after basic system initialization

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/sh -c 'echo lz4 > /sys/block/zram0/comp_algorithm && echo 16G > /sys/block/zram0/disksize && /run/current-system/sw/bin/mkswap /dev/zram0 && /run/current-system/sw/bin/swapon /dev/zram0'";
      RemainAfterExit = true;
    };
  };

  # Optionally configure system-wide swap settings (vm.swappiness)
  systemd.tmpfiles.rules = [
    "w /proc/sys/vm/swappiness - - - - 150" # Increase swappiness to prefer ZRAM over disk
  ];

  # Networking
  networking.hostId = "69413b8c";
  networking.hostName = "nixbox";
  networking.useDHCP = lib.mkDefault true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  time.timeZone = lib.mkDefault "America/New_York";
  # Video drivers 
  services.xserver.videoDrivers = [ "intel" "nvidia" ];
  
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.opengl.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

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
    zfs rollback -r rpool/encrypted/local/root@blank
  '';

}
