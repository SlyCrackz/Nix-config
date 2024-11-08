{
  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000"; # For testing locally within the container
    notificationSender = "hydra@localhost"; # Basic email setting for notifications
    buildMachinesFiles = [ ]; # Avoids using a non-existent /etc/nix/machines file
    useSubstitutes = false; # Speeds up builds by using binary caches
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    build-cores = 0; # Automatically uses all available cores
  };

  nix.config.allowUnfree = true;

  nix.buildMachines = [
    {
      hostName = "ct-hydra-110"; # Keep the current container hostname
      system = "x86_64-linux"; # Target Linux only
      maxJobs = 12; # Adjust to match your CPU core count
      speedFactor = 1;
      supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
    }
  ];
}

