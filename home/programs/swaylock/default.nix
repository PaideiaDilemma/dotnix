{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.swaylock = {
    enable = true;
    settings = {
      color = "#000000";
    };
  };
}
