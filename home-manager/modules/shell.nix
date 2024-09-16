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
      };
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

