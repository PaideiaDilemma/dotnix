{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    zsh-fzf-tab
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;

    #enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    dotDir = ".config/zsh";
    history = {
      size = 100000;
      ignoreAllDups = true;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initExtra = ''
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    '';

    oh-my-zsh = {
      enable = true;
      theme = "eastwood";
      plugins = [
        "git"
        "z"
        "vi-mode"
        "systemd"
      ];
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };
}
