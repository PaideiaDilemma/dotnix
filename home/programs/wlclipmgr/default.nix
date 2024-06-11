{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.hyprhome;
in {
  options.hyprhome.wlclipmgr = {
    enable = mkOption {
      default = true;
      description = "Whether to enable wlclipmgr";
      type = types.bool;
    };
  };

  config = mkIf (cfg.gui.enable && cfg.wlclipmgr.enable) {
    home.packages = [
      inputs.wlclipmgr.packages.${pkgs.system}.wlclipmgr
    ];
  };
}
