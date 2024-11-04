
{
  # Enable Nginx
  services.nginx = {
    enable = true;
    virtualHosts = {
      "localhost" = {
        root = "/var/www";
        listen = [ { addr = "0.0.0.0"; port = 80; } ];
        extraConfig = ''
          index index.html;
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];
  networking.hostName = "nginx-container";

  # Optional: Create a basic HTML page
  systemd.services.nginx-setup = {
    description = "Set up a simple webpage for Nginx";
    wantedBy = [ "multi-user.target" ];
    script = ''
      mkdir -p /var/www
      echo "<h1>Welcome to the Nginx Container</h1>" > /var/www/index.html
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}

