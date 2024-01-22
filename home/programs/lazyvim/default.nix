{ config, lib, pkgs, ... }:

let
  lazyvimConfigSrc = pkgs.stdenv.mkDerivation {
    name = "lazyvim-config";
    src = pkgs.fetchFromGitHub {
      owner = "PaideiaDilemma";
      repo = "LazyVim";
      rev = "main";
      hash = "sha256-HK2LvloYstXiMUMh2oEKIV9O3pQDjHH2jDyl0isnm9U=";
    };
    installPhase = ''
      mkdir -p $out/lazyvim
      cp -r $src/* $out/lazyvim
      # Needs to be writeable
      rm $out/lazyvim/lazy-lock.json
    '';
  };

in
{
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
}
