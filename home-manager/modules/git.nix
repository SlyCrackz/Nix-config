{ config, pkgs, lib, ... }:

{
    programs.git = {
      enable = true;
      userName  = "slycrackz";
      userEmail = "slycrackz@slycrackz.xyz";
    };
}
