{ config, lib, pkgs, ... }:
let
  cfg = config.hyprhome;
in
{
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.configHome}/gnupg";
  };

  services.gpg-agent = {
    enable = cfg.gui.enable;
    defaultCacheTtl = 4800;
    maxCacheTtl = 20000;
  };
}

