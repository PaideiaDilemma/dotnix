{ config, lib, pkgs, ... }:
{
  programs.gpg = {
    enable = true;
    setting.use-agent = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };
}

