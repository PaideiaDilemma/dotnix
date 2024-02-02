{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.hyprhome;
  colors = config.colors;
  removeHash = str: removePrefix "#" str;
in
{
  options.hyprhome.foot = {
    enable = mkOption {
      default = true;
      description = "Whether to enable foot terminal";
      type = types.bool;
    };

    fontSize = mkOption {
      default = 8;
      description = "Font size";
      type = types.int;
    };
  };

  config = mkIf (cfg.gui.enable && cfg.foot.enable) {
    programs.foot = {
      enable = true;
      server.enable = true;

      settings = {
        main = {
          font = "Hack Nerd Font Mono:size=${toString cfg.foot.fontSize}";
          dpi-aware = true;
          pad = "5x5";
        };

        scrollback = {
          lines = 5000;
          multiplier = 5.0;
        };

        key-bindings = {
          "search-start" = "Control+Shift+f";
        };

        search-bindings = {
          "next" = "Control+g";
          "previous" = "Control+Shift+g";
        };

        colors = {
          foreground = removeHash colors.base.sun;
          background = removeHash colors.base.shade;
          regular0 = removeHash colors.base.shade;
          regular1 = removeHash colors.six.red;
          regular2 = removeHash colors.six.green;
          regular3 = removeHash colors.six.yellow;
          regular4 = removeHash colors.six.blue;
          regular5 = removeHash colors.six.magenta;
          regular6 = removeHash colors.six.cyan;
          regular7 = removeHash colors.base.sun;
          bright0 = removeHash colors.base.sky_;
          bright1 = removeHash colors.six'.red;
          bright2 = removeHash colors.six'.green;
          bright3 = removeHash colors.six'.yellow;
          bright4 = removeHash colors.six'.blue;
          bright5 = removeHash colors.six'.magenta;
          bright6 = removeHash colors.six'.cyan;
          bright7 = removeHash colors.base.sun';
        };
      };
    };
  };
}
