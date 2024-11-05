{
  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000"; # For testing locally within the container
    notificationSender = "hydra@localhost"; # Basic email setting for notifications
    buildMachinesFiles = []; # Avoids using a non-existent /etc/nix/machines file
    useSubstitutes = true; # Speeds up builds by using binary caches
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

