{ pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];

  environment.systemPackages = [
    pkgs.vim
    pkgs.git
    pkgs.rsync
  ];

  # Enable SSH for remote access
  services.openssh.enable = true;

  # we use opnsense
  networking.firewall.enable = false;

  system.stateVersion = "24.05";
}
