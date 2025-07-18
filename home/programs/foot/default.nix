{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hyprhome;
  colors = config.colors;
  removeHash = str: removePrefix "#" str;
in {
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
      server.enable = false;
      package = pkgs.foot;

      settings = {
        main = {
          font = "Hack Nerd Font Mono:size=${toString cfg.foot.fontSize}";
          dpi-aware = true;
          pad = "5x5";
          resize-by-cells = "no";
        };

        scrollback = {
          lines = 5000;
          multiplier = 5.0;
        };

        key-bindings = {
          "search-start" = "Control+Shift+f";
        };

        search-bindings = {
          "find-prev" = "Control+p";
          "find-next" = "Control+n";
        };

        colors = {
          foreground = removeHash colors.base.sun;
          background = removeHash colors.base.shade;
          regular0 = removeHash colors.base.shade;
          regular1 = removeHash colors.accent.red;
          regular2 = removeHash colors.accent.green;
          regular3 = removeHash colors.accent.yellow;
          regular4 = removeHash colors.accent.blue;
          regular5 = removeHash colors.accent.orange;
          regular6 = removeHash colors.accent.cyan;
          regular7 = removeHash colors.base.sun;
          bright0 = removeHash colors.base.sky_;
          bright1 = removeHash colors.accent'.red;
          bright2 = removeHash colors.accent'.green;
          bright3 = removeHash colors.accent'.yellow;
          bright4 = removeHash colors.accent'.blue;
          bright5 = removeHash colors.accent'.orange;
          bright6 = removeHash colors.accent'.cyan;
          bright7 = removeHash colors.base.sun';
        };
        colors2 = {
          foreground = removeHash colors.base.shade;
          background = removeHash colors.base.sun;
          regular0 = removeHash colors.base.shade;
          regular1 = removeHash colors.accent.red;
          regular2 = removeHash colors.accent.green;
          regular3 = removeHash colors.accent.yellow;
          regular4 = removeHash colors.accent.blue;
          regular5 = removeHash colors.accent.orange;
          regular6 = removeHash colors.accent.cyan;
          regular7 = removeHash colors.base.sun;
          bright0 = removeHash colors.base.sky_;
          bright1 = removeHash colors.accent'.red;
          bright2 = removeHash colors.accent'.green;
          bright3 = removeHash colors.accent'.yellow;
          bright4 = removeHash colors.accent'.blue;
          bright5 = removeHash colors.accent'.orange;
          bright6 = removeHash colors.accent'.cyan;
          bright7 = removeHash colors.base.sun';
        };
      };
    };
  };
}
