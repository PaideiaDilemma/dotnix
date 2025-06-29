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
  options.hyprhome.mako = {
    enable = mkOption {
      default = true;
      description = "Whether to enable mako notifications.";
      type = types.bool;
    };
  };

  config = mkIf (cfg.gui.enable && cfg.mako.enable) {
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
        progress-color = "over ${colors.six.red}CC";
        icons = true;
      };
    };
  };
}
