{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ff = "fastfetch";
        t = "zxr";
        lzg = "lazygit";
        lzd = "lazydocker";
        v = "nvim";
        lf = "yazi";
        y = "yazi";
        z = "zellij";
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
        directory = {
          format = "[$path ](bold blue)[$read_only](bold red)";
          truncation_length = 5;
          home_symbol = "🏠";
          truncation_symbol = "/";
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

