{ config, pkgs, ... }:

{
  programs.zsh = {
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    dotDir = ".config/zsh";
    enable = true;
    history = {
      size = 100000;
      ignoreAllDups = true;
      path = "${config.xdg.dataHome}/zsh/history";
    };

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
}
