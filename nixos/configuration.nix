{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/boot.nix
    ./modules/network.nix
    ./modules/packages.nix
    ./modules/services.nix
    ./modules/plasma.nix
  ];

  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/persist/etc/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];
  # Unfree packages
  nixpkgs.config.allowUnfree = true;

  # Persist Certain stuff
  systemd.tmpfiles.rules = [
    "L /var/lib/tailscale - - - - /persist/var/lib/tailscale"
    "L /etc/secureboot - - - - /persist/etc/secureboot"
  ];

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
        extraGroups = [ "wheel" ];
        uid = 1000;
        shell = pkgs.zsh;
        home = "/home/crackz";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGOdrT0hVW1T5MksKlo6R3Ari7ZNO+LNsq6af5SLze8P crackz@m1air"
        ];
      };
    };
  };

  time.hardwareClockInLocalTime = true;
  # System state version
  system.stateVersion = "21.11";
}

