{ pkgs, ... }:

let
  # Define the Factorio headless server as a derivation fetched from the website
  factorioHeadless = pkgs.stdenv.mkDerivation rec {
    pname = "factorio-headless";
    version = "2.0.14";
    src = pkgs.fetchurl {
      url = "https://www.factorio.com/get-download/${version}/headless/linux64";
      sha256 = "5a4bc4c3b2a97ed1fc58eb796321e848dcc64435bd91013dd9c78a14a8ce8815";
      name = "factorio-headless-${version}.tar.xz";
    };
    buildInputs = [ pkgs.xz ];
    installPhase = ''
      # Extract entire Factorio folder structure into /root/factorio
      mkdir -p /root
      tar -xJf $src -C /root
    '';
  };

  # Define the Factorio Server Manager binary as a derivation
  factorioManager = pkgs.stdenv.mkDerivation rec {
    pname = "factorio-server-manager";
    version = "0.10.1";
    src = pkgs.fetchurl {
      url = "https://github.com/OpenFactorioServerManager/factorio-server-manager/releases/download/${version}/factorio-server-manager-linux-${version}.zip";
      sha256 = "c0777636aa521d71700bb8fd69a496b8f4964c0d495ba87c292f293f1003bde7";
    };
    buildInputs = [ pkgs.unzip ];
    installPhase = ''
      # Extract entire Factorio Server Manager folder structure into /root/factorio-server-manager
      mkdir -p /root/factorio-server-manager
      unzip $src -d /root/factorio-server-manager
      chmod +x /root/factorio-server-manager/factorio-server-manager
    '';
  };
in
{
  # No need to add either to systemPackages, as we’re installing to /root directly

  # Define and enable the Factorio Server Manager as a systemd service
  systemd.services.factorio-manager = {
    description = "Open Factorio Server Manager";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "/root/factorio-server-manager/factorio-server-manager";
      Restart = "on-failure";
    };
  };
}

