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
      mkdir -p $out
      tar -xJf $src --strip-components=1 -C $out
    '';
  };

  # Define the prebuilt Factorio Server Manager binary
  factorioManager = pkgs.stdenv.mkDerivation rec {
    pname = "factorio-server-manager";
    version = "0.10.1";
    src = pkgs.fetchurl {
      url = "https://github.com/OpenFactorioServerManager/factorio-server-manager/releases/download/${version}/factorio-server-manager-linux-${version}.zip";
      sha256 = "c0777636aa521d71700bb8fd69a496b8f4964c0d495ba87c292f293f1003bde7";
    };
    buildInputs = [ pkgs.unzip ];
    installPhase = ''
      mkdir -p $out/bin
      unzip $src -d $out/bin
      chmod +x $out/bin/factorio-server-manager
    '';
  };
in
{
  # System-wide packages, using the custom Factorio headless derivation
  environment.systemPackages = [
    factorioHeadless
  ];

  # Symlink Factorio binaries to /root for easier access
  environment.etc."factorio" = {
    source = "${factorioHeadless}/bin";  # Symlink the headless server
  };
  environment.etc."factorio-manager" = {
    source = "${factorioManager}/bin/factorio-server-manager";  # Symlink the server manager
  };

  # Define and enable the Factorio Server Manager as a systemd service
  systemd.services.factorio-manager = {
    description = "Open Factorio Server Manager";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${factorioManager}/bin/factorio-server-manager";
      Restart = "on-failure";
    };
  };
}

