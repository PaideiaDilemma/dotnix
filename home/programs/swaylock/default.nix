{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotnix;
  colors = config.colors;
in {
  programs.swaylock = {
    enable = true;
    settings = {
      color = "${colors.base.shade}";
    };
  };
}
