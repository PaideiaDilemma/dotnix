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
  options.dotnix.syncthing = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable file sync.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf (cfg.syncthing.enable) {
    services.syncthing = {
      enable = true;
    };
  };
}
