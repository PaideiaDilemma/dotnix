{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hyprhome;
in {
  options.hyprhome.swaylock = {
  };

  config = mkIf (cfg.gui.enable && cfg.obs.enable) {
    programs.swaylock = {
      enable = true;
      settings = {
        color = "#000000";
      };
    };
  };
}
