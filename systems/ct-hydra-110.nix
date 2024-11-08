{
  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000"; # Local testing URL
    notificationSender = "hydra@localhost"; # Basic email setting for notifications
    buildMachinesFiles = [ ]; # Avoids using a non-existent /etc/nix/machines file
    useSubstitutes = false; # No external substitutes to ensure full-source builds

    # Extra Hydra settings as a concatenated string
    extraConfig = ''
      logging.level = debug
      log_rotation = true
    '';
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    build-cores = 0; # Automatically uses all available cores
    eval-cache = true; # Enable local evaluation cache to speed up repeated evaluations
    substituters = ""; # Ensure no external substituters
    keep-outputs = true; # Avoids deleting outputs during builds, useful for debugging
    keep-derivations = true; # Keep derivations for more efficient garbage collection
  };

  nixpkgs.config.allowUnfree = true; # Enable unfree packages globally

  # Configure garbage collection to manage disk space in /nix/store
  nix.gc.automatic = true; # Enable automatic garbage collection
  nix.gc.dates = "weekly"; # Run garbage collection weekly
  nix.gc.options = "--delete-older-than 30d"; # Keep only the last 30 days of builds

  nix.buildMachines = [
    {
      hostName = "ct-hydra-110"; # Current container hostname
      system = "x86_64-linux"; # Target Linux only
      maxJobs = 12; # Match your CPU core count
      speedFactor = 1;
      supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
    }
  ];
}

