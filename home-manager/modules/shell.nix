{ config, pkgs, lib, ... }:

{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        nix = "nom";
        ff = "fastfetch";
        t = "txr";
        lzg = "lazygit";
        lzd = "lazydocker";
        v = "nvim";
        lf = "yazi";
        y = "yazi";
      };
      initExtra = ''
        precmd() { print -Pn "\e]0;%~\a" }
        preexec() { print -Pn "\e]0;$1\a" }
      '';
    };
    starship = {
      enable = true;
      settings = {
        username = {
          style_user = "blue bold";
          style_root = "red bold";
          format = "[$user]($style)";
          disabled = false;
          show_always = true;
        };
        hostname = {
          ssh_only = false;
          ssh_symbol = "🌐";
          format = "[@](bold red)[$hostname ](bold yellow)";
          trim_at = ".local";
          disabled = false;
        };
        add_newline = false;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };
  };
}

