{
  # Caddy service configuration
  services.caddy = {
  enable = true;
  virtualHosts."map.goldgrove.org".extraConfig = ''
    reverse_proxy http://10.0.1.107:8080
  '';

  virtualHosts."goldgrove.org".extraConfig = ''
    reverse_proxy http://10.0.1.107:8100
  '';
  };
}

