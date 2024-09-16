{ config, pkgs, lib, ... }:

{
# Tailscale
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  # Audio (pipewire)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };

  # Video drivers 
  services.xserver.videoDrivers = [ "intel" "nvidia" ];

  # ZFS
  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot.enable = true;
  };

  # Terminal Lock
  services.pcscd.enable = true;

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

  # SSH configuration
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
    hostKeys = [
      { path = "/persist/etc/ssh/ssh_host_ed25519_key"; type = "ed25519"; }
      { path = "/persist/etc/ssh/ssh_host_rsa_key"; type = "rsa"; bits = 4096; }
    ];
  };
  
}
