{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.hyprhome;
  colors = config.colors;
in
{
  options.hyprhome.rofi = {
    enable = mkOption {
      default = true;
      description = "Whether to enable rofi.";
      type = types.bool;
    };
  };

  config = mkIf (cfg.gui.enable && cfg.rofi.enable) {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      configPath = "${config.xdg.configHome}/rofi/config.rasi";
    };

    xdg.configFile."rofi/config.rasi".text = ''
      /*
       * Colors Penumbar Balanced
       * ~ https://github.com/nealmckee/penumbra/blob/main/penumbra.tsv
       */

      configuration {
          font: "Noto Sans 12";
          display-drun: "Apps ";
          terminal: "wezterm";
          seperator: false;
      }

      * {
          bg:         ${colors.base.sky_}CC;
          red:        ${colors.six.red};
          green:      ${colors.six.green};
          yellow:     ${colors.six.yellow};
          blue:       ${colors.six.blue};
          purple:     ${colors.six.magenta};
          cyan:       ${colors.six.cyan};
          emphasis:   ${colors.six.cyan};
          text:       ${colors.base.sun};
          text-alt:   ${colors.base.sun_};
          fg:         ${colors.base.sun};
          bg-alt:     ${colors.base.sky_};
          gray:       ${colors.base.sky};
          lightgray:  ${colors.base.sky'};

          spacing: 5;

          text-color: @text;
      }

      window {
          x-offset: 5px;
          y-offset: 5px;
          width: 25%;
          background-color: @bg;
          border: 1;
          border-color: @fg;
          border-radius: 9;
          padding: 5;
      }

      mainbox {
      }

      inputbar {
          margin: 0px 0px 4px 0px;
          children: [prompt, textbox-prompt-colon, entry, case-indicator];
      }

      prompt {
          text-color: @cyan;
      }

      textbox-prompt-colon {
          expand: false;
          str: " :";
          text-color: @text-alt;
      }

      entry {
          text-color: @text;
          margin: 0px 10px;
      }

      listview {
          spacing: 0px;
          dynamic: true;
          scrollbar: false;
          columns: 1;
          fixed-height: true;
          lines: 15;
      }

      #element {
          padding: 5px;
          border-radius: 8px;
      }
      #element.normal.normal {
          background-color: transparent;
          text-color:       @fg;
      }
      #element.normal.urgent {
          background-color: transparent;
          text-color:       @red;
      }
      #element.normal.active {
          background-color: @bg;
          text-color:       @cyan;
      }
      #element.selected.normal {
          background-color: @bg-alt;
          text-color:       @fg;
          border: 1px;
          border-color: @fg;
      }
      #element.selected.urgent {
          background-color: @bg;
          text-color:       @red;
          border: 1px;
          border-color: @fg;
      }
      #element.selected.active {
          background-color: @bg;
          text-color:       @cyan;
          border-color: @cyan;
          border: 1px;
          border-color: @fg;
      }
      #element.alternate.normal {
          background-color: transparent;
          text-color:       @fg;
      }
      #element.alternate.urgent {
          background-color: transparent;
          text-color:       @red;
      }
      #element.alternate.active {
          background-color: transparent;
          text-color:       @cyan;
      }

      message {
        padding: 5px;
        border-radius: 3px;
        background-color: @emphasis;
        border: 1px;
        border-color: @cyan;
      }

      button selected {
        padding: 5px;
        border-radius: 3px;
        background-color: @emphasis;
      }
    '';
  };
}
