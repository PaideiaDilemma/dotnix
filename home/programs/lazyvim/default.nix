{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.hyprhome;
  lazyvimConfigSrc = pkgs.stdenv.mkDerivation {
    name = "lazyvim-config";
    src = pkgs.fetchFromGitHub {
      owner = "PaideiaDilemma";
      repo = "LazyVim";
      rev = "60d3868b95c6830d7670d5d05bc619ec5486fadb";
      hash = "sha256-3c3KqjzH6EhdCDTEgS9LRLcR27+G0QqfSuTqTSjDrsY=";
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

    xdg.configFile."lazyvim" = {
      source = "${lazyvimConfigSrc}/lazyvim";
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
