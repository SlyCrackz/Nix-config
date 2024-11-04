{ pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];

  environment.systemPackages = [
    pkgs.vim
    pkgs.git
    pkgs.caddy
  ];

  
  # Enable SSH for remote access
  services.openssh.enable = true;

  # we use opnsense
  networking.firewall.enable = false;

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

  system.stateVersion = "24.05";
}

