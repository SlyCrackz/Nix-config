{ pkgs, ... }:

let
  # Factorio headless server derivation
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
      mkdir -p $out/factorio
      tar -xJf $src -C $out/factorio
    '';
  };

  # Factorio Server Manager derivation
  factorioManager = pkgs.stdenv.mkDerivation rec {
    pname = "factorio-server-manager";
    version = "0.10.1";
    src = pkgs.fetchurl {
      url = "https://github.com/OpenFactorioServerManager/factorio-server-manager/releases/download/${version}/factorio-server-manager-linux-${version}.zip";
      sha256 = "c0777636aa521d71700bb8fd69a496b8f4964c0d495ba87c292f293f1003bde7";
    };
    buildInputs = [ pkgs.unzip ];
    installPhase = ''
      mkdir -p $out/factorio-server-manager
      unzip $src -d $out/factorio-server-manager
      chmod +x $out/factorio-server-manager/factorio-server-manager
    '';
  };
in
{
  # Define a post-activation script to copy the files to /root
  system.activationScripts.factorioFiles = {
    text = ''
      # Copy contents of Factorio headless server to /root/factorio without nesting
      mkdir -p /root/factorio
      cp -r ${factorioHeadless}/factorio/* /root/factorio/

      # Copy contents of Factorio Server Manager to /root/factorio-server-manager without nesting
      mkdir -p /root/factorio-server-manager
      cp -r ${factorioManager}/factorio-server-manager/* /root/factorio-server-manager/
    '';
  };

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

