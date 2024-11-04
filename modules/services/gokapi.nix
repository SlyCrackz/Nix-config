
{ pkgs, ... }:

let
  gokapiPackage = pkgs.stdenv.mkDerivation rec {
    pname = "gokapi";
    version = "v1.9.2";
    src = pkgs.fetchurl {
      url = "https://github.com/Forceu/Gokapi/releases/download/${version}/gokapi-linux_amd64";
      sha256 = "bc79d7548ba6d1230e0038898210941c05ce87ea7b1704b812daefa6278175a2";
    };
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cp ${src} $out/bin/gokapi
      chmod +x $out/bin/gokapi
    '';
  };
in
{
  # Create the gokapi user
  users.groups.gokapi = {};
  users.users.gokapi = {
    isSystemUser = true;
    home = "/var/lib/gokapi";
    description = "Gokapi Service User";
    group = "gokapi";
  };

  # Enable Gokapi as a systemd service
  systemd.services.gokapi = {
    description = "Gokapi Service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${gokapiPackage}/bin/gokapi";
      Restart = "on-failure";
      User = "gokapi";
      Environment = [
        "GOKAPI_PORT=53842"
        "TZ=America/New_York"
      ];
    };
  };
}
