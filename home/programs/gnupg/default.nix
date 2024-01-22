{ config, lib, pkgs, ... }:
{
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.configHome}/gnupg";
  };
}

