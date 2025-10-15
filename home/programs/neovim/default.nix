{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hyprhome;
in {
  options.hyprhome = {
  };

  config = {
    home.packages = with pkgs; [
      clang-tools
      fd
      gcc
      git
      go
      lazygit
      nodejs
      ripgrep
      unzip
      jdk17
      tree-sitter
      bat
    ];

    xdg.configFile."nvim-minimax/" = {
      source = "${inputs.minimax}";
    };

    xdg.configFile."lazyvim/init.lua" = {
      source = "${inputs.lazyvim}/init.lua";
    };

    xdg.configFile."lazyvim/lua" = {
      source = "${inputs.lazyvim}/lua";
    };

    programs.neovim = {
      enable = true;
      vimAlias = true;
      vimdiffAlias = true;
      defaultEditor = true;
    };
  };
}
