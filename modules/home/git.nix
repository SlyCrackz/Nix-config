{ config, pkgs, lib, ... }:

{
  home-manager.users.crackz = {
    programs.git = {
      enable = true;
      userName  = "slycrackz";
      userEmail = "slycrackz@slycrackz.xyz";
    };
  };
}
