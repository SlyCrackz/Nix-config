{
  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000"; # For testing locally within the container
    notificationSender = "hydra@localhost"; # Basic email setting for notifications
    buildMachinesFiles = []; # Avoids using a non-existent /etc/nix/machines file
    useSubstitutes = true; # Speeds up builds by using binary caches
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.buildMachines = [
    {
      # Keep the current container hostname
      system = "x86_64-linux"; # Target Linux only
      maxJobs = 8; # Adjust this to match your CPU core count
      speedFactor = 1.0;
      supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
    }
  ];

  # Increase parallelism for each individual build
  nix.settings.build-cores = 0; # Automatically uses all available cores
}
