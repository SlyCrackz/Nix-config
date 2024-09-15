{ config, pkgs, lib, ... }:

{
    programs.foot = {
      enable = true;
      settings = {
        main = {
          #term = "xterm-256color";
          font = "IntoneMono Nerd Font:size=11";
          dpi-aware = "yes";
        };

        colors = {
        foreground = "ebdbb2";  # $text
        background = "282828";  # $base

        regular0 = "282828";  # $base
        regular1 = "fb4934";  # $red
        regular2 = "b8bb26";  # $green
        regular3 = "d79921";  # $yellow
        regular4 = "83a598";  # $blue
        regular5 = "d3869b";  # $mauve
        regular6 = "689d6a";  # $teal
        regular7 = "ebdbb2";  # $text

        bright0 = "928374";  # $overlay1
        bright1 = "fb4934";  # $red
        bright2 = "b8bb26";  # $green
        bright3 = "d79921";  # $yellow
        bright4 = "83a598";  # $blue
        bright5 = "d3869b";  # $mauve
        bright6 = "689d6a";  # $teal
        bright7 = "fbf1c7";  # $rosewater
        };

        mouse = {
          hide-when-typing = "yes";
        };
      };
    };
}
