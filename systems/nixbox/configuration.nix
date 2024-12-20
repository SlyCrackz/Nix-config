{ pkgs, ... }:

{
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/persist/etc/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];
  # Unfree packages
  nixpkgs.config.allowUnfree = true;


  environment.systemPackages = [
    pkgs.home-manager
  ];

  # Persist Certain stuff
  systemd.tmpfiles.rules = [
    "L /var/lib/tailscale - - - - /persist/var/lib/tailscale"
    "L /etc/secureboot - - - - /persist/etc/secureboot"
  ];

  # Needed for nfs
  services.rpcbind.enable = true;

  # Mount the NFS share
  fileSystems."/mnt/nfs/Proxmox" = {
    device = "172.16.10.5:/export/Proxmox";
    fsType = "nfs";
    options = [ "nfsvers=3" "rw" "noauto" "x-systemd.automount" "x-systemd.idle-timeout=600" ];
  };

  fileSystems."/var/lib/bluetooth" = {
    device = "/persist/var/lib/bluetooth";
    options = [ "bind" "noauto" "x-systemd.automount" ];
    noCheck = true;
  };

  nix.settings.extra-experimental-features = [ "nix-command" "flakes" ];

  # Other system services
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.sudo.wheelNeedsPassword = false;

  sound.mediaKeys.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts-emoji
    intel-one-mono
    (nerdfonts.override { fonts = [ "IntelOneMono" ]; })
  ];

  # Allow realtime processing for people in Users Group
  security.pam.loginLimits = [
    { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
  ];

  environment.sessionVariables = {
    FLAKE = "/home/crackz/repos/Nix-config";
  };

  environment.variables.EDITOR = "nvim";

  # iPhone mounting
  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };

  services.thermald.enable = true;
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

  # User configuration
  users = {
    mutableUsers = false;
    users = {
      root = {
        initialHashedPassword = "\$6\$yh/7lJ6rg6ygLNlu\$Q.eBnkgO/.q1KxdGDtHhMxN8eJP0xSc7B9wjj91.MWU7xSs8O1u5KM4SnMoDLfnYZd0OxrRVcomcJIh.6FjTW0";
      };

      crackz = {
        isNormalUser = true;
        createHome = true;
        initialHashedPassword = "\$6\$ZrQwhxOYvxQY8juy\$Agwgx/D2qvJdAKrdR9KgA/eVDyEO6mk5IZgDA220iCOmeoseDGhpchIKaZT1ZZRYHIMgOSdWaL4O2uV1napki0";
        extraGroups = [ "wheel" "networkmanager" "plugdev" ];
        uid = 1000;
        shell = pkgs.zsh;
        home = "/home/crackz";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICdcEigBJBlmbmhupd9x35uzDIN+3INROp6QR8hpxjX6 crackz@m1air"
        ];
      };
    };
  };

  # autologin
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "crackz";

  networking.networkmanager.enable = true;

  time.hardwareClockInLocalTime = true;
  # System state version (DONT CHANGE!!!)
  system.stateVersion = "21.11";
}

