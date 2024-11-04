
{ pkgs, ... }:

let
  gokapiPackage = pkgs.stdenv.mkDerivation rec {
    pname = "gokapi";
    version = "v1.9.2";
    src = pkgs.fetchurl {
      url = "https://github.com/Forceu/Gokapi/releases/download/${version}/gokapi-linux_amd64.zip";
      sha256 = "bc79d7548ba6d1230e0038898210941c05ce87ea7b1704b812daefa6278175a2"; # Update with the actual checksum
    };
    nativeBuildInputs = [ pkgs.unzip ];
    phases = [ "unpackPhase" "installPhase" ];
    unpackPhase = ''
      unzip ${src}
    '';
    installPhase = ''
      mkdir -p $out/bin
      mv gokapi-linux_amd64 $out/bin/gokapi
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
}
