{ pkgs, config, ... }:

{
  # Unfree packages
  nixpkgs.config.allowUnfree = true;

  # make gui apps searchable by spotlight
  system.activationScripts.postUserActivation.text = ''
    rsyncArgs="--archive --checksum --chmod=-w --copy-unsafe-links --delete"
    apps_source="${config.system.build.applications}/Applications"
    moniker="Nix Trampolines"
    app_target_base="$HOME/Applications"
    app_target="$app_target_base/$moniker"
    mkdir -p "$app_target"
    ${pkgs.rsync}/bin/rsync $rsyncArgs "$apps_source/" "$app_target"
  '';

  environment.systemPackages = [ 
  pkgs.home-manager
  ];

  environment.variables = {
    FLAKE = "/Users/crackz/Public/Nix-config";
  };
  # Enable Homebrew in nix-darwin ---- STILL NEED TO INSTALL BREW MANUALLY/FIGURE OUT A FLAKE FOR IT
  homebrew = {
    enable = true;

    # Specify casks (GUI applications) to be installed by Homebrew
    casks = [ "logi-options-plus" ];
  };

  networking.hostName = "m1air";
  networking.localHostName = "m1air";

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts-emoji
    intel-one-mono
    (nerdfonts.override { fonts = [ "IntelOneMono" ]; })
  ];

  system.defaults = {
    dock.autohide = true;
    dock.persistent-apps = [
      "/Applications/Safari.app"
    ];
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.GuestEnabled = false;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.KeyRepeat = 2;
  };

  # Enable key remapping and define the Caps Lock <-> Escape swap
  system.keyboard.enableKeyMapping = true;
  system.keyboard.userKeyMapping = [
    # Map Caps Lock to Escape
    { HIDKeyboardModifierMappingSrc = 30064771129; HIDKeyboardModifierMappingDst = 30064771113; }

    # Map Escape to Caps Lock
    { HIDKeyboardModifierMappingSrc = 30064771113; HIDKeyboardModifierMappingDst = 30064771129; }
  ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  services.nix-daemon.enable = true;

  # NO TOUCHY
  system.stateVersion = 5;
}
