{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "IntoneMono Nerd Font:size=11";
        dpi-aware = "yes";
      };

      colors = {
        foreground = "ebdbb2"; # $text
        background = "282828"; # $base

        regular0 = "282828"; # $base
        regular1 = "fb4934"; # $red
        regular2 = "b8bb26"; # $green
        regular3 = "d79921"; # $yellow
        regular4 = "83a598"; # $blue
        regular5 = "d3869b"; # $mauve
        regular6 = "689d6a"; # $teal
        regular7 = "ebdbb2"; # $text

        bright0 = "928374"; # $overlay1
        bright1 = "fb4934"; # $red
        bright2 = "b8bb26"; # $green
        bright3 = "d79921"; # $yellow
        bright4 = "83a598"; # $blue
        bright5 = "d3869b"; # $mauve
        bright6 = "689d6a"; # $teal
        bright7 = "fbf1c7"; # $rosewater
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
  programs.kitty = {
    enable = true;
    font.name = "IntoneMono Nerd Font";
    settings = {
      extraConfig = ''
        font_size 11

        foreground #ebdbb2
        background #282828

        color0 #282828
        color1 #fb4934
        color2 #b8bb26
        color3 #d79921
        color4 #83a598
        color5 #d3869b
        color6 #689d6a
        color7 #ebdbb2

        color8 #928374
        color9 #fb4934
        color10 #b8bb26
        color11 #d79921
        color12 #83a598
        color13 #d3869b
        color14 #689d6a
        color15 #fbf1c7
      '';
    };
  };
}
