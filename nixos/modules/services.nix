{ pkgs, ... }:

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
    autoSnapshot = {
      enable = true;
      frequent = 4;   # Keep the last 4 frequent snapshots
      hourly = 12;    # Keep the last 12 hourly snapshots
      daily = 7;      # Keep the last 7 daily snapshots
      weekly = 4;     # Keep the last 4 weekly snapshots
      monthly = 2;    # Keep the last 2 monthly snapshots
    };
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
