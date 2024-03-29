{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hyprhome;
in {
  options.hyprhome.obs = {
    enable = mkOption {
      default = true;
      description = "Whether to enable obs";
      type = types.bool;
    };
  };

  config = mkIf (cfg.gui.enable && cfg.obs.enable) {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
      ];
    };
  };
}
