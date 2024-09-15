{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./home.nix
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
  ];

  services.tailscale.useRoutingFeatures = "client";

  # Allow flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Video drivers for Xorg and Wayland
  services.xserver.videoDrivers = [ "intel" "nvidia" ];

  # System bootloader and kernel parameters
  boot.supportedFilesystems = [ "zfs" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "elevator=none" ];

  # ZFS configuration
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zpool import rpool
    zfs rollback -r rpool/encrypted/local/root@blank
  '';

  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot.enable = true;
  };

  programs.dconf.enable = true;

  # Networking
  networking.hostId = "69413b8c";
  networking.hostName = "nixbox";

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

  # Other system services
  services.tailscale.enable = true;
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.sudo.wheelNeedsPassword = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  sound.mediaKeys.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts-emoji
    intel-one-mono
    (nerdfonts.override { fonts = [ "IntelOneMono" ]; })
  ];
  
  #fonts.aliases = {
  #emoji = [ "Noto Color Emoji" ];
  #};

  environment.systemPackages = with pkgs; [
    fastfetch
    lf
    pavucontrol
    btop
    pass
    gnupg
    mangohud
    neovim
    libnotify
    pulseaudio
  ];

  # GnuPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.pcscd.enable = true;

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  environment.variables.EDITOR = "nvim";  
  # Neovim settings
#  programs.neovim = {
#    enable = true;
#    defaultEditor = true;
#  };

  programs.nix-ld.enable = true;
  #programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  #];

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
        home = "/home/crackz";
        shell = "${pkgs.nushell}/bin/nu";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGOdrT0hVW1T5MksKlo6R3Ari7ZNO+LNsq6af5SLze8P crackz@m1air"
        ];
      };
    };
  };

  # System state version
  system.stateVersion = "21.11";
}

