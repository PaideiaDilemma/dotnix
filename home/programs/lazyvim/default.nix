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
  options.hyprhome.lazyvim = {
    enable = mkOption {
      default = true;
      description = "Whether to enable my lazyvim configuration.";
      type = types.bool;
    };
  };

  config = mkIf (cfg.lazyvim.enable) {
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
    ];

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
