{ pkgs, ... }:

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

  # Enables Nix flakes and nix-command support
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.systemPackages = [ pkgs.home-manager ];

  environment.variables = {
    FLAKE = "/Users/crackz/Public/Nix-config";
  };

  networking.hostName = "m1air";
  networking.localHostName = "m1air";

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts-emoji
    intel-one-mono
    (nerdfonts.override { fonts = [ "IntelOneMono" ]; })
  ];

  services.nix-daemon.enable = true;

  # NO TOUCHY
  system.stateVersion = 5;
}
