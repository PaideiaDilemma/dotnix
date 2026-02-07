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
  options.dotnix.mako = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable mako notifications.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf (cfg.gui.enable && cfg.mako.enable) {
    services.mako = {
      enable = true;
      settings = {
        font = "Noto Sans 10";
        anchor = "bottom-center";
        background-color = "${colors.base.sky_}";
        text-color = "${colors.base.sun}";
        margin = "2";
        #outerMargin = 5;
        border-color = "${colors.base.sun}";
        border-size = 1;
        border-radius = 6;
        progress-color = "over ${colors.accent.red}CC";
        icons = true;
      };
    };
  };
}
