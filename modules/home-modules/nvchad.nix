{ config, pkgs, nvchad4nix, nvchad-starter, unstablepkgs, ... }: {
  imports = [
    nvchad4nix.homeManagerModule
  ];

  programs.nvchad = {
    enable = true;
    neovim = unstablepkgs.neovim;
    extraPackages = with pkgs; [
      # Add any additional language servers or tools for NvChad
      pkgs.nodePackages.bash-language-server
      (pkgs.python3.withPackages(ps: with ps; [ ps.python-lsp-server ps.flake8 ]))
    ];
    hm-activation = true;
    backup = true;
  };
}
