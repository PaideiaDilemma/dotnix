{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.hyprhome;
in
{
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
      package = pkgs.mako;
      anchor = "bottom-left";
      backgroundColor = "#636363";
      textColor = "#FFF7ED";
      margin = "2";
      #outerMargin = 5;
      borderColor = "#FFF7ED";
      borderSize = 1;
      borderRadius = 6;
      progressColor = "over #CB7459CC";
      icons = true;
    };
  };
}
