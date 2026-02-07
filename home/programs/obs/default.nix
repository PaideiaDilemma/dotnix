{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotnix;
in {
  options.dotnix.obs = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable obs";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf (cfg.gui.enable && cfg.obs.enable) {
    programs.obs-studio = {
      enable = true;
    };
  };
}
