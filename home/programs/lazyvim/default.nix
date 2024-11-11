{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hyprhome;
  lazyvimConfigSrc = pkgs.stdenv.mkDerivation {
    name = "lazyvim-config";
    src = pkgs.fetchFromGitHub {
      owner = "PaideiaDilemma";
      repo = "LazyVim";
      rev = "main";
      hash = "sha256-x+0cOWW1SE6sy3zpF5int+K3GQSaz7G0rQoc7Krm+E4=";
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
      source = "${lazyvimConfigSrc}/lazyvim/init.lua";
    };

    xdg.configFile."lazyvim/lua" = {
      source = "${lazyvimConfigSrc}/lazyvim/lua";
    };

    programs.neovim = {
      enable = true;
      vimAlias = true;
      vimdiffAlias = true;
      defaultEditor = true;
    };
  };
}
