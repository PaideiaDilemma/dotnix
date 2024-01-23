{ config, lib, pkgs, ... }:

let
  lazyvimConfigSrc = pkgs.stdenv.mkDerivation {
    name = "lazyvim-config";
    src = pkgs.fetchFromGitHub {
      owner = "PaideiaDilemma";
      repo = "LazyVim";
      rev = "295823f758ad06ce044fc1413cbff2928fa25b69";
      hash = "sha256-ZW8W+nOvu5bHsP91AzhGoYhrJmGq9VSy3xsGrrlCcNc=";
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
