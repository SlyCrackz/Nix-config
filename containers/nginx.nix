{
  containers.service1 = {
    autoStart = true;
    config = { pkgs, ... }: {
      # No hardware-configuration.nix import here
      # Only services and packages needed for this container
      
      services.nginx.enable = true;  # Example: NGINX server for this container
      networking.firewall.allowedTCPPorts = [ 80 443 ]; # Only expose necessary ports
    };
  };
}

