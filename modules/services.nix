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
