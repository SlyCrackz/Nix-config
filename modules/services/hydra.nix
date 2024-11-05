{
  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000"; # For testing locally within the container
    buildMachinesFiles = []; # Avoids using a non-existent /etc/nix/machines file
    useSubstitutes = true; # Speeds up builds by using binary caches
  };
}

