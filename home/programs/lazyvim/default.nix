{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.hyprhome;
  lazyvimConfigSrc = pkgs.stdenv.mkDerivation {
    name = "lazyvim-config";
    src = pkgs.fetchFromGitHub {
      owner = "PaideiaDilemma";
      repo = "LazyVim";
      rev = "5749e22d3ef061f15bcbd18fcde28b873be19da5";
      hash = "sha256-K29GLb8WDuhSK8fSJTYZpXKCuqrSGFx1IGaH/0EWESk=";
    };
    installPhase = ''
      mkdir -p $out/lazyvim
      cp -r $src/* $out/lazyvim
      # I have the lazy lockfile in the data directory.
      # I would like to write this into a user-writable file initially,
      # but I don't know how to do that yet.
      rm $out/lazyvim/lazy-lock.json
    '';
  };

in
{
  options.hyprhome.lazyvim = {
    enable = mkOption {
      default = true;
      description = "Whether to enable my lazyvim configuration.";
      type = types.bool;
    };
  };

  config = mkIf (cfg.gui.enable && cfg.lazyvim.enable) {
    home.packages = with pkgs; [
      nodejs
      unzip
      lazygit
      git
      gcc
      ripgrep
      fd
    ];

    xdg.configFile."lazyvim/init.lua" = {
      source = "${lazyvimConfigSrc}/lazyvim/init.lua";
    };

    xdg.configFile."lazyvim/lua" = {
      source = "${lazyvimConfigSrc}/lazyvim/lua";
    };

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      defaultEditor = true;
    };
  };
}
