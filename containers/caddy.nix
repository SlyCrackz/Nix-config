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

  # Caddy service configuration
  services.caddy = {
    enable = true;
    package = pkgs.caddy;
    config = ''
      byteshift.cc {
        reverse_proxy 10.0.1.106:80
      }

      mc.byteshift.cc {
        reverse_proxy 10.0.1.108:8080
      }

      goldgrove.org {
        reverse_proxy 10.0.1.107:8100
      }

      map.goldgrove.org {
        reverse_proxy 10.0.1.107:8080
      }
    '';
  };
}

