{
  modulesPath,
  pkgs,
  lib,
  ...
}: let
  hostname = "ct-hydra-109";
  user = "crackz";

  timeZone = "America/New_York";
  defaultLocale = "en_US.UTF-8";
in {
  imports = [
    # Include the default LXC/LXD configuration.
    "${modulesPath}/virtualisation/lxc-container.nix"
  ];

  boot.isContainer = true;
  networking.hostName = hostname;
  networking.defaultGateway = "10.0.0.1";
  networking.interfaces.eth0 = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = "10.0.1.109"; # Replace with the desired static IP
        prefixLength = 8;      # Adjust prefix length if necessary
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
  ];

  services.openssh.enable = true;

  # Enable Hydra service
  services.hydra = {
    enable = true;
    hydraURL = "http://10.0.1.109:3000"; # Set to the container's static IP and desired port
    notificationSender = "hydra@slycrackz.xyz";
    useSubstitutes = true;
    buildMachinesFiles = [];
  };

  # Enable PostgreSQL for Hydra (default database for Hydra)
  services.postgresql.enable = true;
  services.postgresql.authentication = lib.mkForce [
    {
      type = "local";
      database = "all";
      user = "all";
      method = "trust";
    }
  ];

  time.timeZone = timeZone;

  i18n = {
    defaultLocale = defaultLocale;
    extraLocaleSettings = {
      LC_ADDRESS = defaultLocale;
      LC_IDENTIFICATION = defaultLocale;
      LC_MEASUREMENT = defaultLocale;
      LC_MONETARY = defaultLocale;
      LC_NAME = defaultLocale;
      LC_NUMERIC = defaultLocale;
      LC_PAPER = defaultLocale;
      LC_TELEPHONE = defaultLocale;
      LC_TIME = defaultLocale;
    };
  };

  users = {
    mutableUsers = false;
    users."${user}" = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFvMRI10U1QWJ2aULCUVV4Iv5I01LQ2sotzR87FuKlxH crackz@archbox"
      ];
    };
  };

  # Enable passwordless sudo.
  security.sudo.extraRules = [
    {
      users = [user];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  # Suppress systemd units that don't work in LXC.
  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "24.05";
}

