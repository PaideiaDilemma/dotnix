{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hyprhome;
  colors = config.colors;
in {
  options.hyprhome.syncthing = {
    enable = mkOption {
      default = true;
      description = "Whether to enable file sync.";
      type = types.bool;
    };
  };

  config = mkIf (cfg.syncthing.enable) {
    services.syncthing = {
      enable = true;
    };
  };
}
